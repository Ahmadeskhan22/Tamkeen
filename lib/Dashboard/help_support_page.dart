import 'package:flutter/material.dart';
import '../Style/app_colors.dart'; //

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('المساعدة والدعم'),
          backgroundColor: AppColors.primary,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // ── قسم عن التطبيق ──
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.volunteer_activism,
                        size: 60, color: AppColors.primary),
                  ),
                  const SizedBox(height: 16),
                  const Text('تطبيق خطوات الأمل',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text(
                    'نحن هنا لربط الطلاب المحتاجين بالمتبرعين والمتطوعين لدعم مسيرتهم التعليمية وتوفير بيئة مناسبة للنجاح.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14, height: 1.5, color: Colors.black87),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            const Text('شركاء النجاح والداعمين',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildSponsorCard('مؤسسة التعليم للجميع',
                'داعم استراتيجي للمستلزمات المدرسية', Icons.business),
            _buildSponsorCard('صندوق الطالب الخيري',
                'كفالة الطلاب والدعم المالي', Icons.account_balance),
            _buildSponsorCard('مبادرة فاعلي الخير', 'توفير الوجبات والملابس',
                Icons.diversity_1),
            const SizedBox(height: 32),

            const Text('تواصل معنا',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildContactRow(
                Icons.email, 'البريد الإلكتروني', 'support@hopesteps.com'),
            const Divider(),
            _buildContactRow(Icons.phone, 'رقم الهاتف', '+962 7X XXX XXXX'),
            const Divider(),
            _buildContactRow(
                Icons.location_on, 'العنوان', 'الأردن - عمان - مقر المبادرة'),
          ],
        ),
      ),
    );
  }

  Widget _buildSponsorCard(String name, String desc, IconData icon) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(desc, style: const TextStyle(fontSize: 12)),
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[700]),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      subtitle: Text(subtitle,
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black)),
      contentPadding: EdgeInsets.zero,
    );
  }
}
