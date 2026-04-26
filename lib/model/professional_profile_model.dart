class ProfessionalProfileModel {
  final String userId;
  final String firstName;
  final String lastName;
  final String role;
  final DateTime updatedAt;

  // 1. Current Identity
  final String? jobLevel; // Senior, Manager, Director, Executive
  final String? currentJobTitle;
  final String? currentCompany;
  final String? yearsOfExperience;
  
  // 2. Expertise
  final String? skills;
  final String? certifications;
  final String? industry;

  // 3. Compensation & Goals
  final String? salaryRange;
  final String? careerGoal;

  ProfessionalProfileModel({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.updatedAt,
    this.jobLevel,
    this.currentJobTitle,
    this.currentCompany,
    this.yearsOfExperience,
    this.skills,
    this.certifications,
    this.industry,
    this.salaryRange,
    this.careerGoal,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
      'updatedAt': updatedAt.toIso8601String(),
      'jobLevel': jobLevel,
      'currentJobTitle': currentJobTitle,
      'currentCompany': currentCompany,
      'yearsOfExperience': yearsOfExperience,
      'skills': skills,
      'certifications': certifications,
      'industry': industry,
      'salaryRange': salaryRange,
      'careerGoal': careerGoal,
    };
  }

  factory ProfessionalProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfessionalProfileModel(
      userId: json['userId'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      role: json['role'] ?? '',
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      jobLevel: json['jobLevel'],
      currentJobTitle: json['currentJobTitle'],
      currentCompany: json['currentCompany'],
      yearsOfExperience: json['yearsOfExperience'],
      skills: json['skills'],
      certifications: json['certifications'],
      industry: json['industry'],
      salaryRange: json['salaryRange'],
      careerGoal: json['careerGoal'],
    );
  }

  double calculateCompletion() {
    int total = 9;
    int filled = 0;
    
    if (jobLevel?.isNotEmpty == true) filled++;
    if (currentJobTitle?.isNotEmpty == true) filled++;
    if (currentCompany?.isNotEmpty == true) filled++;
    if (yearsOfExperience?.isNotEmpty == true) filled++;
    if (skills?.isNotEmpty == true) filled++;
    if (certifications?.isNotEmpty == true) filled++;
    if (industry?.isNotEmpty == true) filled++;
    if (salaryRange?.isNotEmpty == true) filled++;
    if (careerGoal?.isNotEmpty == true) filled++;

    return (filled / total);
  }
}

