import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fyp/data/repositories/auth_repository.dart';
import 'package:fyp/data/repositories/profile_repository.dart';
import 'package:fyp/model/student_profile_model.dart';
import 'package:fyp/services/ai_service.dart';

class CareerEngineViewModel extends GetxController {
  final AuthRepository _authRepository = Get.find();
  final ProfileRepository _profileRepository = Get.find();
  final AIService _aiService = AIService();

  var isLoading = false.obs;
  var isProfileIncomplete = false.obs;
  var recommendations = "".obs;
  var studentProfile = Rxn<StudentProfileModel>();

  @override
  void onInit() {
    super.onInit();
    analyzeCareer();
  }

  Future<void> analyzeCareer() async {
    isLoading.value = true;
    isProfileIncomplete.value = false;
    
    try {
      final user = await _authRepository.getCurrentUser();
      if (user == null || user.id == null) {
        Get.snackbar("Error", "User session not found");
        return;
      }

      final profile = await _profileRepository.getStudentProfile(user.id!);
      
      if (profile == null || profile.calculateCompletion() < 1.0) {
        isProfileIncomplete.value = true;
        isLoading.value = false;
        return;
      }

      studentProfile.value = profile;
      
      String contextSpecificPrompt = "";
      if (profile.educationLevel == "Matric") {
        contextSpecificPrompt = """
        Analysis Type: Matric to Intermediate Transition
        Focus ONLY on Intermediate (College) options. 
        1. Recommend 3-5 specific Intermediate Majors (e.g. ICS, Pre-Medical, ICOM) that match their favorite subjects (${profile.favoriteSubjects}).
        2. Suggest top Colleges in Pakistan for these majors.
        3. Explain what they should study next to reach their goal (${profile.preferredCareerFields}).
        """;
      } else if (profile.educationLevel == "Intermediate") {
        contextSpecificPrompt = """
        Analysis Type: Intermediate to University Transition
        Focus ONLY on University & Degree options.
        1. Recommend 3-5 specific Degrees (e.g. BS Computer Science, MBBS, BBA) based on their major (${profile.major}) and marks (${profile.obtainedMarks}/${profile.totalMarks}).
        2. Suggest the best Universities in Pakistan and entrance exams (ECAT, MDCAT, etc.) they must prepare for.
        3. Explain why these degrees fit their interests (${profile.preferredCareerFields}).
        """;
      } else {
        contextSpecificPrompt = """
        Analysis Type: University Career Professional Roadmap
        Focus ONLY on Career & Skill Development.
        1. Recommend 2-4 specific Career Paths (e.g. DevOps Engineer, Data Scientist) based on their degree (${profile.degree}) and major (${profile.major}).
        2. Identify Skill Gaps in their profile (${profile.technicalSkills}) and suggest 3 key areas to develop.
        3. Provide industry-aligned advice to succeed in their next job role.
        """;
      }

      String prompt = """
      You are an expert AI Academic & Career Advisor.
      
      Student Profile:
      - Name: ${profile.firstName} ${profile.lastName}
      - Level: ${profile.educationLevel}
      - Institution: ${profile.institution}
      - Major: ${profile.major}
      - Performance: ${profile.educationLevel == "University" ? "CGPA: ${profile.cgpa}" : "Marks: ${profile.obtainedMarks}/${profile.totalMarks}"}
      - Interests: ${profile.preferredCareerFields}
      
      $contextSpecificPrompt
      
      Format your output as followed:
      # RECOMMENDATIONS:
      - [Recommendation Title]: [Detailed explanation of why this fits their profile]
      
      # SKILL_GAPS:
      - [A specific skill or preparatory subject they are missing]
      
      # ADVICE:
      [A supportive closing statement with clear next steps]
      """;

      final response = await _aiService.sendMessage(prompt);
      recommendations.value = response ?? "Failed to generate recommendations.";
    } catch (e) {
      Get.snackbar("Error", "Failed to analyze career: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void refreshAnalysis() => analyzeCareer();
}
