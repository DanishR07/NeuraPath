import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../services/connectivity_service.dart';

class LoginViewModel extends GetxController {
  AuthRepository authRepository = Get.find();
  var isLoading = false.obs;
  final storage = GetStorage();
  Future<void> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {

    final hasInternet = await ConnectivityService.hasInternetConnection();
    if (!hasInternet) {
      Get.snackbar("No Internet", ConnectivityService.getNoInternetMessage(), backgroundColor: Colors.red);
      return;
    }

    // Basic validations
    if (!email.contains("@")) {
      Get.snackbar("Error", "Enter a valid email",backgroundColor: Colors.red);
      return;
    }

    isLoading.value = true;

    try {
      // Save or clear credentials
      if (rememberMe) {
        await storage.write('savedEmail', email);
        await storage.write('savedPassword', password);
      } else {
        await storage.remove('savedEmail');
        await storage.remove('savedPassword');
      }

      final userModel = await authRepository.login(email, password);

      final isProfileComplete = await authRepository.isProfileComplete(userModel.id!);

      if (isProfileComplete) {
        _navigateToRoleBasedHomeScreen(userModel.role ?? 'Student');
      } else {
        Get.offNamed("/profile_setup_screen", arguments: userModel.id);
        Get.snackbar('Info', 'Please complete your profile to continue',backgroundColor: Colors.blue);
      }

    } on FirebaseAuthException catch (e) {
      Get.snackbar("Login Failed", "Email or password is incorrect.",backgroundColor: Colors.red);
    } catch (e) {
      print("  Login error: $e");
      Get.snackbar("Login Failed", e.toString().replaceAll("Exception: ", ""),backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  void _navigateToRoleBasedHomeScreen(String role) {
    String routeName;
    switch (role.toLowerCase()) {
      case 'student':
        routeName = '/student_home_screen';
        break;
      case 'job seeker':
        routeName = '/job_seeker_home_screen';
        break;
      case 'professional':
        routeName = '/professional_home_screen';
        break;
      default:
        routeName = '/home_screen';
    }
    Get.offNamed(routeName);
  }

  bool isUserLoggedIn() {
    return authRepository.getLoggedInUser() != null;
  }

  Future<String?> getLoggedInUserEmail() {
    return authRepository.getLoggedInUserEmail();
  }

  // LOAD SAVED CREDENTIALS
  Map<String, String> getSavedCredentials() {
    final savedEmail = storage.read('savedEmail') ?? '';
    final savedPassword = storage.read('savedPassword') ?? '';
    return {"email": savedEmail, "password": savedPassword};
  }
}
