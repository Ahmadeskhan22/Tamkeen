// lib/request/Request_uniform.dart
// FIX: POST to /api/requests with type:'uniform'

import 'package:flutter/material.dart';
import '../Style/app_colors.dart';
import '../constants/constants.dart';
import '../service/api_service.dart';
import '../constants/api_config.dart';

class RequestUniformPage extends StatefulWidget {
  const RequestUniformPage({Key? key}) : super(key: key);

  @override
  State<RequestUniformPage> createState() => _RequestUniformPageState();
}

class _RequestUniformPageState extends State<RequestUniformPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedGrade;
  String? _uniformSize;
  bool _needWinterClothing = false;
  String? _winterSize;
  String _additionalNotes = '';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('طلب زي مدرسي')),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.uniform.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.uniform.withOpacity(0.3)),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.checkroom, color: AppColors.uniform, size: 48),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('الزي المدرسي',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.uniform)),
                          SizedBox(height: 4),
                          Text('زي موحد نظيف ومناسب',
                              style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text('الصف الدراسي',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedGrade,
                decoration: InputDecoration(
                  hintText: 'اختر الصف',
                  prefixIcon: const Icon(Icons.school),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                items: AppConstants.gradeLevels
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedGrade = v),
                validator: (v) => v == null ? 'الرجاء اختيار الصف' : null,
              ),
              const SizedBox(height: 20),
              const Text('مقاس الزي المدرسي',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _uniformSize,
                decoration: InputDecoration(
                  hintText: 'اختر المقاس',
                  prefixIcon: const Icon(Icons.straighten),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                items: AppConstants.uniformSizes
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => setState(() => _uniformSize = v),
                validator: (v) => v == null ? 'الرجاء اختيار المقاس' : null,
              ),
              const SizedBox(height: 24),
              Card(
                color: _needWinterClothing
                    ? AppColors.info.withOpacity(0.1)
                    : null,
                child: Column(
                  children: [
                    CheckboxListTile(
                      title: const Text('أحتاج ملابس شتوية',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: const Text('معطف، سترة، أو ملابس دافئة'),
                      value: _needWinterClothing,
                      activeColor: AppColors.uniform,
                      onChanged: (v) =>
                          setState(() => _needWinterClothing = v ?? false),
                      secondary: const Icon(Icons.ac_unit),
                    ),
                    if (_needWinterClothing) ...[
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: DropdownButtonFormField<String>(
                          value: _winterSize,
                          decoration: InputDecoration(
                            labelText: 'مقاس الملابس الشتوية',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          items: AppConstants.uniformSizes
                              .map((s) =>
                                  DropdownMenuItem(value: s, child: Text(s)))
                              .toList(),
                          onChanged: (v) => setState(() => _winterSize = v),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text('ملاحظات إضافية',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'أي تفاصيل أخرى...',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onChanged: (v) => _additionalNotes = v,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.uniform,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2.5))
                    : const Text('إرسال الطلب',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إلغاء'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    // بناء وصف مفصل ودقيق للطلب عشان الإدارة تفهم الاحتياج بالضبط
    String desc = 'الصف الدراسي: $_selectedGrade | مقاس الزي: $_uniformSize';
    if (_needWinterClothing) {
      desc +=
          ' | بحاجة لملابس شتوية${_winterSize != null ? ' (مقاس: $_winterSize)' : ''}';
    }
    if (_additionalNotes.isNotEmpty) {
      desc += '\nملاحظات: $_additionalNotes';
    }

    try {
      // إرسال البيانات للسيرفر
      await ApiService.post(ApiConfig.requests, {
        'title': 'طلب زي مدرسي',
        'description': desc,
        'type': 'clothes', // ✅ تم التعديل لتطابق الباك إند
        'urgency': 'medium',
        'isPublic': true,
        // إرسال باقي الحقول الإضافية (رح تتخزن كـ Metadata في الداتابيز)
        'grade': _selectedGrade,
        'uniformSize': _uniformSize,
        'needWinterClothing': _needWinterClothing,
        if (_winterSize != null) 'winterSize': _winterSize,
        'notes': _additionalNotes,
      });

      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Row(children: [
            Icon(Icons.check_circle, color: AppColors.success),
            SizedBox(width: 8),
            Text('تم إرسال الطلب'),
          ]),
          content: const Text('تم استلام طلبك بنجاح وسيتم مراجعته قريباً.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // إغلاق الـ Dialog
                Navigator.pop(context); // الرجوع للرئيسية
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
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('حدث خطأ في الاتصال بالسيرفر'),
            backgroundColor: AppColors.error),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
