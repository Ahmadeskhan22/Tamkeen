// lib/Dashboard/Volunteer_dashboard.dart
// FIXES:
//  - Corrected all import paths (removed unused request imports)
//  - Opportunity counts loaded from real API
//  - Logout connected

import 'package:flutter/material.dart';
import '../Style/app_colors.dart';
import '../service/api_service.dart';
import '../constants/api_config.dart';
import '../auth/auth_service.dart';
import '../auth/login_page.dart';

class VolunteerDashboard extends StatefulWidget {
  const VolunteerDashboard({Key? key}) : super(key: key);

  @override
  State<VolunteerDashboard> createState() => _VolunteerDashboardState();
}

class _VolunteerDashboardState extends State<VolunteerDashboard> {
  Map<String, int> _counts = {'tutoring': 0, 'psychological': 0, 'supplies': 0};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCounts();
  }

  Future<void> _loadCounts() async {
    try {
      // Fetch pending/approved requests to show opportunity counts
      final data = await ApiService.get(ApiConfig.requests,
          queryParams: {'status': 'approved', 'limit': '100'});
      final requests = (data['data'] as List);
      final Map<String, int> counts = {
        'tutoring': 0,
        'psychological': 0,
        'supplies': 0
      };
      for (final r in requests) {
        final type = r['type'] as String? ?? '';
        if (counts.containsKey(type)) counts[type] = counts[type]! + 1;
      }
      if (!mounted) return;
      setState(() {
        _counts = counts;
        _isLoading = false;
      });
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _logout() async {
    await AuthService.instance.logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('لوحة المتطوعين'),
          backgroundColor: AppColors.primary,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _logout,
              tooltip: 'تسجيل الخروج',
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _loadCounts,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.volunteer_activism,
                        color: Colors.white, size: 60),
                    const SizedBox(height: 12),
                    Text(
                      user != null
                          ? 'شكراً، ${user.name}، لرغبتك في التطوع!'
                          : 'شكراً لرغبتك في التطوع!',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'وقتك ومهاراتك يمكن أن تصنع فرقاً حقيقياً',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text('فرص التطوع المتاحة',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else ...[
                _buildOpportunityCard(
                  'معلم متطوع',
                  'ساعد الطلاب في المواد الدراسية',
                  Icons.menu_book,
                  AppColors.tutoring,
                  '${_counts['tutoring']} طلب',
                ),
                const SizedBox(height: 12),
                _buildOpportunityCard(
                  'مستشار نفسي',
                  'دعم نفسي واستشارات للطلاب',
                  Icons.psychology,
                  AppColors.support,
                  '${_counts['psychological']} طلب',
                ),
                const SizedBox(height: 12),
                _buildOpportunityCard(
                  'منسق توزيع',
                  'المساعدة في توزيع الأدوات والمستلزمات',
                  Icons.inventory,
                  AppColors.supplies,
                  '${_counts['supplies']} طلب',
                ),
              ],
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('كيف تبدأ؟',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 12),
                    Text('1. سجل بياناتك ومهاراتك'),
                    SizedBox(height: 8),
                    Text('2. اختر المجال الذي تريد التطوع فيه'),
                    SizedBox(height: 8),
                    Text('3. سنتواصل معك لترتيب التفاصيل'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('سجل كمتطوع',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOpportunityCard(String title, String description, IconData icon,
      Color color, String badge) {
    return Card(
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: color.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(description),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12)),
              child: Text(badge,
                  style: TextStyle(
                      fontSize: 11, color: color, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        isThreeLine: true,
        onTap: () {},
      ),
    );
  }
}
