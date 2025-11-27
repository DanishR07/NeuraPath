import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../services/connectivity_service.dart';

class SignUpViewModel extends GetxController {
  AuthRepository authRepository = Get.find();
  var isLoading = false.obs;

  Future<void> signup(
    String email,
    String password,
    String confirmPassword,
  ) async {
    final hasInternet = await ConnectivityService.hasInternetConnection();
    if (!hasInternet) {
      Get.snackbar(
        "No Internet",
        ConnectivityService.getNoInternetMessage(),
        backgroundColor: Colors.red,
      );
      return;
    }

    if (!email.contains("@")) {
      Get.snackbar("Error", "Enter proper email", backgroundColor: Colors.red);
      return;
    }
    if (password.length < 6) {
      Get.snackbar(
        "Error",
        "Password must be 6 characters long",
        backgroundColor: Colors.red,
      );
      return;
    }
    // At least 1 uppercase
    if (!password.contains(RegExp(r'[A-Z]'))) {
      Get.snackbar(
        "Error",
        "Password must contain at least 1 uppercase letter",
        backgroundColor: Colors.red,
      );
      return;
    }

    // At least 1 lowercase
    if (!password.contains(RegExp(r'[a-z]'))) {
      Get.snackbar(
        "Error",
        "Password must contain at least 1 lowercase letter",
        backgroundColor: Colors.red,
      );
      return;
    }

    // At least 1 digit
    if (!password.contains(RegExp(r'[0-9]'))) {
      Get.snackbar(
        "Error",
        "Password must contain at least 1 digit",
        backgroundColor: Colors.red,
      );
      return;
    }
    if (password != confirmPassword) {
      Get.snackbar(
        "Error",
        "Password and confirm password must match",
        backgroundColor: Colors.red,
      );
      return;
    }
    isLoading.value = true;
    try {
      final userModel = await authRepository.signup(email, password);
      Get.offNamed("/profile_setup_screen", arguments: userModel.id);
      Get.snackbar(
        'Info',
        'Account created! Please complete your profile',
        backgroundColor: Colors.green,
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Error",
        e.message ?? "Signup failed",
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  bool isUserLoggedIn() {
    return authRepository.getLoggedInUser() != null;
  }
}
