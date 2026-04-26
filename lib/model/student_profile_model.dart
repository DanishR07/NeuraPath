class StudentProfileModel {
  final String userId;
  final String firstName;
  final String lastName;
  final String role;
  final DateTime updatedAt;

  // 1. Education Identity
  final String? educationLevel; // Matric, Intermediate, University
  
  // 2. Academic Information (Conditional)
  final String? institution; // School / College / University
  final String? major;       // Science, Pre-Engineering, Computer Science, etc.
  final String? degree;      // BS, MS (for University)
  
  // Performance logic
  final String? totalMarks;    // For Matric/Inter
  final String? obtainedMarks; // For Matric/Inter
  final String? cgpa;          // For University
  final String? semesterYear;  // For University
  
  // 3. Skills & Interests (Adaptive)
  final String? technicalSkills;  // For University/Level 3
  final String? favoriteSubjects; // For Matric/Inter
  final String? preferredCareerFields; // General interests

  StudentProfileModel({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.updatedAt,
    this.educationLevel,
    this.institution,
    this.major,
    this.degree,
    this.totalMarks,
    this.obtainedMarks,
    this.cgpa,
    this.semesterYear,
    this.technicalSkills,
    this.favoriteSubjects,
    this.preferredCareerFields,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
      'updatedAt': updatedAt.toIso8601String(),
      'educationLevel': educationLevel,
      'institution': institution,
      'major': major,
      'degree': degree,
      'totalMarks': totalMarks,
      'obtainedMarks': obtainedMarks,
      'cgpa': cgpa,
      'semesterYear': semesterYear,
      'technicalSkills': technicalSkills,
      'favoriteSubjects': favoriteSubjects,
      'preferredCareerFields': preferredCareerFields,
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
      educationLevel: json['educationLevel'],
      institution: json['institution'],
      major: json['major'],
      degree: json['degree'],
      totalMarks: json['totalMarks'],
      obtainedMarks: json['obtainedMarks'],
      cgpa: json['cgpa'],
      semesterYear: json['semesterYear'],
      technicalSkills: json['technicalSkills'],
      favoriteSubjects: json['favoriteSubjects'],
      preferredCareerFields: json['preferredCareerFields'],
    );
  }
  
  double calculateCompletion() {
    int totalNeeded = 0;
    int filled = 0;

    // Common fields
    if (educationLevel?.isNotEmpty == true) filled++;
    totalNeeded++;
    if (institution?.isNotEmpty == true) filled++;
    totalNeeded++;
    if (major?.isNotEmpty == true) filled++;
    totalNeeded++;
    if (preferredCareerFields?.isNotEmpty == true) filled++;
    totalNeeded++;

    // Conditional fields
    if (educationLevel == "University") {
      totalNeeded += 3; // Degree, CGPA, Technical Skills
      if (degree?.isNotEmpty == true) filled++;
      if (cgpa?.isNotEmpty == true) filled++;
      if (technicalSkills?.isNotEmpty == true) filled++;
    } else {
      totalNeeded += 3; // Total Marks, Obtained Marks, Favorite Subjects
      if (totalMarks?.isNotEmpty == true) filled++;
      if (obtainedMarks?.isNotEmpty == true) filled++;
      if (favoriteSubjects?.isNotEmpty == true) filled++;
    }

    return (filled / totalNeeded);
  }
}

