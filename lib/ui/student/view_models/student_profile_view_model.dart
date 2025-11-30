import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/profile_repository.dart';
import '../../../model/student_profile_model.dart';
import '../../../model/user_model.dart';

class StudentProfileViewModel extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final ProfileRepository _profileRepository = ProfileRepository();

  var isLoading = false.obs;
  var user = Rxn<UserModel>();
  var studentProfile = Rxn<StudentProfileModel>();
  var completionPercentage = 0.15.obs; // Default 15%

  // Controllers
  final currentDegreeController = TextEditingController();
  final majorController = TextEditingController();
  final universityController = TextEditingController();
  final semesterYearController = TextEditingController();
  final cgpaController = TextEditingController();
  final expectedGraduationYearController = TextEditingController();
  final projectsCompletedController = TextEditingController();
  final preferredIndustryDomainsController = TextEditingController();

  final technicalSkillsController = TextEditingController();
  final softSkillsController = TextEditingController();
  final programmingLanguagesController = TextEditingController();
  final toolsTechnologiesController = TextEditingController();

  final preferredCareerFieldsController = TextEditingController();
  final targetJobRolesController = TextEditingController();
  final preferredWorkTypeController = TextEditingController();
  final preferredLocationsController = TextEditingController();

  final internshipsController = TextEditingController();
  final partTimeJobsController = TextEditingController();

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
        final profile = await _profileRepository.getStudentProfile(user.value!.id!);
        studentProfile.value = profile;
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

  void _populateFields(StudentProfileModel profile) {
    currentDegreeController.text = profile.currentDegree ?? '';
    majorController.text = profile.major ?? '';
    universityController.text = profile.university ?? '';
    semesterYearController.text = profile.semesterYear ?? '';
    cgpaController.text = profile.cgpa ?? '';
    expectedGraduationYearController.text = profile.expectedGraduationYear ?? '';
    projectsCompletedController.text = profile.projectsCompleted ?? '';
    preferredIndustryDomainsController.text = profile.preferredIndustryDomains ?? '';

    technicalSkillsController.text = profile.technicalSkills ?? '';
    softSkillsController.text = profile.softSkills ?? '';
    programmingLanguagesController.text = profile.programmingLanguages ?? '';
    toolsTechnologiesController.text = profile.toolsTechnologies ?? '';

    preferredCareerFieldsController.text = profile.preferredCareerFields ?? '';
    targetJobRolesController.text = profile.targetJobRoles ?? '';
    preferredWorkTypeController.text = profile.preferredWorkType ?? '';
    preferredLocationsController.text = profile.preferredLocations ?? '';

    internshipsController.text = profile.internships ?? '';
    partTimeJobsController.text = profile.partTimeJobs ?? '';
  }

  Future<void> saveProfile() async {
    if (user.value == null || user.value!.id == null) return;

    isLoading.value = true;
    try {
      final profile = StudentProfileModel(
        userId: user.value!.id!,
        firstName: user.value!.firstName ?? '',
        lastName: user.value!.lastName ?? '',
        role: 'Student',
        updatedAt: DateTime.now(),
        currentDegree: currentDegreeController.text,
        major: majorController.text,
        university: universityController.text,
        semesterYear: semesterYearController.text,
        cgpa: cgpaController.text,
        expectedGraduationYear: expectedGraduationYearController.text,
        projectsCompleted: projectsCompletedController.text,
        preferredIndustryDomains: preferredIndustryDomainsController.text,
        technicalSkills: technicalSkillsController.text,
        softSkills: softSkillsController.text,
        programmingLanguages: programmingLanguagesController.text,
        toolsTechnologies: toolsTechnologiesController.text,
        preferredCareerFields: preferredCareerFieldsController.text,
        targetJobRoles: targetJobRolesController.text,
        preferredWorkType: preferredWorkTypeController.text,
        preferredLocations: preferredLocationsController.text,
        internships: internshipsController.text,
        partTimeJobs: partTimeJobsController.text,
      );

      await _profileRepository.saveStudentProfile(profile);
      studentProfile.value = profile;
      completionPercentage.value = profile.calculateCompletion() / 100.0;
      Get.back(); // Return to view screen
      Get.snackbar("Success", "Profile updated successfully", backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", "Failed to save profile: $e", backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}
