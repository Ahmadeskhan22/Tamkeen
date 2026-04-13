import 'package:flutter/material.dart';
import '../Style/app_colors.dart';
import '../service/api_service.dart';
import '../constants/api_config.dart';

class VolunteerRegistrationPage extends StatefulWidget {
  const VolunteerRegistrationPage({Key? key}) : super(key: key);

  @override
  State<VolunteerRegistrationPage> createState() =>
      _VolunteerRegistrationPageState();
}

class _VolunteerRegistrationPageState extends State<VolunteerRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  // 1. القاموس: يعرض العربي للمستخدم ويحفظ القيمة الإنجليزية للسيرفر
  final Map<String, String> _availabilityMap = {
    'أوقات مرنة': 'flexible',
    'تفرغ تام': 'full-time',
    'دوام جزئي': 'part-time',
    'عطلة نهاية الأسبوع': 'weekends',
  };

  final Map<String, String> _specializationMap = {
    'أكاديمي (تدريس)': 'academic',
    'دعم نفسي': 'psychological',
    'استشارة قانونية': 'legal',
    'دعم مالي': 'financial',
    'دعم تقني': 'technical',
    'مجالات أخرى': 'other',
  };

  // القيم الافتراضية المختارة (تطابق المفاتيح بالعربي)
  late String _selectedAvailability;
  late String _selectedSpecialization;

  @override
  void initState() {
    super.initState();
    _selectedAvailability = _availabilityMap.keys.first;
    _selectedSpecialization = _specializationMap.keys.first;
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // تحويل النص إلى قائمة مهارات
    List<String> skillsList =
        _skillsController.text.split(',').map((e) => e.trim()).toList();

    // 2. تحويل الخيارات من العربي للإنجليزي قبل الإرسال
    final payload = {
      "skills": skillsList,
      "availability": _availabilityMap[_selectedAvailability],
      "specializations": [_specializationMap[_selectedSpecialization]],
      "bio": _bioController.text,
    };

    try {
      await ApiService.post('/api/volunteers', payload);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('تم استلام طلبك بنجاح! 🎉'),
            backgroundColor: AppColors.success),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('أنت مسجل مسبقاً أو حدث خطأ في البيانات'),
            backgroundColor: AppColors.error),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
            title: const Text('التسجيل كمتطوع'),
            backgroundColor: AppColors.primary),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _buildLabel('التخصص التطوعي'),
              DropdownButtonFormField<String>(
                value: _selectedSpecialization,
                items: _specializationMap.keys
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) =>
                    setState(() => _selectedSpecialization = val!),
                decoration: _inputDecoration(),
              ),
              const SizedBox(height: 20),
              _buildLabel('أوقات التفرغ'),
              DropdownButtonFormField<String>(
                value: _selectedAvailability,
                items: _availabilityMap.keys
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) =>
                    setState(() => _selectedAvailability = val!),
                decoration: _inputDecoration(),
              ),
              const SizedBox(height: 20),
              _buildLabel('المهارات (افصل بينها بفاصلة)'),
              TextFormField(
                controller: _skillsController,
                decoration:
                    _inputDecoration(hint: 'مثال: رياضيات, برمجة, تواصل'),
                validator: (val) =>
                    val!.isEmpty ? 'الرجاء إدخال مهارة واحدة على الأقل' : null,
              ),
              const SizedBox(height: 20),
              _buildLabel('نبذة عنك'),
              TextFormField(
                controller: _bioController,
                maxLines: 4,
                decoration: _inputDecoration(hint: 'اكتب نبذة قصيرة عن خبراتك'),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('إرسال طلب التطوع',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // أدوات مساعدة للتصميم (Helper methods)
  Widget _buildLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(text,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      );

  InputDecoration _inputDecoration({String? hint}) => InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[50],
      );
}
