import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/profile_repository.dart';
import '../../../model/professional_profile_model.dart';
import '../../../model/user_model.dart';

class ProfessionalProfileViewModel extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final ProfileRepository _profileRepository = ProfileRepository();

  var isLoading = false.obs;
  var user = Rxn<UserModel>();
  var professionalProfile = Rxn<ProfessionalProfileModel>();
  var completionPercentage = 0.15.obs;

  // Controllers
  final currentJobTitleController = TextEditingController();
  final jobLevelController = TextEditingController();
  final currentCompanyController = TextEditingController();
  final yearsOfExperienceController = TextEditingController();
  final employmentTypeController = TextEditingController();
  final salaryRangeController = TextEditingController();
  final skillsController = TextEditingController();
  final toolsTechnologiesController = TextEditingController();
  final certificationsController = TextEditingController();

  final desiredNextJobRoleController = TextEditingController();
  final longTermCareerGoalController = TextEditingController();
  final industryInterestController = TextEditingController();

  final workHistoryDetailsController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadProfile();
    // Listen to real-time updates for the user (name, image, etc.)
    _authRepository.getUserStream().listen((updatedUser) {
      if (updatedUser != null) {
        user.value = updatedUser;
      }
    });
  }

  Future<void> loadProfile() async {
    isLoading.value = true;
    try {
      user.value = await _authRepository.getCurrentUser();
      if (user.value != null && user.value!.id != null) {
        final profile = await _profileRepository.getProfessionalProfile(user.value!.id!);
        professionalProfile.value = profile;
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

  void _populateFields(ProfessionalProfileModel profile) {
    currentJobTitleController.text = profile.currentJobTitle ?? '';
    jobLevelController.text = profile.jobLevel ?? '';
    currentCompanyController.text = profile.currentCompany ?? '';
    yearsOfExperienceController.text = profile.yearsOfExperience ?? '';
    employmentTypeController.text = profile.employmentType ?? '';
    salaryRangeController.text = profile.salaryRange ?? '';
    skillsController.text = profile.skills ?? '';
    toolsTechnologiesController.text = profile.toolsTechnologies ?? '';
    certificationsController.text = profile.certifications ?? '';

    desiredNextJobRoleController.text = profile.desiredNextJobRole ?? '';
    longTermCareerGoalController.text = profile.longTermCareerGoal ?? '';
    industryInterestController.text = profile.industryInterest ?? '';

    workHistoryDetailsController.text = profile.workHistoryDetails ?? '';
  }

  Future<void> saveProfile() async {
    if (user.value == null || user.value!.id == null) return;

    isLoading.value = true;
    try {
      final profile = ProfessionalProfileModel(
        userId: user.value!.id!,
        firstName: user.value!.firstName ?? '',
        lastName: user.value!.lastName ?? '',
        role: 'Professional',
        updatedAt: DateTime.now(),
        currentJobTitle: currentJobTitleController.text,
        jobLevel: jobLevelController.text,
        currentCompany: currentCompanyController.text,
        yearsOfExperience: yearsOfExperienceController.text,
        employmentType: employmentTypeController.text,
        salaryRange: salaryRangeController.text,
        skills: skillsController.text,
        toolsTechnologies: toolsTechnologiesController.text,
        certifications: certificationsController.text,
        desiredNextJobRole: desiredNextJobRoleController.text,
        longTermCareerGoal: longTermCareerGoalController.text,
        industryInterest: industryInterestController.text,
        workHistoryDetails: workHistoryDetailsController.text,
      );

      await _profileRepository.saveProfessionalProfile(profile);
      professionalProfile.value = profile;
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
