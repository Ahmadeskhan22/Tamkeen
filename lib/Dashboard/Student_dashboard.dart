// lib/Dashboard/Student_dashboard.dart

import 'package:flutter/material.dart';
import '../Style/app_colors.dart';
import '../constants/constants.dart';
import '../service/service_card.dart';
import '../request/Request_supplies.dart';
import '../request/Request_tutoring.dart';
import '../request/Request_meals.dart';
import '../request/Request_support.dart';
import '../request/Request_uniform.dart';
import '../service/api_service.dart';
import '../constants/api_config.dart';
import '../models/request_model.dart';
import '../auth/auth_service.dart';
import '../auth/login_page.dart';
import 'edit_student_profile.dart';
import 'help_support_page.dart';
import 'notifications_page.dart';
import 'privacy_security_page.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({Key? key}) : super(key: key);

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  int _selectedIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const StudentHomePage(),
      const MyRequestsPage(),
      const StudentProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: IndexedStack(index: _selectedIndex, children: _pages),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (i) => setState(() => _selectedIndex = i),
          selectedItemColor: AppColors.primary,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
            BottomNavigationBarItem(
                icon: Icon(Icons.list_alt), label: 'طلباتي'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'حسابي'),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Home tab
// ─────────────────────────────────────────────────────────────────────────────

class StudentHomePage extends StatelessWidget {
  const StudentHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 180,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: const Text('لوحة الطالب',
                style: TextStyle(fontWeight: FontWeight.bold)),
            background: Container(
              decoration:
                  const BoxDecoration(gradient: AppColors.primaryGradient),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Icon(Icons.school,
                        size: 50, color: Colors.white.withOpacity(0.9)),
                  ],
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مرحباً${user != null && user.name.isNotEmpty ? '، ${user.name}' : ''} 👋',
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                const Text('اختر الخدمة التي تحتاجها',
                    style: TextStyle(
                        fontSize: 15, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: _QuickStats(),
          ),
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: Text('الخدمات المتاحة',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            delegate: SliverChildListDelegate([
              ServiceCard(
                title: 'الأدوات المدرسية',
                description: 'حقائب، دفاتر، أقلام',
                icon: Icons.backpack,
                color: AppColors.supplies,
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const RequestSuppliesPage())),
              ),
              ServiceCard(
                title: 'الزي المدرسي',
                description: 'زي موحد وملابس',
                icon: Icons.checkroom,
                color: AppColors.uniform,
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const RequestUniformPage())),
              ),
              ServiceCard(
                title: 'دروس تطوعية',
                description: 'مساعدة في المواد',
                icon: Icons.menu_book,
                color: AppColors.tutoring,
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const RequestTutoringPage())),
              ),
              ServiceCard(
                title: 'وجبات مدرسية',
                description: 'وجبات صحية',
                icon: Icons.restaurant,
                color: AppColors.meals,
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const RequestMealsPage())),
              ),
              ServiceCard(
                title: 'دعم نفسي',
                description: 'استشارات سرية',
                icon: Icons.psychology,
                color: AppColors.support,
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const RequestSupportPage())),
              ),
            ]),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}

/// Quick stats widget
class _QuickStats extends StatefulWidget {
  const _QuickStats({Key? key}) : super(key: key);

  @override
  State<_QuickStats> createState() => _QuickStatsState();
}

class _QuickStatsState extends State<_QuickStats> {
  int _active = 0;
  int _completed = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      // 1. تم تعديل المسار لتجنب مشكلة الـ myRequests الغير معرفة
      final data = await ApiService.get('${ApiConfig.requests}/my');
      final requests = (data['data'] as List)
          .map((e) => RequestModel.fromJson(e as Map<String, dynamic>))
          .toList();

      if (!mounted) return;

      setState(() {
        _active = requests
            .where((r) => ['pending', 'under_review', 'approved', 'in_progress']
                .contains(r.status))
            .length;
        _completed = requests
            .where((r) => ['fulfilled', 'closed'].contains(r.status))
            .length;
      });
    } catch (_) {
      // تجاهل الخطأ بصمت لتبقى الأصفار كما هي
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: _statCard('طلبات نشطة', '$_active', Icons.pending_actions,
                AppColors.warning)),
        const SizedBox(width: 12),
        Expanded(
            child: _statCard('طلبات مكتملة', '$_completed', Icons.check_circle,
                AppColors.success)),
      ],
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(value,
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  My Requests tab
// ─────────────────────────────────────────────────────────────────────────────

class MyRequestsPage extends StatefulWidget {
  const MyRequestsPage({Key? key}) : super(key: key);

  @override
  State<MyRequestsPage> createState() => _MyRequestsPageState();
}

class _MyRequestsPageState extends State<MyRequestsPage> {
  List<RequestModel> _requests = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      // 2. تم تعديل المسار هنا أيضاً
      final data = await ApiService.get('${ApiConfig.requests}/my');

      if (!mounted) return;
      setState(() {
        _requests = (data['data'] as List)
            .map((e) => RequestModel.fromJson(e as Map<String, dynamic>))
            .toList();
        _isLoading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.userMessage;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'حدث خطأ، حاول مرة أخرى';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadRequests,
      color: AppColors.primary,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          const SliverAppBar(title: Text('طلباتي'), pinned: true),
          if (_isLoading)
            const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()))
          else if (_error != null)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 60, color: AppColors.error),
                    const SizedBox(height: 16),
                    Text(_error!),
                    const SizedBox(height: 16),
                    ElevatedButton(
                        onPressed: _loadRequests,
                        child: const Text('إعادة المحاولة')),
                  ],
                ),
              ),
            )
          else if (_requests.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox, size: 80, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('لا توجد طلبات بعد',
                        style: TextStyle(
                            fontSize: 18, color: AppColors.textSecondary)),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _RequestCard(request: _requests[i]),
                  ),
                  childCount: _requests.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final RequestModel request;
  const _RequestCard({required this.request});

  Color get _statusColor {
    switch (request.status) {
      case 'fulfilled':
        return AppColors.success;
      case 'approved':
        return AppColors.info;
      case 'rejected':
        return AppColors.error;
      case 'in_progress':
        return AppColors.primary;
      default:
        return AppColors.warning;
    }
  }

  IconData get _statusIcon {
    switch (request.status) {
      case 'fulfilled':
        return Icons.done_all;
      case 'approved':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      case 'in_progress':
        return Icons.autorenew;
      default:
        return Icons.pending;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(_statusIcon, color: _statusColor, size: 32),
        title: Text(request.title,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(request.typeLabel,
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary)),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            request.statusLabel,
            style: TextStyle(
                color: _statusColor, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Profile tab
// ─────────────────────────────────────────────────────────────────────────────

class StudentProfilePage extends StatelessWidget {
  const StudentProfilePage({Key? key}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    await AuthService.instance.logout();
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;

    return CustomScrollView(
      slivers: [
        const SliverAppBar(title: Text('حسابي'), pinned: true),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    // 3. تأكدنا إنه الحرف الأول بشتغل بدون ما يعمل كراش إذا كان الاسم فاضي
                    (user != null && user.name.isNotEmpty)
                        ? user.name[0].toUpperCase()
                        : '؟',
                    style: const TextStyle(
                        fontSize: 36,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                Text(user?.name ?? 'الطالب',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(user?.email ?? '',
                    style: const TextStyle(
                        fontSize: 14, color: AppColors.textSecondary)),
                if (user?.isVerified == true) ...[
                  const SizedBox(height: 8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.verified, color: AppColors.info, size: 18),
                      SizedBox(width: 4),
                      Text('حساب موثّق',
                          style:
                              TextStyle(color: AppColors.info, fontSize: 13)),
                    ],
                  ),
                ],
                const SizedBox(height: 32),
                _option(Icons.edit, 'تعديل الملف الشخصي', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            const EditStudentProfilePage()), // لا تنسى تعمل Import للملف فوق
                  );
                }, context),
                _option(Icons.notifications, 'الإشعارات', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const NotificationsPage()),
                  );
                }, context),
                //_option(Icons.notifications, 'الإشعارات', () {}, context),
                _option(Icons.privacy_tip, 'الخصوصية والأمان', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            const PrivacySecurityPage()), // تأكد تعمل import للملف فوق
                  );
                }, context),
                //_option(Icons.help, 'المساعدة والدعم', () {}, context),
                _option(Icons.help, 'المساعدة والدعم', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            const HelpSupportPage()), // لا تنسى تعمل Import للملف فوق
                  );
                }, context),
                _option(Icons.logout, 'تسجيل الخروج', () => _logout(context),
                    context,
                    isDestructive: true),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _option(
      IconData icon, String title, VoidCallback onTap, BuildContext context,
      {bool isDestructive = false}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon,
            color: isDestructive ? AppColors.error : AppColors.primary),
        title: Text(title,
            style: TextStyle(
                color:
                    isDestructive ? AppColors.error : AppColors.textPrimary)),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
