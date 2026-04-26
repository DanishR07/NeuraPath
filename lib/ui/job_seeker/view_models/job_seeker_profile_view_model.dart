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

  // New Observables
  var experienceLevel = "Fresh Graduate".obs;

  // Controllers
  final currentJobTitleController = TextEditingController();
  final highestQualificationController = TextEditingController();
  final totalExperienceController = TextEditingController();
  final technicalSkillsController = TextEditingController();
  final certificationsController = TextEditingController();
  
  final targetJobRolesController = TextEditingController();
  final preferredIndustriesController = TextEditingController();
  final expectedSalaryRangeController = TextEditingController();
  final jobTypeController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadProfile();
    _authRepository.getUserStream().listen((updatedUser) {
      if (updatedUser != null) user.value = updatedUser;
    });
  }

  Future<void> loadProfile() async {
    isLoading.value = true;
    try {
      user.value = await _authRepository.getCurrentUser();
      if (user.value?.id != null) {
        final profile = await _profileRepository.getJobSeekerProfile(user.value!.id!);
        jobSeekerProfile.value = profile;
        if (profile != null) {
          _populateFields(profile);
          completionPercentage.value = profile.calculateCompletion();
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void _populateFields(JobSeekerProfileModel profile) {
    experienceLevel.value = profile.experienceLevel ?? "Fresh Graduate";
    currentJobTitleController.text = profile.currentJobTitle ?? '';
    highestQualificationController.text = profile.highestQualification ?? '';
    totalExperienceController.text = profile.totalExperience ?? '';
    technicalSkillsController.text = profile.technicalSkills ?? '';
    certificationsController.text = profile.certifications ?? '';
    targetJobRolesController.text = profile.targetJobRoles ?? '';
    preferredIndustriesController.text = profile.preferredIndustries ?? '';
    expectedSalaryRangeController.text = profile.expectedSalaryRange ?? '';
    jobTypeController.text = profile.jobType ?? '';
  }

  Future<void> saveProfile() async {
    if (user.value?.id == null) return;

    isLoading.value = true;
    try {
      final profile = JobSeekerProfileModel(
        userId: user.value!.id!,
        firstName: user.value!.firstName ?? '',
        lastName: user.value!.lastName ?? '',
        role: 'Job Seeker',
        updatedAt: DateTime.now(),
        experienceLevel: experienceLevel.value,
        currentJobTitle: currentJobTitleController.text,
        highestQualification: highestQualificationController.text,
        totalExperience: totalExperienceController.text,
        technicalSkills: technicalSkillsController.text,
        certifications: certificationsController.text,
        targetJobRoles: targetJobRolesController.text,
        preferredIndustries: preferredIndustriesController.text,
        expectedSalaryRange: expectedSalaryRangeController.text,
        jobType: jobTypeController.text,
      );

      await _profileRepository.saveJobSeekerProfile(profile);
      jobSeekerProfile.value = profile;
      completionPercentage.value = profile.calculateCompletion();
      Get.back();
      Get.snackbar("Success", "Profile updated", backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", "Failed to save: $e", backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}

