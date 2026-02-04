import 'package:flutter/material.dart';
import '/Style/app_colors.dart';
import '../../constants/constants.dart';
import '../../service/service_card.dart';
import '/Dashboard/Request_supplies.dart';
import '/request/Request_tutoring.dart';
import '/request/Request_meals.dart';
import '/request/Request_support.dart';
import '/request/Request_uniform.dart';

class VolunteerDashboard extends StatelessWidget {
  const VolunteerDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('لوحة المتطوعين'),
          backgroundColor: AppColors.primary,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: const [
                  Icon(Icons.volunteer_activism, color: Colors.white, size: 60),
                  SizedBox(height: 12),
                  Text(
                    'شكراً لرغبتك في التطوع!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'وقتك ومهاراتك يمكن أن تصنع فرقاً حقيقياً',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'فرص التطوع المتاحة',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildOpportunityCard(
              'معلم متطوع',
              'ساعد الطلاب في المواد الدراسية',
              Icons.menu_book,
              AppColors.tutoring,
              '5 طلاب بحاجة لمساعدة',
            ),
            const SizedBox(height: 12),
            _buildOpportunityCard(
              'مستشار نفسي',
              'دعم نفسي واستشارات للطلاب',
              Icons.psychology,
              AppColors.support,
              '3 طلبات جديدة',
            ),
            const SizedBox(height: 12),
            _buildOpportunityCard(
              'منسق توزيع',
              'المساعدة في توزيع الأدوات والمستلزمات',
              Icons.inventory,
              AppColors.supplies,
              '10 طلبات قيد الانتظار',
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'كيف تبدأ؟',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
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
              child: const Text(
                'سجل كمتطوع',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOpportunityCard(
    String title,
    String description,
    IconData icon,
    Color color,
    String badge,
  ) {
    return Card(
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
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
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                badge,
                style: TextStyle(
                  fontSize: 11,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        isThreeLine: true,
      ),
    );
  }
}
