class JobSeekerProfileModel {
  final String userId;
  final String firstName;
  final String lastName;
  final String role;
  final DateTime updatedAt;

  // 1. Professional Information
  final String? highestQualification;
  final String? totalExperience;
  final String? currentJobTitle;
  final String? employmentType;
  final String? expectedSalaryRange;
  final String? portfolioWebsite;
  final String? linkedinProfile;
  final String? countryCity;

  // 2. Skills
  final String? technicalSkills;
  final String? softSkills;
  final String? toolsTechnologies;
  final String? certifications;

  // 3. Career Preferences
  final String? targetJobRoles;
  final String? preferredIndustries;
  final String? preferredWorkLocation;
  final String? workType;

  // 4. Resume-Specific
  final String? resumeSummary;
  final String? atsScore;

  // 5. Experience
  final String? experienceDetails; // Storing as a big string for now, could be List<Map> later

  JobSeekerProfileModel({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.updatedAt,
    this.highestQualification,
    this.totalExperience,
    this.currentJobTitle,
    this.employmentType,
    this.expectedSalaryRange,
    this.portfolioWebsite,
    this.linkedinProfile,
    this.countryCity,
    this.technicalSkills,
    this.softSkills,
    this.toolsTechnologies,
    this.certifications,
    this.targetJobRoles,
    this.preferredIndustries,
    this.preferredWorkLocation,
    this.workType,
    this.resumeSummary,
    this.atsScore,
    this.experienceDetails,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
      'updatedAt': updatedAt.toIso8601String(),
      'highestQualification': highestQualification,
      'totalExperience': totalExperience,
      'currentJobTitle': currentJobTitle,
      'employmentType': employmentType,
      'expectedSalaryRange': expectedSalaryRange,
      'portfolioWebsite': portfolioWebsite,
      'linkedinProfile': linkedinProfile,
      'countryCity': countryCity,
      'technicalSkills': technicalSkills,
      'softSkills': softSkills,
      'toolsTechnologies': toolsTechnologies,
      'certifications': certifications,
      'targetJobRoles': targetJobRoles,
      'preferredIndustries': preferredIndustries,
      'preferredWorkLocation': preferredWorkLocation,
      'workType': workType,
      'resumeSummary': resumeSummary,
      'atsScore': atsScore,
      'experienceDetails': experienceDetails,
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
      highestQualification: json['highestQualification'],
      totalExperience: json['totalExperience'],
      currentJobTitle: json['currentJobTitle'],
      employmentType: json['employmentType'],
      expectedSalaryRange: json['expectedSalaryRange'],
      portfolioWebsite: json['portfolioWebsite'],
      linkedinProfile: json['linkedinProfile'],
      countryCity: json['countryCity'],
      technicalSkills: json['technicalSkills'],
      softSkills: json['softSkills'],
      toolsTechnologies: json['toolsTechnologies'],
      certifications: json['certifications'],
      targetJobRoles: json['targetJobRoles'],
      preferredIndustries: json['preferredIndustries'],
      preferredWorkLocation: json['preferredWorkLocation'],
      workType: json['workType'],
      resumeSummary: json['resumeSummary'],
      atsScore: json['atsScore'],
      experienceDetails: json['experienceDetails'],
    );
  }

  double calculateCompletion() {
    int totalFields = 19;
    int filledFields = 0;
    
    if (highestQualification?.isNotEmpty == true) filledFields++;
    if (totalExperience?.isNotEmpty == true) filledFields++;
    if (currentJobTitle?.isNotEmpty == true) filledFields++;
    if (employmentType?.isNotEmpty == true) filledFields++;
    if (expectedSalaryRange?.isNotEmpty == true) filledFields++;
    if (portfolioWebsite?.isNotEmpty == true) filledFields++;
    if (linkedinProfile?.isNotEmpty == true) filledFields++;
    if (countryCity?.isNotEmpty == true) filledFields++;
    if (technicalSkills?.isNotEmpty == true) filledFields++;
    if (softSkills?.isNotEmpty == true) filledFields++;
    if (toolsTechnologies?.isNotEmpty == true) filledFields++;
    if (certifications?.isNotEmpty == true) filledFields++;
    if (targetJobRoles?.isNotEmpty == true) filledFields++;
    if (preferredIndustries?.isNotEmpty == true) filledFields++;
    if (preferredWorkLocation?.isNotEmpty == true) filledFields++;
    if (workType?.isNotEmpty == true) filledFields++;
    if (resumeSummary?.isNotEmpty == true) filledFields++;
    if (experienceDetails?.isNotEmpty == true) filledFields++;

    return 15.0 + (85.0 * (filledFields / totalFields));
  }
}
