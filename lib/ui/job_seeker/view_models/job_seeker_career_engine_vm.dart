import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fyp/data/repositories/auth_repository.dart';
import 'package:fyp/data/repositories/profile_repository.dart';
import 'package:fyp/model/job_seeker_profile_model.dart';
import 'package:fyp/services/ai_service.dart';

class JobSeekerCareerEngineViewModel extends GetxController {
  final AuthRepository _authRepository = Get.find();
  final ProfileRepository _profileRepository = Get.find();
  final AIService _aiService = AIService();

  var isLoading = false.obs;
  var isProfileIncomplete = false.obs;
  var recommendations = "".obs;
  var jobSeekerProfile = Rxn<JobSeekerProfileModel>();

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
      if (user?.id == null) return;

      final profile = await _profileRepository.getJobSeekerProfile(user!.id!);
      
      if (profile == null || !_isProfileComplete(profile)) {
        isProfileIncomplete.value = true;
        isLoading.value = false;
        return;
      }

      jobSeekerProfile.value = profile;
      
      String tierContext = "";
      if (profile.experienceLevel == "Fresh Graduate") {
        tierContext = """
        Analysis Type: Early Career Entry Strategies
        Focus: Transition from Education to Industry.
        1. Recommend 3-5 Entry-level Roles (e.g. Associate Developer, Junior Analyst) matching their degree (${profile.highestQualification}) and skills (${profile.technicalSkills}).
        2. Suggest top Companies or Startup ecosystems in Pakistan for Freshers.
        3. Advice on Portfolio/Project building to stand out.
        """;
      } else if (profile.experienceLevel == "Experienced Professional") {
        tierContext = """
        Analysis Type: Mid-Career Growth & Specialization
        Focus: Up-skilling and Leadership Transition.
        1. Recommend 3-4 Mid-to-Senior Roles based on their current title (${profile.currentJobTitle}) and ${profile.totalExperience} years of experience.
        2. Suggest specific Certifications (e.g. PMP, AWS Architect) to increase market value.
        3. Identify high-growth industries matching their interests (${profile.preferredIndustries}).
        """;
      } else {
        tierContext = """
        Analysis Type: Executive & Senior Leadership Roadmap
        Focus: Strategic Impact and Global Opportunities.
        1. Recommend Executive roles (e.g. CTO, Head of Engineering, Principal Architect).
        2. Suggest strategic skills like Stakeholder Management, Product Strategy, or Global Team Leadership.
        3. Advise on Personal Branding and Industry Networking for executive positions.
        """;
      }

      String prompt = """
      You are an expert AI Career Strategist for Professionals.
      
      Job Seeker Profile:
      - Name: ${profile.firstName} ${profile.lastName}
      - Career Stage: ${profile.experienceLevel}
      - Current Role: ${profile.currentJobTitle ?? 'N/A'}
      - Total Exp: ${profile.totalExperience ?? 'N/A'} Years
      - Interest: ${profile.targetJobRoles} in ${profile.preferredIndustries}
      
      $tierContext
      
      Format your output:
      # RECOMMENDATIONS:
      - [Title]: [Detailed rationale]
      
      # SKILL_GAPS:
      - [Specific technical or leadership gap]
      
      # ADVICE:
      [Professional closing thoughts]
      """;

      final response = await _aiService.sendMessage(prompt);
      recommendations.value = response ?? "Analysis failed.";
    } catch (e) {
      Get.snackbar("Error", "Failed to analyze: $e");
    } finally {
      isLoading.value = false;
    }
  }

  bool _isProfileComplete(JobSeekerProfileModel profile) {
    if (profile.experienceLevel == null) return false;
    if (profile.highestQualification == null || profile.highestQualification!.isEmpty) return false;
    if (profile.technicalSkills == null || profile.technicalSkills!.isEmpty) return false;
    if (profile.targetJobRoles == null || profile.targetJobRoles!.isEmpty) return false;
    
    if (profile.experienceLevel != "Fresh Graduate") {
      if (profile.currentJobTitle == null || profile.currentJobTitle!.isEmpty) return false;
      if (profile.totalExperience == null || profile.totalExperience!.isEmpty) return false;
    }
    
    return true;
  }
}
