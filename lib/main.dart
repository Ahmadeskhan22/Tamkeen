// lib/main.dart
// FIXES:
//  - Restores saved login session on app start
//  - Routes to correct dashboard based on role
//  - Arabic RTL + Tajawal font applied globally

import 'package:flutter/material.dart';
import 'auth/auth_service.dart';
import 'auth/login_page.dart';
import 'Dashboard/Student_dashboard.dart';
import 'Dashboard/Donor_dashboard.dart';
import 'Dashboard/Volunteer_dashboard.dart';
import 'Style/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Try to restore a saved JWT session before showing any UI
  final bool isLoggedIn = await AuthService.instance.restoreSession();
  final String? role = AuthService.instance.currentUser?.role;

  runApp(StudentSupportApp(isLoggedIn: isLoggedIn, role: role));
}

class StudentSupportApp extends StatelessWidget {
  final bool isLoggedIn;
  final String? role;

  const StudentSupportApp({
    Key? key,
    required this.isLoggedIn,
    this.role,
  }) : super(key: key);

  Widget get _home {
    if (!isLoggedIn) return const LoginPage();
    switch (role) {
      case 'donor':
        return const DonorDashboard();
      case 'volunteer':
        return const VolunteerDashboard();
      default:
        return const StudentDashboard();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'خطوات الأمل',
      // ── Global theme ──────────────────────────────────────────────────────
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Tajawal',
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          secondary: AppColors.secondary,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: const TextStyle(
                fontFamily: 'Tajawal', fontWeight: FontWeight.bold),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        //cardTheme: CardTheme(
        //   elevation: 2,
        //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        //  margin: EdgeInsets.zero,
        // ),
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
        ),
      ),
      // Force RTL for the entire app
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child!,
      ),
      home: _home,
    );
  }
}
