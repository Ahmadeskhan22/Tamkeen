// lib/request/Request_meals.dart
// FIX: POST to /api/requests with type:'food'

import 'package:flutter/material.dart';
import '../Style/app_colors.dart';
import '../constants/constants.dart';
import '../service/api_service.dart';
import '../constants/api_config.dart';

class RequestMealsPage extends StatefulWidget {
  const RequestMealsPage({Key? key}) : super(key: key);

  @override
  State<RequestMealsPage> createState() => _RequestMealsPageState();
}

class _RequestMealsPageState extends State<RequestMealsPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedGrade;
  final List<String> _selectedMealTypes = [];
  bool _hasDietaryRestrictions = false;
  String _dietaryNotes = '';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('طلب وجبات مدرسية')),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.meals.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.restaurant, color: AppColors.meals, size: 40),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'وجبات صحية يومية للطلاب',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
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
              const Text('نوع الوجبة المطلوبة',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...AppConstants.mealTypes.map((meal) {
                return CheckboxListTile(
                  title: Text(meal),
                  value: _selectedMealTypes.contains(meal),
                  activeColor: AppColors.meals,
                  onChanged: (checked) {
                    setState(() {
                      if (checked == true) {
                        _selectedMealTypes.add(meal);
                      } else {
                        _selectedMealTypes.remove(meal);
                      }
                    });
                  },
                );
              }),
              const SizedBox(height: 16),
              Card(
                child: CheckboxListTile(
                  title: const Text('لدي قيود غذائية أو حساسية'),
                  value: _hasDietaryRestrictions,
                  activeColor: AppColors.meals,
                  onChanged: (v) =>
                      setState(() => _hasDietaryRestrictions = v!),
                ),
              ),
              if (_hasDietaryRestrictions) ...[
                const SizedBox(height: 12),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'اذكر القيود الغذائية أو الحساسية',
                    hintText: 'مثال: حساسية من المكسرات',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  maxLines: 2,
                  onChanged: (v) => _dietaryNotes = v,
                ),
              ],
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.meals,
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
                    : const Text('إرسال الطلب', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedMealTypes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('الرجاء اختيار نوع وجبة واحد على الأقل'),
            backgroundColor: AppColors.error),
      );
      return;
    }
    setState(() => _isLoading = true);
    try {
      await ApiService.post(ApiConfig.requests, {
        'title': 'طلب وجبات مدرسية',
        'description': _selectedMealTypes.join(', '),
        'type': 'food',
        'urgency': 'medium',
        'isPublic': true,
        'grade': _selectedGrade,
        'mealTypes': _selectedMealTypes,
        'hasDietaryRestrictions': _hasDietaryRestrictions,
        if (_hasDietaryRestrictions) 'dietaryNotes': _dietaryNotes,
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
