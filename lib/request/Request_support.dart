// lib/request/Request_support.dart
// FIX: POST to /api/requests with type:'psychological'

import 'package:flutter/material.dart';
import '../Style/app_colors.dart';
import '../constants/constants.dart';
import '../service/api_service.dart';
import '../constants/api_config.dart';

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
  bool _isLoading = false;

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
                child: const Column(
                  children: [
                    Icon(Icons.psychology, color: AppColors.support, size: 50),
                    SizedBox(height: 12),
                    Text(
                      'مساحة آمنة وسرية',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.support),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'كل معلوماتك في سرية تامة. نحن هنا للاستماع والمساعدة.',
                      textAlign: TextAlign.center,
                      style: TextStyle(height: 1.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Card(
                color: _isAnonymous ? AppColors.support.withOpacity(0.1) : null,
                child: SwitchListTile(
                  title: const Text('استشارة مجهولة الهوية',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text('يمكنك طلب المساعدة دون الكشف عن هويتك'),
                  value: _isAnonymous,
                  activeColor: AppColors.support,
                  onChanged: (v) => setState(() => _isAnonymous = v),
                  secondary: const Icon(Icons.visibility_off),
                ),
              ),
              const SizedBox(height: 20),
              const Text('نوع الدعم المطلوب',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _supportType,
                decoration: InputDecoration(
                  hintText: 'اختر نوع الدعم',
                  prefixIcon: const Icon(Icons.category),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                items: AppConstants.supportTypes
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (v) => setState(() => _supportType = v),
                validator: (v) => v == null ? 'الرجاء اختيار نوع الدعم' : null,
              ),
              const SizedBox(height: 20),
              Card(
                color: _isUrgent ? AppColors.error.withOpacity(0.1) : null,
                child: SwitchListTile(
                  title: const Text('حالة طارئة',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text('أحتاج للتحدث مع شخص الآن'),
                  value: _isUrgent,
                  activeColor: AppColors.error,
                  onChanged: (v) => setState(() => _isUrgent = v),
                  secondary: const Icon(Icons.emergency),
                ),
              ),
              const SizedBox(height: 20),
              const Text('كيف يمكننا مساعدتك؟',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                maxLines: 6,
                maxLength: AppConstants.maxDescriptionLength,
                decoration: InputDecoration(
                  hintText: 'شارك ما تشعر به... نحن هنا للاستماع',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  alignLabelWithHint: true,
                ),
                onChanged: (v) => _description = v,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'الرجاء كتابة وصف مختصر';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Emergency box
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
                    const Row(
                      children: [
                        Icon(Icons.phone_in_talk, color: AppColors.error),
                        SizedBox(width: 8),
                        Text('خط الطوارئ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.error)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                        'إذا كنت في خطر فوري، يرجى الاتصال بخط الطوارئ:'),
                    const SizedBox(height: 8),
                    Text(
                      AppConstants.emergencyHotline,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.error),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.support,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2.5))
                    : Text(
                        _isUrgent ? 'طلب مساعدة عاجلة' : 'إرسال الطلب',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16)),
                child: const Text('إلغاء'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await ApiService.post(ApiConfig.requests, {
        'title': _isUrgent ? 'طلب دعم نفسي عاجل' : 'طلب دعم نفسي',
        'description': _description,
        'type': 'psychological',
        'urgency': _isUrgent ? 'critical' : 'medium',
        'isPublic': !_isAnonymous,
        'supportType': _supportType,
        'isAnonymous': _isAnonymous,
      });

      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Row(children: [
            Icon(Icons.check_circle, color: AppColors.success, size: 32),
            SizedBox(width: 12),
            Text('تم استلام طلبك'),
          ]),
          content: Text(
            _isUrgent
                ? 'سيتواصل معك أحد المتخصصين في أقرب وقت ممكن.'
                : 'شكراً لثقتك. سيتواصل معك أحد المتخصصين قريباً.',
            style: const TextStyle(height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('حسناً'),
            ),
          ],
        ),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(e.userMessage), backgroundColor: AppColors.error),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
