// lib/models/user_model.dart

class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? phone;
  final String? avatar;
  final bool isVerified;
  final bool isActive;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phone,
    this.avatar,
    this.isVerified = false,
    this.isActive = true,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: (json['id'] ?? json['_id'] ?? '').toString(),
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        role: json['role'] ?? 'student',
        phone: json['phone']?.toString(),
        avatar: json['avatar']?.toString(),
        isVerified: json['isVerified'] ?? false,
        isActive: json['isActive'] ?? true,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'role': role,
        if (phone != null) 'phone': phone,
        if (avatar != null) 'avatar': avatar,
        'isVerified': isVerified,
        'isActive': isActive,
      };

  bool get isStudent => role == 'student';
  bool get isVolunteer => role == 'volunteer';
  bool get isDonor => role == 'donor';
  bool get isAdmin => role == 'admin';
}
