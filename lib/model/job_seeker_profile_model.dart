class JobSeekerProfileModel {
  final String userId;
  final String firstName;
  final String lastName;
  final String role;
  final DateTime updatedAt;

  // 1. Career Identity
  final String? experienceLevel; // Fresh Graduate, Experienced Professional, Senior/Executive
  final String? currentJobTitle;
  
  // 2. Professional Details
  final String? highestQualification;
  final String? totalExperience; // Years
  final String? technicalSkills;
  final String? certifications;
  
  // 3. Career Goals
  final String? targetJobRoles;
  final String? preferredIndustries;
  final String? expectedSalaryRange;
  final String? jobType; // Remote, On-site, Hybrid

  JobSeekerProfileModel({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.updatedAt,
    this.experienceLevel,
    this.currentJobTitle,
    this.highestQualification,
    this.totalExperience,
    this.technicalSkills,
    this.certifications,
    this.targetJobRoles,
    this.preferredIndustries,
    this.expectedSalaryRange,
    this.jobType,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
      'updatedAt': updatedAt.toIso8601String(),
      'experienceLevel': experienceLevel,
      'currentJobTitle': currentJobTitle,
      'highestQualification': highestQualification,
      'totalExperience': totalExperience,
      'technicalSkills': technicalSkills,
      'certifications': certifications,
      'targetJobRoles': targetJobRoles,
      'preferredIndustries': preferredIndustries,
      'expectedSalaryRange': expectedSalaryRange,
      'jobType': jobType,
    };
  }

  factory JobSeekerProfileModel.fromJson(Map<String, dynamic> json) {
    return JobSeekerProfileModel(
      userId: json['userId'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      role: json['role'] ?? '',
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      experienceLevel: json['experienceLevel'],
      currentJobTitle: json['currentJobTitle'],
      highestQualification: json['highestQualification'],
      totalExperience: json['totalExperience'],
      technicalSkills: json['technicalSkills'],
      certifications: json['certifications'],
      targetJobRoles: json['targetJobRoles'],
      preferredIndustries: json['preferredIndustries'],
      expectedSalaryRange: json['expectedSalaryRange'],
      jobType: json['jobType'],
    );
  }

  double calculateCompletion() {
    int totalNeeded = 8; // Essential identifying fields
    int filled = 0;

    if (experienceLevel?.isNotEmpty == true) filled++;
    if (highestQualification?.isNotEmpty == true) filled++;
    if (technicalSkills?.isNotEmpty == true) filled++;
    if (targetJobRoles?.isNotEmpty == true) filled++;
    if (expectedSalaryRange?.isNotEmpty == true) filled++;
    if (jobType?.isNotEmpty == true) filled++;
    
    if (experienceLevel == "Fresh Graduate") {
      totalNeeded = 6;
    } else {
      totalNeeded = 8;
      if (currentJobTitle?.isNotEmpty == true) filled++;
      if (totalExperience?.isNotEmpty == true) filled++;
    }

    return (filled / totalNeeded);
  }
}

