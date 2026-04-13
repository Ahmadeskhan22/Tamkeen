// lib/Dashboard/Donor_dashboard.dart
// تم حذف قسم "الاحتياجات" المكسور واستبداله بواجهة تبرع عامة

import 'package:flutter/material.dart';
import '../Style/app_colors.dart';
import '../auth/auth_service.dart';
import '../auth/login_page.dart';

class DonorDashboard extends StatelessWidget {
  const DonorDashboard({Key? key}) : super(key: key);

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

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('بوابة المتبرعين'),
          backgroundColor: AppColors.secondary,
          actions: [
            IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => _logout(context)),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // بطاقة ترحيب فخمة
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: AppColors.secondaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(Icons.volunteer_activism,
                      color: Colors.white, size: 60),
                  const SizedBox(height: 12),
                  Text(
                    'أهلاً بك يا ${user?.name ?? "فاعل الخير"}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const Text('تبرعك الصغير يصنع فرقاً كبيراً في حياة طالب',
                      style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text('كيف تود المساعدة اليوم؟',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildActionCard(
                context,
                'تبرع بمواد عينية',
                'حقائب، زي مدرسي، قرطاسية',
                Icons.inventory_2,
                AppColors.supplies),
            _buildActionCard(
                context,
                'كفالة تعليمية',
                'دعم الرسوم الدراسية والدروس',
                Icons.school,
                AppColors.tutoring),
            _buildActionCard(
                context,
                'تبرع بالوجبات',
                'دعم صندوق الوجبات المدرسية',
                Icons.restaurant,
                AppColors.meals),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, String title, String subtitle,
      IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(icon, color: color, size: 32),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_left),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('سنتواصل معك قريباً لترتيب استلام التبرع 🎁')));
        },
      ),
    );
  }
}
