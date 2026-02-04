import 'package:flutter/material.dart';
import '/Style/app_colors.dart';
import '../../constants/constants.dart';

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

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('طلب زي مدرسي'),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.uniform.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.uniform.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.checkroom,
                        color: AppColors.uniform, size: 48),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'الزي المدرسي',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.uniform,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'زي موحد نظيف ومناسب',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Grade
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
                items: AppConstants.gradeLevels.map((grade) {
                  return DropdownMenuItem(value: grade, child: Text(grade));
                }).toList(),
                onChanged: (value) => setState(() => _selectedGrade = value),
                validator: (value) =>
                    value == null ? 'الرجاء اختيار الصف' : null,
              ),
              const SizedBox(height: 20),

              // Uniform Size
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
                items: AppConstants.uniformSizes.map((size) {
                  return DropdownMenuItem(value: size, child: Text(size));
                }).toList(),
                onChanged: (value) => setState(() => _uniformSize = value),
                validator: (value) =>
                    value == null ? 'الرجاء اختيار المقاس' : null,
              ),
              const SizedBox(height: 24),

              // Winter Clothing
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
                      onChanged: (value) =>
                          setState(() => _needWinterClothing = value ?? false),
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
                          items: AppConstants.uniformSizes.map((size) {
                            return DropdownMenuItem(
                                value: size, child: Text(size));
                          }).toList(),
                          onChanged: (value) =>
                              setState(() => _winterSize = value),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Notes
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
                onChanged: (value) => _additionalNotes = value,
              ),
              const SizedBox(height: 32),

              // Submit
              ElevatedButton(
                onPressed: _submitRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.uniform,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('إرسال الطلب',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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

  void _submitRequest() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('تم إرسال الطلب'),
          content: const Text('سيتم مراجعة طلبك قريباً'),
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
    }
  }
}
