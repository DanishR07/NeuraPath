import 'package:get/get.dart';
import 'package:fyp/data/repositories/auth_repository.dart';
import 'package:fyp/data/repositories/profile_repository.dart';
import 'package:fyp/services/ai_service.dart';

class SkillInsightViewModel extends GetxController {
  final AuthRepository _authRepository = Get.find();
  final ProfileRepository _profileRepository = ProfileRepository();
  final AIService _aiService = AIService();

  var isLoading = false.obs;
  var isProfileIncomplete = false.obs;
  var analysisResult = "".obs;
  var userRole = "".obs;

  @override
  void onInit() {
    super.onInit();
    performSkillAnalysis();
  }

  Future<void> performSkillAnalysis() async {
    isLoading.value = true;
    isProfileIncomplete.value = false;

    try {
      final user = await _authRepository.getCurrentUser();
      if (user?.id == null) return;
      userRole.value = user!.role ?? "Student";

      String prompt = "";
      
      if (userRole.value == "Student") {
        final profile = await _profileRepository.getStudentProfile(user.id!);
        if (profile == null) { isProfileIncomplete.value = true; return; }
        
        prompt = """
        User Role: Student
        Current Level: ${profile.educationLevel} (Major: ${profile.major})
        Goal: ${profile.preferredCareerFields}
        
        Task: Provide specialized academic and preparatory insights.
        # SUCCESS_ASPECTS:
        Identify 3 critical academic habits or extracurriculars they should adopt now.
        # MAJOR_GAPS:
        Highlight missing foundational skills or preparatory steps for their next academic goal.
        # RECOMMENDED_LEARNING:
        Suggest specific books, entrance exam prep (ECAT/MDCAT/SAT), or courses.
        """;
      } else if (userRole.value == "Job Seeker") {
        final profile = await _profileRepository.getJobSeekerProfile(user.id!);
        if (profile == null) { isProfileIncomplete.value = true; return; }
        
        prompt = """
        User Role: Job Seeker
        Current Skills: ${profile.technicalSkills}
        Target Roles: ${profile.targetJobRoles}
        
        Task: Provide a critical hiring roadmap.
        # SUCCESS_ASPECTS:
        Which specific job-hunting aspects (ATS Optimization, Portfolio, Networking) must they follow to get the job?
        # MAJOR_GAPS:
        Identify the top 3 technical or soft skill gaps for their target roles.
        # RECOMMENDED_LEARNING:
        Recommend 2-3 globally recognized certifications to instantly cover their gaps.
        """;
      } else {
        final profile = await _profileRepository.getProfessionalProfile(user.id!);
        if (profile == null) { isProfileIncomplete.value = true; return; }
        
        prompt = """
        User Role: Professional
        Current Level: ${profile.jobLevel} (Title: ${profile.currentJobTitle})
        Goal: ${profile.careerGoal}
        
        Task: Provide high-level growth insights.
        # SUCCESS_ASPECTS:
        Identify the strategic leadership or personal branding actions for their next promotion.
        # MAJOR_GAPS:
        Identify strategic mindset or executive skill gaps at their level.
        # RECOMMENDED_LEARNING:
        Suggest executive certifications and leadership development programs.
        """;
      }

      String finalPrompt = """
      You are an Expert Skills Analyst & Professional Learning Advisor.
      
      $prompt
      
      # ADVICE:
      Provide a brief closing executive summary.
      
      IMPORTANT: Use # SECTION_NAME: for each section exactly as structured above. 
      Keep the text professional, plain-text oriented, and DO NOT use any markdown asterisks (*).
      Do NOT use any cards or markdown styling in your response text.
      """;

      final response = await _aiService.sendMessage(finalPrompt);
      analysisResult.value = response ?? "Analysis unavailable.";
    } catch (e) {
      Get.snackbar("Error", "Skill Analysis failed: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
