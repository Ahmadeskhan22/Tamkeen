// lib/models/request_model.dart

class RequestModel {
  final String id;
  final String title;
  final String description;
  final String type;
  final String status;
  final String urgency;
  final double? amountNeeded;
  final double amountRaised;
  final String currency;
  final bool isPublic;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata; // extra fields (grade, items, etc.)

  const RequestModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.status,
    required this.urgency,
    required this.amountRaised,
    required this.currency,
    required this.isPublic,
    required this.createdAt,
    this.amountNeeded,
    this.metadata,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) => RequestModel(
        id: (json['_id'] ?? json['id'] ?? '').toString(),
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        type: json['type'] ?? 'other',
        status: json['status'] ?? 'pending',
        urgency: json['urgency'] ?? 'medium',
        amountNeeded: (json['amountNeeded'] as num?)?.toDouble(),
        amountRaised: (json['amountRaised'] as num?)?.toDouble() ?? 0,
        currency: json['currency'] ?? 'USD',
        isPublic: json['isPublic'] ?? true,
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
            : DateTime.now(),
        metadata: json['metadata'] as Map<String, dynamic>?,
      );

  // ─── Display helpers ────────────────────────────────────────────────────

  String get statusLabel {
    const map = {
      'pending': 'قيد الانتظار',
      'under_review': 'قيد المراجعة',
      'approved': 'تمت الموافقة',
      'in_progress': 'جارٍ المعالجة',
      'fulfilled': 'تم التلبية',
      'rejected': 'مرفوض',
      'closed': 'مغلق',
    };
    return map[status] ?? status;
  }

  String get typeLabel {
    const map = {
      'supplies': 'أدوات مدرسية',
      'uniform': 'زي مدرسي',
      'tutoring': 'دروس تطوعية',
      'food': 'وجبات مدرسية',
      'psychological': 'دعم نفسي',
      'financial': 'مالي',
      'academic': 'أكاديمي',
      'housing': 'سكن',
      'other': 'أخرى',
    };
    return map[type] ?? type;
  }

  double get fundingProgress {
    if (amountNeeded == null || amountNeeded == 0) return 0;
    return (amountRaised / amountNeeded!).clamp(0.0, 1.0);
  }
}
