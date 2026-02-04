import 'package:flutter/material.dart';
import '/Style/app_colors.dart';
import '../../constants/constants.dart';

class RequestSupportPage extends StatefulWidget {
  const RequestSupportPage({Key? key}) : super(key: key);

  @override
  State<RequestSupportPage> createState() => _RequestSupportPageState();
}

class _RequestSupportPageState extends State<RequestSupportPage> {
  final _formKey = GlobalKey<FormState>();
  String? _supportType;
  bool _isAnonymous = false;
  bool _isUrgent = false;
  String _description = '';

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('طلب دعم نفسي'),
          backgroundColor: AppColors.support,
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Header with Privacy Notice
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.support.withOpacity(0.2),
                      AppColors.support.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.psychology,
                      color: AppColors.support,
                      size: 50,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'مساحة آمنة وسرية',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.support,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'كل معلوماتك في سرية تامة. نحن هنا للاستماع والمساعدة.',
                      textAlign: TextAlign.center,
                      style: TextStyle(height: 1.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Anonymous Option
              Card(
                color: _isAnonymous ? AppColors.support.withOpacity(0.1) : null,
                child: SwitchListTile(
                  title: const Text(
                    'استشارة مجهولة الهوية',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text('يمكنك طلب المساعدة دون الكشف عن هويتك'),
                  value: _isAnonymous,
                  activeColor: AppColors.support,
                  onChanged: (value) => setState(() => _isAnonymous = value),
                  secondary: const Icon(Icons.visibility_off),
                ),
              ),
              const SizedBox(height: 20),

              // Support Type
              const Text(
                'نوع الدعم المطلوب',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _supportType,
                decoration: InputDecoration(
                  hintText: 'اختر نوع الدعم',
                  prefixIcon: const Icon(Icons.category),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: AppConstants.supportTypes.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) => setState(() => _supportType = value),
                validator: (value) =>
                    value == null ? 'الرجاء اختيار نوع الدعم' : null,
              ),
              const SizedBox(height: 20),

              // Urgent Toggle
              Card(
                color: _isUrgent ? AppColors.error.withOpacity(0.1) : null,
                child: SwitchListTile(
                  title: const Text(
                    'حالة طارئة',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text('أحتاج للتحدث مع شخص الآن'),
                  value: _isUrgent,
                  activeColor: AppColors.error,
                  onChanged: (value) => setState(() => _isUrgent = value),
                  secondary: const Icon(Icons.emergency),
                ),
              ),
              const SizedBox(height: 20),

              // Description
              const Text(
                'كيف يمكننا مساعدتك؟',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                maxLines: 6,
                maxLength: AppConstants.maxDescriptionLength,
                decoration: InputDecoration(
                  hintText: 'شارك ما تشعر به... نحن هنا للاستماع',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignLabelWithHint: true,
                ),
                onChanged: (value) => _description = value,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'الرجاء كتابة وصف مختصر';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Emergency Contacts
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.error.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.phone_in_talk, color: AppColors.error),
                        SizedBox(width: 8),
                        Text(
                          'خط الطوارئ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.error,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'إذا كنت في خطر فوري، يرجى الاتصال بخط الطوارئ:',
                      style: TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppConstants.emergencyHotline,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Confidentiality Notice
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.lock, color: AppColors.info, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'السرية التامة',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.info,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'جميع المحادثات سرية ولن يتم مشاركتها مع أي شخص. '
                            'سيتواصل معك متخصص مؤهل في أقرب وقت.',
                            style: TextStyle(fontSize: 12, height: 1.5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Submit Button
              ElevatedButton(
                onPressed: _submitRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.support,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _isUrgent ? 'طلب مساعدة عاجلة' : 'إرسال الطلب',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('إلغاء'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _submitRequest() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.check_circle, color: AppColors.success, size: 32),
            SizedBox(width: 12),
            Text('تم استلام طلبك'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isUrgent
                  ? 'سيتواصل معك أحد المتخصصين في أقرب وقت ممكن.'
                  : 'شكراً لثقتك. سيتواصل معك أحد المتخصصين قريباً.',
              style: const TextStyle(height: 1.5),
            ),
            const SizedBox(height: 16),
            if (_isUrgent)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'إذا كانت حالتك طارئة جداً، يرجى الاتصال بخط الطوارئ الآن.',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.warning,
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'رقم الطلب: #SUP-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.info,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back
            },
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }
}
