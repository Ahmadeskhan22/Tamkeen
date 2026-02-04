import 'package:flutter/material.dart';
import '/Style/app_colors.dart';
import '../../constants/constants.dart';

class RequestTutoringPage extends StatefulWidget {
  const RequestTutoringPage({Key? key}) : super(key: key);

  @override
  State<RequestTutoringPage> createState() => _RequestTutoringPageState();
}

class _RequestTutoringPageState extends State<RequestTutoringPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedGrade;
  final List<String> _selectedSubjects = [];
  String _preferredTime = '';
  String _description = '';

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('طلب دروس تطوعية')),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.tutoring.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'احصل على مساعدة مجانية من متطوعين في المواد الصعبة',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'الصف الدراسي',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedGrade,
                decoration: const InputDecoration(hintText: 'اختر الصف'),
                items: AppConstants.gradeLevels
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (value) => setState(() => _selectedGrade = value),
                validator: (value) =>
                    value == null ? 'الرجاء اختيار الصف' : null,
              ),
              const SizedBox(height: 20),
              const Text(
                'المواد المطلوبة',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...AppConstants.schoolSubjects.map((subject) {
                return CheckboxListTile(
                  title: Text(subject),
                  value: _selectedSubjects.contains(subject),
                  onChanged: (checked) {
                    setState(() {
                      if (checked!)
                        _selectedSubjects.add(subject);
                      else
                        _selectedSubjects.remove(subject);
                    });
                  },
                );
              }).toList(),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'وصف المساعدة المطلوبة',
                ),
                maxLines: 3,
                onChanged: (v) => _description = v,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.tutoring,
                ),
                child: const Text('إرسال الطلب'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitRequest() {
    if (_formKey.currentState!.validate() && _selectedSubjects.isNotEmpty) {
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم إرسال طلبك بنجاح')));
    }
  }
}
