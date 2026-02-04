import 'package:flutter/material.dart';
import '/Style/app_colors.dart';
import '../../constants/constants.dart';

class RequestSuppliesPage extends StatefulWidget {
  const RequestSuppliesPage({Key? key}) : super(key: key);

  @override
  State<RequestSuppliesPage> createState() => _RequestSuppliesPageState();
}

class _RequestSuppliesPageState extends State<RequestSuppliesPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, bool> _selectedItems = {};
  String? _selectedGrade;
  String _additionalNotes = '';
  bool _isUrgent = false;

  @override
  void initState() {
    super.initState();
    for (var item in AppConstants.schoolSuppliesItems) {
      _selectedItems[item] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('طلب أدوات مدرسية'), elevation: 0),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.backpack,
                        color: AppColors.supplies,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'الأدوات المدرسية',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'اختر المستلزمات التي تحتاجها',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Grade Selection
              const Text(
                'الصف الدراسي',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedGrade,
                decoration: InputDecoration(
                  hintText: 'اختر الصف',
                  prefixIcon: const Icon(Icons.school),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: AppConstants.gradeLevels.map((grade) {
                  return DropdownMenuItem(value: grade, child: Text(grade));
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedGrade = value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء اختيار الصف الدراسي';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Items Selection
              const Text(
                'المستلزمات المطلوبة',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  children: AppConstants.schoolSuppliesItems.map((item) {
                    return CheckboxListTile(
                      title: Text(item),
                      value: _selectedItems[item],
                      activeColor: AppColors.supplies,
                      onChanged: (bool? value) {
                        setState(() {
                          _selectedItems[item] = value ?? false;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),

              // Urgent Toggle
              Card(
                color: _isUrgent ? AppColors.error.withOpacity(0.1) : null,
                child: SwitchListTile(
                  title: const Text(
                    'طلب عاجل',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text(
                    'ضع علامة إذا كنت بحاجة ماسة للمستلزمات',
                    style: TextStyle(fontSize: 12),
                  ),
                  value: _isUrgent,
                  activeColor: AppColors.error,
                  onChanged: (bool value) {
                    setState(() => _isUrgent = value);
                  },
                  secondary: Icon(
                    Icons.priority_high,
                    color:
                        _isUrgent ? AppColors.error : AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Additional Notes
              const Text(
                'ملاحظات إضافية (اختياري)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                maxLines: 4,
                maxLength: AppConstants.maxDescriptionLength,
                decoration: InputDecoration(
                  hintText: 'أضف أي تفاصيل إضافية حول احتياجاتك...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignLabelWithHint: true,
                ),
                onChanged: (value) => _additionalNotes = value,
              ),
              const SizedBox(height: 24),

              // Privacy Notice
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.info.withOpacity(0.3)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.privacy_tip,
                      color: AppColors.info,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'خصوصيتك مهمة',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.info,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'جميع المعلومات سرية ولن تُشارك مع أي جهة خارجية. '
                            'سيتم مراجعة طلبك من قبل فريق متخصص.',
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
                  backgroundColor: AppColors.supplies,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'إرسال الطلب',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
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

    // Check if at least one item is selected
    final hasSelectedItems = _selectedItems.values.any((selected) => selected);
    if (!hasSelectedItems) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء اختيار مستلزم واحد على الأقل'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Show success dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.check_circle, color: AppColors.success, size: 32),
            SizedBox(width: 12),
            Text('تم إرسال الطلب'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'تم استلام طلبك بنجاح! سيتم مراجعته من قبل فريقنا في أقرب وقت.',
              style: TextStyle(height: 1.5),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'رقم الطلب: #SUP-2024-001',
                style: TextStyle(
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
              Navigator.pop(context); // Go back to dashboard
            },
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }
}
