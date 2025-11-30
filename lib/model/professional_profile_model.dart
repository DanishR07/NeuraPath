class ProfessionalProfileModel {
  final String userId;
  final String firstName;
  final String lastName;
  final String role;
  final DateTime updatedAt;

  // 1. Career Information
  final String? currentJobTitle;
  final String? jobLevel;
  final String? currentCompany;
  final String? yearsOfExperience;
  final String? employmentType;
  final String? salaryRange;
  final String? skills;
  final String? toolsTechnologies;
  final String? certifications;

  // 2. Career Growth Information
  final String? desiredNextJobRole;
  final String? longTermCareerGoal;
  final String? industryInterest;

  // 3. Work History
  final String? workHistoryDetails; // Storing as string for simplicity

  ProfessionalProfileModel({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.updatedAt,
    this.currentJobTitle,
    this.jobLevel,
    this.currentCompany,
    this.yearsOfExperience,
    this.employmentType,
    this.salaryRange,
    this.skills,
    this.toolsTechnologies,
    this.certifications,
    this.desiredNextJobRole,
    this.longTermCareerGoal,
    this.industryInterest,
    this.workHistoryDetails,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
      'updatedAt': updatedAt.toIso8601String(),
      'currentJobTitle': currentJobTitle,
      'jobLevel': jobLevel,
      'currentCompany': currentCompany,
      'yearsOfExperience': yearsOfExperience,
      'employmentType': employmentType,
      'salaryRange': salaryRange,
      'skills': skills,
      'toolsTechnologies': toolsTechnologies,
      'certifications': certifications,
      'desiredNextJobRole': desiredNextJobRole,
      'longTermCareerGoal': longTermCareerGoal,
      'industryInterest': industryInterest,
      'workHistoryDetails': workHistoryDetails,
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
      currentJobTitle: json['currentJobTitle'],
      jobLevel: json['jobLevel'],
      currentCompany: json['currentCompany'],
      yearsOfExperience: json['yearsOfExperience'],
      employmentType: json['employmentType'],
      salaryRange: json['salaryRange'],
      skills: json['skills'],
      toolsTechnologies: json['toolsTechnologies'],
      certifications: json['certifications'],
      desiredNextJobRole: json['desiredNextJobRole'],
      longTermCareerGoal: json['longTermCareerGoal'],
      industryInterest: json['industryInterest'],
      workHistoryDetails: json['workHistoryDetails'],
    );
  }

  double calculateCompletion() {
    int totalFields = 13;
    int filledFields = 0;
    
    if (currentJobTitle?.isNotEmpty == true) filledFields++;
    if (jobLevel?.isNotEmpty == true) filledFields++;
    if (currentCompany?.isNotEmpty == true) filledFields++;
    if (yearsOfExperience?.isNotEmpty == true) filledFields++;
    if (employmentType?.isNotEmpty == true) filledFields++;
    if (salaryRange?.isNotEmpty == true) filledFields++;
    if (skills?.isNotEmpty == true) filledFields++;
    if (toolsTechnologies?.isNotEmpty == true) filledFields++;
    if (certifications?.isNotEmpty == true) filledFields++;
    if (desiredNextJobRole?.isNotEmpty == true) filledFields++;
    if (longTermCareerGoal?.isNotEmpty == true) filledFields++;
    if (industryInterest?.isNotEmpty == true) filledFields++;
    if (workHistoryDetails?.isNotEmpty == true) filledFields++;

    return 15.0 + (85.0 * (filledFields / totalFields));
  }
}
