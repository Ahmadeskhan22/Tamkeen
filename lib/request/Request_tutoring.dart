// lib/request/Request_tutoring.dart
// FIX: POST to /api/requests with type:'tutoring'

import 'package:flutter/material.dart';
import '../Style/app_colors.dart';
import '../constants/constants.dart';
import '../service/api_service.dart';
import '../constants/api_config.dart';

class RequestTutoringPage extends StatefulWidget {
  const RequestTutoringPage({Key? key}) : super(key: key);

  @override
  State<RequestTutoringPage> createState() => _RequestTutoringPageState();
}

class _RequestTutoringPageState extends State<RequestTutoringPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedGrade;
  final List<String> _selectedSubjects = [];
  String _description = '';
  bool _isLoading = false;

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
                child: const Row(
                  children: [
                    Icon(Icons.menu_book, color: AppColors.tutoring, size: 40),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'احصل على مساعدة مجانية من متطوعين في المواد الصعبة',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
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
                decoration: const InputDecoration(hintText: 'اختر الصف'),
                items: AppConstants.gradeLevels
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedGrade = v),
                validator: (v) => v == null ? 'الرجاء اختيار الصف' : null,
              ),
              const SizedBox(height: 20),
              const Text('المواد المطلوبة',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  children: AppConstants.schoolSubjects.map((subject) {
                    return CheckboxListTile(
                      title: Text(subject),
                      value: _selectedSubjects.contains(subject),
                      activeColor: AppColors.tutoring,
                      onChanged: (checked) {
                        setState(() {
                          if (checked == true) {
                            _selectedSubjects.add(subject);
                          } else {
                            _selectedSubjects.remove(subject);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'وصف المساعدة المطلوبة',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                maxLines: 3,
                onChanged: (v) => _description = v,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.tutoring,
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
                    : const Text('إرسال الطلب',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedSubjects.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('الرجاء اختيار مادة واحدة على الأقل'),
            backgroundColor: AppColors.error),
      );
      return;
    }
    setState(() => _isLoading = true);
    try {
      await ApiService.post(ApiConfig.requests, {
        'title': 'طلب دروس تطوعية',
        'description': _description.isNotEmpty
            ? _description
            : 'المواد: ${_selectedSubjects.join(', ')}',
        'type': 'tutoring',
        'urgency': 'medium',
        'isPublic': true,
        'grade': _selectedGrade,
        'subjects': _selectedSubjects,
      });

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إرسال طلبك بنجاح')),
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
