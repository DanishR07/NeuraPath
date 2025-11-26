class UserModel {
  final String? id;
  final String email;
  final String password;
  final DateTime createdAt;

  UserModel({
    this.id,
    required this.email,
    required this.password,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'createdAt': createdAt,
    };
  }

  // Create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json, String userId) {
    return UserModel(
      id: userId,
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      createdAt: json['createdAt'] != null ? (json['createdAt'] as dynamic).toDate() : DateTime.now(),
    );
  }

  // Create a copy with modified fields
  UserModel copyWith({
    String? id,
    String? email,
    String? password,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
