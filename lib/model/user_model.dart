class UserModel {
  final String? id;
  final String email;
  final String password;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? profileImageUrl;
  final String? role;
  final DateTime createdAt;

  UserModel({
    this.id,
    required this.email,
    required this.password,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.profileImageUrl,
    this.role,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'role': role,
      'createdAt': createdAt,
    };
  }

  // Create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json, String userId) {
    return UserModel(
      id: userId,
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      firstName: json['firstName'],
      lastName: json['lastName'],
      phoneNumber: json['phoneNumber'],
      profileImageUrl: json['profileImageUrl'],
      role: json['role'],
      createdAt: json['createdAt'] != null ? (json['createdAt'] as dynamic).toDate() : DateTime.now(),
    );
  }

  // Create a copy with modified fields
  UserModel copyWith({
    String? id,
    String? email,
    String? password,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? profileImageUrl,
    String? role,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
