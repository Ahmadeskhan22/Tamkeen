import 'package:flutter/material.dart';
import '/Style/app_colors.dart';
import '../../constants/constants.dart';

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
                child: Row(
                  children: const [
                    Icon(Icons.restaurant, color: AppColors.meals, size: 40),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'وجبات صحية يومية للطلاب',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
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
                'نوع الوجبة المطلوبة',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...AppConstants.mealTypes.map((meal) {
                return CheckboxListTile(
                  title: Text(meal),
                  value: _selectedMealTypes.contains(meal),
                  activeColor: AppColors.meals,
                  onChanged: (checked) {
                    setState(() {
                      if (checked!)
                        _selectedMealTypes.add(meal);
                      else
                        _selectedMealTypes.remove(meal);
                    });
                  },
                );
              }).toList(),
              const SizedBox(height: 20),
              Card(
                child: CheckboxListTile(
                  title: const Text('لدي قيود غذائية أو حساسية'),
                  value: _hasDietaryRestrictions,
                  onChanged: (v) =>
                      setState(() => _hasDietaryRestrictions = v!),
                ),
              ),
              if (_hasDietaryRestrictions) ...[
                const SizedBox(height: 12),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'اذكر القيود الغذائية أو الحساسية',
                    hintText: 'مثال: حساسية من المكسرات',
                  ),
                  maxLines: 2,
                  onChanged: (v) => _dietaryNotes = v,
                ),
              ],
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.meals,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'إرسال الطلب',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitRequest() {
    if (_formKey.currentState!.validate() && _selectedMealTypes.isNotEmpty) {
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم إرسال طلبك بنجاح')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء اختيار نوع وجبة واحد على الأقل')),
      );
    }
  }
}
