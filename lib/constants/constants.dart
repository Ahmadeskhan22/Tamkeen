class AppConstants {
  // App Information
  static const String appName = 'HopeSteps';
  static const String appNameArabic = 'خطوات الأمل';
  static const String appTagline = 'معاً لدعم أطفالنا';
  static const String appVersion = '1.0.0';

  // Service Categories
  static const String suppliesService = 'school_supplies';
  static const String uniformService = 'uniform_clothing';
  static const String tutoringService = 'volunteer_tutoring';
  static const String mealsService = 'school_meals';
  static const String supportService = 'psychological_support';

  // User Roles
  static const String roleStudent = 'student';
  static const String roleVolunteer = 'volunteer';
  static const String roleDonor = 'donor';
  static const String roleAdmin = 'admin';

  // Request Status
  static const String statusPending = 'pending';
  static const String statusVerifying = 'verifying';
  static const String statusApproved = 'approved';
  static const String statusInProgress = 'in_progress';
  static const String statusCompleted = 'completed';
  static const String statusRejected = 'rejected';

  // Priority Levels
  static const String priorityUrgent = 'urgent';
  static const String priorityHigh = 'high';
  static const String priorityMedium = 'medium';
  static const String priorityLow = 'low';

  // School Supplies Items
  static const List<String> schoolSuppliesItems = [
    'حقيبة مدرسية',
    'دفاتر',
    'أقلام',
    'مسطرة',
    'ممحاة',
    'ألوان',
    'كتب مدرسية',
    'آلة حاسبة',
    'مقلمة',
    'كراسات رسم',
  ];

  // Uniform Sizes
  static const List<String> uniformSizes = [
    'صغير جداً (XS)',
    'صغير (S)',
    'متوسط (M)',
    'كبير (L)',
    'كبير جداً (XL)',
  ];

  // School Subjects
  static const List<String> schoolSubjects = [
    'الرياضيات',
    'العلوم',
    'اللغة العربية',
    'اللغة الإنجليزية',
    'الفيزياء',
    'الكيمياء',
    'الأحياء',
    'التاريخ',
    'الجغرافيا',
    'الحاسوب',
  ];

  // Grade Levels
  static const List<String> gradeLevels = [
    'الصف الأول',
    'الصف الثاني',
    'الصف الثالث',
    'الصف الرابع',
    'الصف الخامس',
    'الصف السادس',
    'الصف السابع',
    'الصف الثامن',
    'الصف التاسع',
    'الصف العاشر',
    'الصف الحادي عشر',
    'الصف الثاني عشر',
  ];

  // Meal Types
  static const List<String> mealTypes = [
    'وجبة الإفطار',
    'وجبة الغداء',
    'وجبة خفيفة',
  ];

  // Support Session Types
  static const List<String> supportTypes = [
    'دعم نفسي عام',
    'القلق والتوتر',
    'مشاكل دراسية',
    'مشاكل اجتماعية',
    'التنمر',
    'مشاكل عائلية',
    'تطوير الذات',
    'استشارة عاجلة',
  ];

  // Validation
  static const int minAge = 5;
  static const int maxAge = 18;
  static const int minPhoneLength = 10;
  static const int maxDescriptionLength = 500;

  // Emergency Contact
  static const String emergencyHotline = '1234567890';
  static const String supportEmail = 'support@hopesteps.org';

  // Privacy & Safety
  static const String privacyPolicyUrl = 'https://hopesteps.org/privacy';
  static const String termsOfServiceUrl = 'https://hopesteps.org/terms';
}
