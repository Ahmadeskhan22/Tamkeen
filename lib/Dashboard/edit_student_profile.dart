import 'package:flutter/material.dart';
import '../Style/app_colors.dart';
import '../service/api_service.dart';
import '../constants/constants.dart';

class EditStudentProfilePage extends StatefulWidget {
  const EditStudentProfilePage({Key? key}) : super(key: key);

  @override
  State<EditStudentProfilePage> createState() => _EditStudentProfilePageState();
}

class _EditStudentProfilePageState extends State<EditStudentProfilePage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;
  bool _isSaving = false;

  final TextEditingController _schoolController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  String? _selectedGrade;

  @override
  void initState() {
    super.initState();
    _loadCurrentData();
  }

  Future<void> _loadCurrentData() async {
    try {
      final response = await ApiService.get('/api/students/me');
      final data = response['data'];

      if (data != null) {
        _schoolController.text = data['university'] ?? '';
        _bioController.text = data['bio'] ?? '';

        String? savedGrade = data['major'];
        if (savedGrade != null &&
            AppConstants.gradeLevels.contains(savedGrade)) {
          _selectedGrade = savedGrade;
        }
      }
    } catch (e) {
      debugPrint('Error loading profile: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveData() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final payload = {
      "university": _schoolController.text.trim(),
      "major": _selectedGrade ?? '',
      "bio": _bioController.text.trim(),
    };

    try {
      await ApiService.put('/api/students/me', payload);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('تم تحديث بياناتك المدرسية بنجاح! 🎒'),
            backgroundColor: AppColors.success),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('حدث خطأ أثناء الحفظ، حاول مرة أخرى'),
            backgroundColor: AppColors.error),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تعديل الملف الشخصي'),
          backgroundColor: AppColors.primary,
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    const Text('اسم المدرسة',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _schoolController,
                      decoration: _inputDecoration(
                          'مثال: مدرسة الملك عبدالله للتميز', Icons.school),
                      validator: (v) =>
                          v!.isEmpty ? 'الرجاء إدخال اسم المدرسة' : null,
                    ),
                    const SizedBox(height: 20),
                    const Text('الصف الدراسي',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedGrade,
                      decoration:
                          _inputDecoration('اختر الصف الدراسي', Icons.class_),
                      items: AppConstants.gradeLevels
                          .map(
                              (g) => DropdownMenuItem(value: g, child: Text(g)))
                          .toList(),
                      onChanged: (v) => setState(() => _selectedGrade = v),
                      validator: (v) => v == null ? 'الرجاء اختيار الصف' : null,
                    ),
                    const SizedBox(height: 20),
                    const Text('نبذة عن الطالب / حالة الاحتياج',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _bioController,
                      maxLines: 4,
                      decoration: _inputDecoration(
                          'اكتب نبذة قصيرة ليتعرف عليك المتبرعون...',
                          Icons.info_outline),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _isSaving ? null : _saveData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                          : const Text('حفظ التعديلات',
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

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.primary),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.grey[50],
    );
  }
}
