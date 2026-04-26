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
  var completionPercentage = 0.15.obs;

  // New Observables
  var educationLevel = "University".obs;

  // Controllers
  final institutionController = TextEditingController(); // School/College/Uni
  final majorController = TextEditingController(); 
  final degreeController = TextEditingController();    // Uni only
  
  final totalMarksController = TextEditingController();    // Matric/Inter
  final obtainedMarksController = TextEditingController(); // Matric/Inter
  final cgpaController = TextEditingController();          // Uni
  final semesterYearController = TextEditingController();
  
  final technicalSkillsController = TextEditingController();  // Uni
  final favoriteSubjectsController = TextEditingController(); // Matric/Inter
  final preferredCareerFieldsController = TextEditingController();

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
        final profile = await _profileRepository.getStudentProfile(user.value!.id!);
        studentProfile.value = profile;
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

  void _populateFields(StudentProfileModel profile) {
    educationLevel.value = profile.educationLevel ?? "University";
    institutionController.text = profile.institution ?? '';
    majorController.text = profile.major ?? '';
    degreeController.text = profile.degree ?? '';
    totalMarksController.text = profile.totalMarks ?? '';
    obtainedMarksController.text = profile.obtainedMarks ?? '';
    cgpaController.text = profile.cgpa ?? '';
    semesterYearController.text = profile.semesterYear ?? '';
    technicalSkillsController.text = profile.technicalSkills ?? '';
    favoriteSubjectsController.text = profile.favoriteSubjects ?? '';
    preferredCareerFieldsController.text = profile.preferredCareerFields ?? '';
  }

  Future<void> saveProfile() async {
    if (user.value?.id == null) return;

    isLoading.value = true;
    try {
      final profile = StudentProfileModel(
        userId: user.value!.id!,
        firstName: user.value!.firstName ?? '',
        lastName: user.value!.lastName ?? '',
        role: 'Student',
        updatedAt: DateTime.now(),
        educationLevel: educationLevel.value,
        institution: institutionController.text,
        major: majorController.text,
        degree: degreeController.text,
        totalMarks: totalMarksController.text,
        obtainedMarks: obtainedMarksController.text,
        cgpa: cgpaController.text,
        semesterYear: semesterYearController.text,
        technicalSkills: technicalSkillsController.text,
        favoriteSubjects: favoriteSubjectsController.text,
        preferredCareerFields: preferredCareerFieldsController.text,
      );

      await _profileRepository.saveStudentProfile(profile);
      studentProfile.value = profile;
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

