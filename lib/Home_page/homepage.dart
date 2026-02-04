import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import '/Style/app_colors.dart';
import '../../constants/constants.dart';
import '../../service/service_card.dart';
import '/Dashboard/Request_supplies.dart';
import '/request/Request_tutoring.dart';
import '/request/Request_meals.dart';
import '/request/Request_support.dart';
import '/request/Request_uniform.dart';
import '/Dashboard/Student_dashboard.dart';
import '/Dashboard/Volunteer_dashboard.dart';
import '/Dashboard/Donor_dashboard.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  AppConstants.appNameArabic,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
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
                          Icons.volunteer_activism,
                          size: 60,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppConstants.appTagline,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Welcome Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'مرحباً بك في خطوات الأمل',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'منصة مجتمعية لدعم الطلاب المحتاجين بكرامة واحترام',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Quick Access Buttons
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildQuickAccessButton(
                        context,
                        'أنا طالب محتاج',
                        Icons.school,
                        AppColors.primary,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const StudentDashboard(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildQuickAccessButton(
                        context,
                        'أريد المساعدة',
                        Icons.favorite,
                        AppColors.secondary,
                        () => _showHelpOptions(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Services Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'الخدمات المتاحة',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'اختر الخدمة التي تحتاجها',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),

            // Service Cards Grid
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
                    description: 'حقائب، دفاتر، أقلام، وكتب',
                    icon: Icons.backpack,
                    color: AppColors.supplies,
                    onTap: () => _navigateToService(context, 'supplies'),
                  ),
                  ServiceCard(
                    title: 'الزي المدرسي',
                    description: 'زي موحد وملابس شتوية',
                    icon: Icons.checkroom,
                    color: AppColors.uniform,
                    onTap: () => _navigateToService(context, 'uniform'),
                  ),
                  ServiceCard(
                    title: 'دروس تطوعية',
                    description: 'مساعدة مجانية في المواد',
                    icon: Icons.menu_book,
                    color: AppColors.tutoring,
                    onTap: () => _navigateToService(context, 'tutoring'),
                  ),
                  ServiceCard(
                    title: 'وجبات مدرسية',
                    description: 'وجبات صحية يومية',
                    icon: Icons.restaurant,
                    color: AppColors.meals,
                    onTap: () => _navigateToService(context, 'meals'),
                  ),
                  ServiceCard(
                    title: 'دعم نفسي',
                    description: 'استشارات نفسية سرية',
                    icon: Icons.psychology,
                    color: AppColors.support,
                    onTap: () => _navigateToService(context, 'support'),
                  ),
                  ServiceCard(
                    title: 'طوارئ',
                    description: 'مساعدة عاجلة',
                    icon: Icons.emergency,
                    color: AppColors.error,
                    onTap: () => _showEmergencyContact(context),
                  ),
                ]),
              ),
            ),

            // Statistics Section
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Text(
                      'إنجازاتنا معاً',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem('500+', 'طالب مُساعد'),
                        _buildStatItem('200+', 'متطوع'),
                        _buildStatItem('1000+', 'طلب مُنجز'),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // About Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.info_outline, color: AppColors.primary),
                            SizedBox(width: 8),
                            Text(
                              'عن المنصة',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'خطوات الأمل هي منصة إنسانية مجتمعية مصممة لدعم الطلاب المحتاجين. '
                          'نوفر خدمات مجانية تماماً بما في ذلك الأدوات المدرسية، الزي الموحد، '
                          'الدروس التطوعية، الوجبات المدرسية، والدعم النفسي. '
                          'نؤمن بأن كل طفل يستحق فرصة متساوية في التعليم.',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Footer
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Divider(),
                    const SizedBox(height: 12),
                    Text(
                      '© 2024 ${AppConstants.appNameArabic}',
                      style: TextStyle(
                        color: AppColors.textLight,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'معاً نصنع الفرق',
                      style: TextStyle(
                        color: AppColors.textLight,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.9)),
        ),
      ],
    );
  }

  void _navigateToService(BuildContext context, String serviceType) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const StudentDashboard()),
    );
  }

  void _showHelpOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'كيف تريد المساعدة؟',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(
                Icons.volunteer_activism,
                color: AppColors.primary,
              ),
              title: const Text('أريد التطوع'),
              subtitle: const Text('ساعد الطلاب بوقتك ومهاراتك'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const VolunteerDashboard()),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.card_giftcard,
                color: AppColors.secondary,
              ),
              title: const Text('أريد التبرع'),
              subtitle: const Text('تبرع بالأدوات والمستلزمات'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DonorDashboard()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEmergencyContact(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('خط الطوارئ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'في حالة الطوارئ، يمكنك التواصل معنا:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: const [
                Icon(Icons.phone, color: AppColors.error),
                SizedBox(width: 8),
                Text(AppConstants.emergencyHotline),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: const [
                Icon(Icons.email, color: AppColors.error),
                SizedBox(width: 8),
                Expanded(child: Text(AppConstants.supportEmail)),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }
}
