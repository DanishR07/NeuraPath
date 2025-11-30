import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/profile_repository.dart';
import '../../../model/job_seeker_profile_model.dart';
import '../../../model/user_model.dart';

class JobSeekerProfileViewModel extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final ProfileRepository _profileRepository = ProfileRepository();

  var isLoading = false.obs;
  var user = Rxn<UserModel>();
  var jobSeekerProfile = Rxn<JobSeekerProfileModel>();
  var completionPercentage = 0.15.obs;

  // Controllers
  final highestQualificationController = TextEditingController();
  final totalExperienceController = TextEditingController();
  final currentJobTitleController = TextEditingController();
  final employmentTypeController = TextEditingController();
  final expectedSalaryRangeController = TextEditingController();
  final portfolioWebsiteController = TextEditingController();
  final linkedinProfileController = TextEditingController();
  final countryCityController = TextEditingController();

  final technicalSkillsController = TextEditingController();
  final softSkillsController = TextEditingController();
  final toolsTechnologiesController = TextEditingController();
  final certificationsController = TextEditingController();

  final targetJobRolesController = TextEditingController();
  final preferredIndustriesController = TextEditingController();
  final preferredWorkLocationController = TextEditingController();
  final workTypeController = TextEditingController();

  final resumeSummaryController = TextEditingController();
  final experienceDetailsController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    isLoading.value = true;
    try {
      user.value = await _authRepository.getCurrentUser();
      if (user.value != null && user.value!.id != null) {
        final profile = await _profileRepository.getJobSeekerProfile(user.value!.id!);
        jobSeekerProfile.value = profile;
        if (profile != null) {
          _populateFields(profile);
          completionPercentage.value = profile.calculateCompletion() / 100.0;
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void _populateFields(JobSeekerProfileModel profile) {
    highestQualificationController.text = profile.highestQualification ?? '';
    totalExperienceController.text = profile.totalExperience ?? '';
    currentJobTitleController.text = profile.currentJobTitle ?? '';
    employmentTypeController.text = profile.employmentType ?? '';
    expectedSalaryRangeController.text = profile.expectedSalaryRange ?? '';
    portfolioWebsiteController.text = profile.portfolioWebsite ?? '';
    linkedinProfileController.text = profile.linkedinProfile ?? '';
    countryCityController.text = profile.countryCity ?? '';

    technicalSkillsController.text = profile.technicalSkills ?? '';
    softSkillsController.text = profile.softSkills ?? '';
    toolsTechnologiesController.text = profile.toolsTechnologies ?? '';
    certificationsController.text = profile.certifications ?? '';

    targetJobRolesController.text = profile.targetJobRoles ?? '';
    preferredIndustriesController.text = profile.preferredIndustries ?? '';
    preferredWorkLocationController.text = profile.preferredWorkLocation ?? '';
    workTypeController.text = profile.workType ?? '';

    resumeSummaryController.text = profile.resumeSummary ?? '';
    experienceDetailsController.text = profile.experienceDetails ?? '';
  }

  Future<void> saveProfile() async {
    if (user.value == null || user.value!.id == null) return;

    isLoading.value = true;
    try {
      final profile = JobSeekerProfileModel(
        userId: user.value!.id!,
        firstName: user.value!.firstName ?? '',
        lastName: user.value!.lastName ?? '',
        role: 'Job Seeker',
        updatedAt: DateTime.now(),
        highestQualification: highestQualificationController.text,
        totalExperience: totalExperienceController.text,
        currentJobTitle: currentJobTitleController.text,
        employmentType: employmentTypeController.text,
        expectedSalaryRange: expectedSalaryRangeController.text,
        portfolioWebsite: portfolioWebsiteController.text,
        linkedinProfile: linkedinProfileController.text,
        countryCity: countryCityController.text,
        technicalSkills: technicalSkillsController.text,
        softSkills: softSkillsController.text,
        toolsTechnologies: toolsTechnologiesController.text,
        certifications: certificationsController.text,
        targetJobRoles: targetJobRolesController.text,
        preferredIndustries: preferredIndustriesController.text,
        preferredWorkLocation: preferredWorkLocationController.text,
        workType: workTypeController.text,
        resumeSummary: resumeSummaryController.text,
        experienceDetails: experienceDetailsController.text,
      );

      await _profileRepository.saveJobSeekerProfile(profile);
      jobSeekerProfile.value = profile;
      completionPercentage.value = profile.calculateCompletion() / 100.0;
      Get.back();
      Get.snackbar("Success", "Profile updated successfully", backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", "Failed to save profile: $e", backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}
