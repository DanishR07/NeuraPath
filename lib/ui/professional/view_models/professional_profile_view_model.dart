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
  final jobLevelController = TextEditingController();
  final currentJobTitleController = TextEditingController();
  final currentCompanyController = TextEditingController();
  final yearsOfExperienceController = TextEditingController();
  final skillsController = TextEditingController();
  final certificationsController = TextEditingController();
  final industryController = TextEditingController();
  final salaryRangeController = TextEditingController();
  final careerGoalController = TextEditingController();

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
        final profile = await _profileRepository.getProfessionalProfile(user.value!.id!);
        professionalProfile.value = profile;
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

  void _populateFields(ProfessionalProfileModel profile) {
    jobLevelController.text = profile.jobLevel ?? '';
    currentJobTitleController.text = profile.currentJobTitle ?? '';
    currentCompanyController.text = profile.currentCompany ?? '';
    yearsOfExperienceController.text = profile.yearsOfExperience ?? '';
    skillsController.text = profile.skills ?? '';
    certificationsController.text = profile.certifications ?? '';
    industryController.text = profile.industry ?? '';
    salaryRangeController.text = profile.salaryRange ?? '';
    careerGoalController.text = profile.careerGoal ?? '';
  }

  Future<void> saveProfile() async {
    if (user.value?.id == null) return;

    isLoading.value = true;
    try {
      final profile = ProfessionalProfileModel(
        userId: user.value!.id!,
        firstName: user.value!.firstName ?? '',
        lastName: user.value!.lastName ?? '',
        role: 'Professional',
        updatedAt: DateTime.now(),
        jobLevel: jobLevelController.text,
        currentJobTitle: currentJobTitleController.text,
        currentCompany: currentCompanyController.text,
        yearsOfExperience: yearsOfExperienceController.text,
        skills: skillsController.text,
        certifications: certificationsController.text,
        industry: industryController.text,
        salaryRange: salaryRangeController.text,
        careerGoal: careerGoalController.text,
      );

      await _profileRepository.saveProfessionalProfile(profile);
      professionalProfile.value = profile;
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

