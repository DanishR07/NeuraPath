import 'dart:convert';
import 'package:get/get.dart';
import 'package:fyp/data/repositories/auth_repository.dart';
import 'package:fyp/data/repositories/profile_repository.dart';
import 'package:fyp/model/job_model.dart';
import 'package:fyp/model/job_seeker_profile_model.dart';
import 'package:fyp/model/professional_profile_model.dart';
import 'package:fyp/services/ai_service.dart';
import 'package:fyp/services/job_scraper_service.dart';

class AIJobMatcherViewModel extends GetxController {
  final AuthRepository _authRepository = Get.find();
  final ProfileRepository _profileRepository = ProfileRepository();
  final AIService _aiService = AIService();
  final JobScraperService _scraperService = JobScraperService();

  var isLoading = false.obs;
  var isProfileIncomplete = false.obs;
  var matchedJobs = <JobModel>[].obs;
  var userRole = "".obs;

  @override
  void onInit() {
    super.onInit();
    findMatches();
  }

  Future<void> findMatches() async {
    isLoading.value = true;
    matchedJobs.clear();

    try {
      final user = await _authRepository.getCurrentUser();
      if (user?.id == null) return;
      userRole.value = user!.role ?? "Job Seeker";

      dynamic profile;
      String prompt = "";
      String searchQuery = "";

      isProfileIncomplete.value = false;

      if (userRole.value == "Job Seeker") {
        profile = await _profileRepository.getJobSeekerProfile(user.id!);
        if (profile == null || profile.calculateCompletion() < 1.0) {
          isProfileIncomplete.value = true;
          isLoading.value = false;
          return;
        }
        
        searchQuery = profile.targetJobRoles.isNotEmpty ? profile.targetJobRoles.split(',').first.trim() : "Developer";
      } else {
        profile = await _profileRepository.getProfessionalProfile(user.id!);
        if (profile == null || profile.calculateCompletion() < 1.0) {
          isProfileIncomplete.value = true;
          isLoading.value = false;
          return;
        }
        
        searchQuery = profile.currentJobTitle.isNotEmpty ? profile.currentJobTitle : "Manager";
      }

      // Step 1: Fetch Live Jobs
      List<Map<String, dynamic>> liveJobs = await _scraperService.fetchRealTimeJobs(searchQuery);

      if (liveJobs.isEmpty) {
        throw "No open positions found right now. Try updating your profile skills.";
      }

      // Take top 15 jobs to prevent payload from being too huge for AI
      final jobPoolToAnalyze = liveJobs.take(15).toList();

      // Step 2: Use AI to filter and pick the best jobs based on role
      if (userRole.value == "Job Seeker") {
        prompt = """
        User Profile (Job Seeker):
        - Skills: ${profile.technicalSkills}
        - Level: ${profile.experienceLevel}
        - Preferred Roles: ${profile.targetJobRoles}
        
        Job Pool: ${jsonEncode(jobPoolToAnalyze)}
        
        Task: Act as an AI Recruiter. Pick exactly 2-3 jobs from the pool that BEST match this user's skills and preferences.
        Return ONLY a JSON list of Job IDs. Example: ["123", "456"]
        """;
      } else {
        prompt = """
        User Profile (Professional):
        - Current Role: ${profile.currentJobTitle}
        - Current Level: ${profile.jobLevel}
        - Goal: ${profile.careerGoal}
        
        Job Pool: ${jsonEncode(jobPoolToAnalyze)}
        
        Task: Act as an AI Executive Headhunter. Pick exactly 2 jobs from the pool that represent a STEP-UP or BETTER POSITION than their current level (${profile.jobLevel}).
        Do NOT show jobs at their current level or below. 
        Return ONLY a JSON list of Job IDs. Example: ["789", "101"]
        """;
      }

      final response = await _aiService.sendMessage(prompt);
      
      // Attempt to extract JSON from response
      final cleanJsonMatch = RegExp(r'\[.*\]', dotAll: true).firstMatch(response);
      List<dynamic> matchedIds = [];
      
      if (cleanJsonMatch != null) {
        try {
          matchedIds = jsonDecode(cleanJsonMatch.group(0)!);
        } catch(e) {
          matchedIds = jobPoolToAnalyze.take(3).map((e) => e['id']).toList();
        }
      } else {
        matchedIds = jobPoolToAnalyze.take(3).map((e) => e['id']).toList();
      }

      for (var id in matchedIds) {
        final jobData = jobPoolToAnalyze.firstWhere((j) => j['id'].toString() == id.toString(), orElse: () => {});
        if (jobData.isNotEmpty) {
          if (userRole.value == "Professional") {
            jobData['level'] = "Advanced / Next-Level";
          } else {
            jobData['level'] = profile.experienceLevel ?? "Entry/Mid";
          }
          
          matchedJobs.add(JobModel.fromMock(jobData));
        }
      }

      if (matchedJobs.isEmpty) {
        for (var jobData in jobPoolToAnalyze.take(2)) {
             matchedJobs.add(JobModel.fromMock(jobData));
        }
      }

    } catch (e) {
      Get.snackbar("Error", "Matching failed: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void refreshMatches() => findMatches();
}
