class StudentProfileModel {
  final String userId;
  final String firstName;
  final String lastName;
  final String role;
  final DateTime updatedAt;

  // 1. Academic Information
  final String? currentDegree;
  final String? major;
  final String? university;
  final String? semesterYear;
  final String? cgpa;
  final String? expectedGraduationYear;
  final String? projectsCompleted;
  final String? preferredIndustryDomains;

  // 2. Skills
  final String? technicalSkills;
  final String? softSkills;
  final String? programmingLanguages;
  final String? toolsTechnologies;

  // 3. Career Interests
  final String? preferredCareerFields;
  final String? targetJobRoles;
  final String? preferredWorkType;
  final String? preferredLocations;

  // 4. Experience (Optional)
  final String? internships;
  final String? partTimeJobs;

  StudentProfileModel({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.updatedAt,
    this.currentDegree,
    this.major,
    this.university,
    this.semesterYear,
    this.cgpa,
    this.expectedGraduationYear,
    this.projectsCompleted,
    this.preferredIndustryDomains,
    this.technicalSkills,
    this.softSkills,
    this.programmingLanguages,
    this.toolsTechnologies,
    this.preferredCareerFields,
    this.targetJobRoles,
    this.preferredWorkType,
    this.preferredLocations,
    this.internships,
    this.partTimeJobs,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
      'updatedAt': updatedAt.toIso8601String(),
      'currentDegree': currentDegree,
      'major': major,
      'university': university,
      'semesterYear': semesterYear,
      'cgpa': cgpa,
      'expectedGraduationYear': expectedGraduationYear,
      'projectsCompleted': projectsCompleted,
      'preferredIndustryDomains': preferredIndustryDomains,
      'technicalSkills': technicalSkills,
      'softSkills': softSkills,
      'programmingLanguages': programmingLanguages,
      'toolsTechnologies': toolsTechnologies,
      'preferredCareerFields': preferredCareerFields,
      'targetJobRoles': targetJobRoles,
      'preferredWorkType': preferredWorkType,
      'preferredLocations': preferredLocations,
      'internships': internships,
      'partTimeJobs': partTimeJobs,
    };
  }

  factory StudentProfileModel.fromJson(Map<String, dynamic> json) {
    return StudentProfileModel(
      userId: json['userId'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      role: json['role'] ?? '',
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      currentDegree: json['currentDegree'],
      major: json['major'],
      university: json['university'],
      semesterYear: json['semesterYear'],
      cgpa: json['cgpa'],
      expectedGraduationYear: json['expectedGraduationYear'],
      projectsCompleted: json['projectsCompleted'],
      preferredIndustryDomains: json['preferredIndustryDomains'],
      technicalSkills: json['technicalSkills'],
      softSkills: json['softSkills'],
      programmingLanguages: json['programmingLanguages'],
      toolsTechnologies: json['toolsTechnologies'],
      preferredCareerFields: json['preferredCareerFields'],
      targetJobRoles: json['targetJobRoles'],
      preferredWorkType: json['preferredWorkType'],
      preferredLocations: json['preferredLocations'],
      internships: json['internships'],
      partTimeJobs: json['partTimeJobs'],
    );
  }
  
  // Helper to calculate completion percentage
  double calculateCompletion() {
    int totalFields = 21; // Total optional fields
    int filledFields = 0;
    
    if (currentDegree?.isNotEmpty == true) filledFields++;
    if (major?.isNotEmpty == true) filledFields++;
    if (university?.isNotEmpty == true) filledFields++;
    if (semesterYear?.isNotEmpty == true) filledFields++;
    if (cgpa?.isNotEmpty == true) filledFields++;
    if (expectedGraduationYear?.isNotEmpty == true) filledFields++;
    if (projectsCompleted?.isNotEmpty == true) filledFields++;
    if (preferredIndustryDomains?.isNotEmpty == true) filledFields++;
    if (technicalSkills?.isNotEmpty == true) filledFields++;
    if (softSkills?.isNotEmpty == true) filledFields++;
    if (programmingLanguages?.isNotEmpty == true) filledFields++;
    if (toolsTechnologies?.isNotEmpty == true) filledFields++;
    if (preferredCareerFields?.isNotEmpty == true) filledFields++;
    if (targetJobRoles?.isNotEmpty == true) filledFields++;
    if (preferredWorkType?.isNotEmpty == true) filledFields++;
    if (preferredLocations?.isNotEmpty == true) filledFields++;
    if (internships?.isNotEmpty == true) filledFields++;
    if (partTimeJobs?.isNotEmpty == true) filledFields++;

    // Base 15% + (85% * filled/total)
    return 15.0 + (85.0 * (filledFields / totalFields));
  }
}
