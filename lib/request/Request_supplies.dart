// lib/request/Request_supplies.dart
// FIX: POST to /api/requests (unified endpoint) with type:'supplies'
//      Uses ApiService.post() with auth token

import 'package:flutter/material.dart';
import '../Style/app_colors.dart';
import '../constants/constants.dart';
import '../service/api_service.dart';
import '../constants/api_config.dart';

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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    for (final item in AppConstants.schoolSuppliesItems) {
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
                          color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.backpack,
                          color: AppColors.supplies, size: 32),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('الأدوات المدرسية',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text('اختر المستلزمات التي تحتاجها',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14)),
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
                validator: (v) =>
                    v == null ? 'الرجاء اختيار الصف الدراسي' : null,
              ),
              const SizedBox(height: 24),
              const Text('المستلزمات المطلوبة',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                      onChanged: (v) =>
                          setState(() => _selectedItems[item] = v ?? false),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                color: _isUrgent ? AppColors.error.withOpacity(0.1) : null,
                child: SwitchListTile(
                  title: const Text('طلب عاجل',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle:
                      const Text('ضع علامة إذا كنت بحاجة ماسة للمستلزمات'),
                  value: _isUrgent,
                  activeColor: AppColors.error,
                  onChanged: (v) => setState(() => _isUrgent = v),
                  secondary: Icon(Icons.priority_high,
                      color: _isUrgent
                          ? AppColors.error
                          : AppColors.textSecondary),
                ),
              ),
              const SizedBox(height: 20),
              const Text('ملاحظات إضافية (اختياري)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                maxLines: 4,
                maxLength: AppConstants.maxDescriptionLength,
                decoration: InputDecoration(
                  hintText: 'أضف أي تفاصيل إضافية...',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onChanged: (v) => _additionalNotes = v,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.supplies,
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
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
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
    final selectedItems =
        _selectedItems.entries.where((e) => e.value).map((e) => e.key).toList();
    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('الرجاء اختيار مستلزم واحد على الأقل'),
            backgroundColor: AppColors.error),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await ApiService.post(ApiConfig.requests, {
        'title': 'طلب أدوات مدرسية',
        'description': selectedItems.join(', '),
        'type': 'supplies',
        'urgency': _isUrgent ? 'high' : 'medium',
        'isPublic': true,
        // extra metadata
        'grade': _selectedGrade,
        'items': selectedItems,
        'notes': _additionalNotes,
      });

      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Row(children: [
            Icon(Icons.check_circle, color: AppColors.success, size: 32),
            SizedBox(width: 12),
            Text('تم إرسال الطلب'),
          ]),
          content: const Text('تم استلام طلبك بنجاح! سيتم مراجعته قريباً.'),
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
