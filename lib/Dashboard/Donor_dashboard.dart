// lib/Dashboard/Donor_dashboard.dart
// FIXES:
//  - Removed duplicate import (was imported twice)
//  - Urgent needs now loaded from real API
//  - Logout connected

import 'package:flutter/material.dart';
import '../Style/app_colors.dart';
import '../service/api_service.dart';
import '../constants/api_config.dart';
import '../models/request_model.dart';
import '../auth/auth_service.dart';
import '../auth/login_page.dart';

class DonorDashboard extends StatefulWidget {
  const DonorDashboard({Key? key}) : super(key: key);

  @override
  State<DonorDashboard> createState() => _DonorDashboardState();
}

class _DonorDashboardState extends State<DonorDashboard> {
  List<RequestModel> _urgentRequests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUrgentRequests();
  }

  Future<void> _loadUrgentRequests() async {
    try {
      final data = await ApiService.get(
        ApiConfig.requests,
        queryParams: {'urgency': 'high', 'status': 'approved', 'limit': '5'},
        withAuth: true,
      );
      setState(() {
        _urgentRequests = (data['data'] as List)
            .map((e) => RequestModel.fromJson(e as Map<String, dynamic>))
            .toList();
        _isLoading = false;
      });
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _logout() async {
    await AuthService.instance.logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
          (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('لوحة المتبرعين'),
          backgroundColor: AppColors.secondary,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _logout,
              tooltip: 'تسجيل الخروج',
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _loadUrgentRequests,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Hero card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: AppColors.secondaryGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.card_giftcard, color: Colors.white, size: 60),
                    const SizedBox(height: 12),
                    Text(
                      user != null ? 'مرحباً، ${user.name}!' : 'تبرعك يصنع الفرق',
                      style: const TextStyle(
                          color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'كل تبرع يساعد طالباً في تحقيق أحلامه',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text('الاحتياجات العاجلة',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_urgentRequests.isEmpty)
                ..._staticNeedCards()
              else
                ..._urgentRequests.map((r) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildNeedCard(
                    r.title,
                    r.description,
                    Icons.priority_high,
                    AppColors.error,
                    progress: r.fundingProgress,
                  ),
                )),
              const SizedBox(height: 24),
              const Text('طرق التبرع',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildDonationOption(
                  'تبرع بالأدوات', 'تبرع بأدوات مدرسية جديدة أو مستعملة بحالة جيدة',
                  Icons.inventory_2, AppColors.supplies),
              const SizedBox(height: 12),
              _buildDonationOption(
                  'تبرع بالملابس', 'تبرع بزي مدرسي أو ملابس شتوية',
                  Icons.checkroom, AppColors.uniform),
              const SizedBox(height: 12),
              _buildDonationOption(
                  'كفالة طالب', 'تكفل باحتياجات طالب طوال العام الدراسي',
                  Icons.favorite, AppColors.secondary),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.card_giftcard),
                label: const Text('ابدأ التبرع الآن',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _staticNeedCards() => [
    _buildNeedCard('أدوات مدرسية', '15 طالب بحاجة لحقائب وأقلام',
        Icons.backpack, AppColors.supplies, progress: 0.6),
    const SizedBox(height: 12),
    _buildNeedCard('زي مدرسي', '8 طلاب بحاجة لزي موحد',
        Icons.checkroom, AppColors.uniform, progress: 0.3),
    const SizedBox(height: 12),
    _buildNeedCard('ملابس شتوية', '20 طالب بحاجة لمعاطف وسترات',
        Icons.ac_unit, AppColors.info, progress: 0.2),
  ];

  Widget _buildNeedCard(String title, String description, IconData icon, Color color,
      {required double progress}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: color.withOpacity(0.1), shape: BoxShape.circle),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text(description,
                          style: const TextStyle(fontSize: 13),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: color.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'تم توفير ${(progress * 100).toInt()}% من الاحتياج',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDonationOption(
      String title, String description, IconData icon, Color color) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: color, size: 32),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}
