import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fyp/data/repositories/auth_repository.dart';
import 'package:fyp/data/repositories/profile_repository.dart';
import 'package:fyp/model/professional_profile_model.dart';
import 'package:fyp/services/ai_service.dart';

class GrowthPathwayViewModel extends GetxController {
  final AuthRepository _authRepository = Get.find();
  final ProfileRepository _profileRepository = ProfileRepository();
  final AIService _aiService = AIService();

  var isLoading = false.obs;
  var isProfileIncomplete = false.obs;
  var pathwayResult = "".obs;
  var professionalProfile = Rxn<ProfessionalProfileModel>();

  @override
  void onInit() {
    super.onInit();
    analyzeGrowth();
  }

  Future<void> analyzeGrowth() async {
    isLoading.value = true;
    isProfileIncomplete.value = false;
    
    try {
      final userResponse = await _authRepository.getCurrentUser();
      if (userResponse?.id == null) return;

      final profile = await _profileRepository.getProfessionalProfile(userResponse!.id!);
      
      if (profile == null || profile.calculateCompletion() < 1.0) {
        isProfileIncomplete.value = true;
        isLoading.value = false;
        return;
      }

      professionalProfile.value = profile;
      
      String prompt = """
      You are a Top-Tier Executive Career Coach & Growth Strategist.
      
      Professional Profile:
      - Name: ${profile.firstName} ${profile.lastName}
      - Current Role: ${profile.currentJobTitle} at ${profile.currentCompany}
      - Level: ${profile.jobLevel}
      - Total Exp: ${profile.yearsOfExperience} Years
      - Core Industry: ${profile.industry}
      - Skills: ${profile.skills}
      - Goal: ${profile.careerGoal}
      
      Objective: Provide a "Growth Pathway Analysis" for this professional.
      
      Format your response strictly as follows:
      # PROMOTION_PATHWAY:
      - [Milestone Title]: [Required actions, KPIs to hit, and internal positioning strategy to reach the next rank from their current level].
      
      # STRATEGIC_SKILLS:
      - [High-Level Skill]: [Why this is critical for leadership/seniority and how it bridges their current skill gap].
      
      # MARKET_BENCHMARK:
      [A professional assessment of how their current profile (${profile.jobLevel} with ${profile.yearsOfExperience} years) ranks against global industry benchmarks in ${profile.industry}].
      
      # ADVICE:
      [Executive summary and immediate "Power Move" they should make].
      """;

      final response = await _aiService.sendMessage(prompt);
      pathwayResult.value = response ?? "Analysis unavailable.";
    } catch (e) {
      Get.snackbar("Error", "Growth analysis failed: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void refreshAnalysis() => analyzeGrowth();
}
