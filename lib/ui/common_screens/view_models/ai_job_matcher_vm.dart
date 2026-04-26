import 'dart:convert';
import 'package:get/get.dart';
import 'package:fyp/data/repositories/auth_repository.dart';
import 'package:fyp/data/repositories/profile_repository.dart';
import 'package:fyp/model/job_model.dart';
import 'package:fyp/model/job_seeker_profile_model.dart';
import 'package:fyp/model/professional_profile_model.dart';
import 'package:fyp/services/ai_service.dart';

class AIJobMatcherViewModel extends GetxController {
  final AuthRepository _authRepository = Get.find();
  final ProfileRepository _profileRepository = ProfileRepository();
  final AIService _aiService = AIService();

  var isLoading = false.obs;
  var matchedJobs = <JobModel>[].obs;
  var userRole = "".obs;

  final List<Map<String, dynamic>> _mockJobPool = [
    {
      "id": "1",
      "title": "Junior Flutter Developer",
      "company": "TechStart Inc",
      "location": "Lahore (Remote)",
      "salary": "PKR 60k - 80k",
      "experience": "0-1 Year",
      "level": "Fresh Graduate",
      "skills": ["Flutter", "Dart", "Firebase"],
      "description": "Develop mobile applications using Flutter framework..."
    },
    {
      "id": "2",
      "title": "Senior Software Engineer",
      "company": "Global Solutions",
      "location": "Karachi",
      "salary": "PKR 250k - 350k",
      "experience": "5-7 Years",
      "level": "Senior/Specialist",
      "skills": ["Node.js", "AWS", "Microservices", "Docker"],
      "description": "Architect high-scale backend systems..."
    },
    {
      "id": "3",
      "title": "Engineering Manager",
      "company": "Careem",
      "location": "Lahore",
      "salary": "PKR 450k - 600k",
      "experience": "8+ Years",
      "level": "Management/Lead",
      "skills": ["Leadership", "System Design", "Product Strategy"],
      "description": "Lead and mentor cross-functional engineering teams..."
    },
    {
      "id": "4",
      "title": "CTO / Head of Engineering",
      "company": "Fintech Disruptors",
      "location": "Islamabad",
      "salary": "PKR 800k+",
      "experience": "12+ Years",
      "level": "Director/Executive",
      "skills": ["Strategic Planning", "Business Ops", "Tech Leadership"],
      "description": "Define tech vision for a high-growth fintech startup..."
    },
    {
      "id": "5",
      "title": "Mid-Level React Developer",
      "company": "Suhad Tech",
      "location": "Faisalabad",
      "salary": "PKR 120k - 180k",
      "experience": "2-4 Years",
      "level": "Experienced Professional",
      "skills": ["React", "TypeScript", "Redux"],
      "description": "Maintain and scale large-scale web applications..."
    }
  ];

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

      if (userRole.value == "Job Seeker") {
        profile = await _profileRepository.getJobSeekerProfile(user.id!);
        if (profile == null) throw "Profile incomplete";
        
        prompt = """
        User Profile (Job Seeker):
        - Skills: ${profile.technicalSkills}
        - Level: ${profile.experienceLevel}
        - Preferred Roles: ${profile.targetJobRoles}
        
        Job Pool: ${jsonEncode(_mockJobPool)}
        
        Task: Act as an AI Recruiter. Pick exactly 2-3 jobs from the pool that BEST match this user's skills and preferences.
        Return ONLY a JSON list of Job IDs. Example: ["1", "5"]
        """;
      } else {
        profile = await _profileRepository.getProfessionalProfile(user.id!);
        if (profile == null) throw "Profile incomplete";
        
        prompt = """
        User Profile (Professional):
        - Current Role: ${profile.currentJobTitle}
        - Current Level: ${profile.jobLevel}
        - Goal: ${profile.careerGoal}
        
        Job Pool: ${jsonEncode(_mockJobPool)}
        
        Task: Act as an AI Executive Headhunter. Pick exactly 2 jobs from the pool that represent a STEP-UP or BETTER POSITION than their current level (${profile.jobLevel}).
        Do NOT show jobs at their current level or below.
        Return ONLY a JSON list of Job IDs. Example: ["3", "4"]
        """;
      }

      final response = await _aiService.sendMessage(prompt);
      final cleanJson = response.replaceAll('`', '').replaceAll('json', '').trim();
      final List<dynamic> matchedIds = jsonDecode(cleanJson);

      for (var id in matchedIds) {
        final jobData = _mockJobPool.firstWhere((j) => j['id'] == id.toString(), orElse: () => {});
        if (jobData.isNotEmpty) {
          matchedJobs.add(JobModel.fromMock(jobData));
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Matching failed: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
