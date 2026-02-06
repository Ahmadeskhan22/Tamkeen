import 'package:flutter/material.dart';
import '/Style/app_colors.dart';
import '../../constants/constants.dart';
import '../../service/service_card.dart';
import '/Dashboard/Request_supplies.dart';
import '/request/Request_tutoring.dart';
import '/request/Request_meals.dart';
import '/request/Request_support.dart';
import '/request/Request_uniform.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({Key? key}) : super(key: key);

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const StudentHomePage(),
    const MyRequestsPage(),
    const StudentProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          selectedItemColor: AppColors.primary,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: 'طلباتي',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'حسابي'),
          ],
        ),
      ),
    );
  }
}

class StudentHomePage extends StatelessWidget {
  const StudentHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 180,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: const Text(
              'لوحة الطالب',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            background: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Icon(
                      Icons.school,
                      size: 50,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'مرحباً بك! 👋',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'اختر الخدمة التي تحتاجها',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Quick Stats
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'طلبات نشطة',
                    '3',
                    Icons.pending_actions,
                    AppColors.warning,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'طلبات مكتملة',
                    '7',
                    Icons.check_circle,
                    AppColors.success,
                  ),
                ),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                const Text(
                  'الخدمات المتاحة',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'اضغط على الخدمة لتقديم طلب جديد',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
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
                    builder: (_) => const RequestSuppliesPage(),
                  ),
                ),
              ),
              ServiceCard(
                title: 'الزي المدرسي',
                description: 'زي موحد وملابس',
                icon: Icons.checkroom,
                color: AppColors.uniform,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RequestUniformPage()),
                ),
              ),
              ServiceCard(
                title: 'دروس تطوعية',
                description: 'مساعدة في المواد',
                icon: Icons.menu_book,
                color: AppColors.tutoring,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RequestTutoringPage(),
                  ),
                ),
              ),
              ServiceCard(
                title: 'وجبات مدرسية',
                description: 'وجبات صحية',
                icon: Icons.restaurant,
                color: AppColors.meals,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RequestMealsPage()),
                ),
              ),
              ServiceCard(
                title: 'دعم نفسي',
                description: 'استشارات سرية',
                icon: Icons.psychology,
                color: AppColors.support,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RequestSupportPage()),
                ),
              ),
            ]),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 20)),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
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
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class MyRequestsPage extends StatelessWidget {
  const MyRequestsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(title: Text('طلباتي'), pinned: true),
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildRequestCard(
                'طلب أدوات مدرسية',
                'قيد المراجعة',
                'منذ يومين',
                AppColors.warning,
                Icons.pending,
              ),
              const SizedBox(height: 12),
              _buildRequestCard(
                'طلب وجبة غداء',
                'تمت الموافقة',
                'منذ أسبوع',
                AppColors.success,
                Icons.check_circle,
              ),
              const SizedBox(height: 12),
              _buildRequestCard(
                'طلب زي مدرسي',
                'مكتمل',
                'منذ أسبوعين',
                AppColors.info,
                Icons.done_all,
              ),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildRequestCard(
    String title,
    String status,
    String time,
    Color statusColor,
    IconData statusIcon,
  ) {
    return Card(
      child: ListTile(
        leading: Icon(statusIcon, color: statusColor, size: 32),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(time, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            status,
            style: TextStyle(
              color: statusColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class StudentProfilePage extends StatelessWidget {
  const StudentProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(title: Text('حسابي'), pinned: true),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 16),
                const Text(
                  ' أحمد',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'الصف رابع ',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),
                _buildProfileOption(Icons.edit, 'تعديل الملف الشخصي', () {}),
                _buildProfileOption(Icons.notifications, 'الإشعارات', () {}),
                _buildProfileOption(
                  Icons.privacy_tip,
                  'الخصوصية والأمان',
                  () {},
                ),
                _buildProfileOption(Icons.help, 'المساعدة والدعم', () {}),
                _buildProfileOption(
                  Icons.logout,
                  'تسجيل الخروج',
                  () {},
                  isDestructive: true,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileOption(
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDestructive ? AppColors.error : AppColors.primary,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDestructive ? AppColors.error : AppColors.textPrimary,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
