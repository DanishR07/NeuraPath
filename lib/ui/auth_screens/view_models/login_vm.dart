import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/repositories/auth_repository.dart';

class LoginViewModel extends GetxController {
  AuthRepository authRepository = Get.find();
  var isLoading = false.obs;
  final storage = GetStorage();
  Future<void> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {

    // Basic validations
    if (!email.contains("@")) {
      Get.snackbar("Error", "Enter a valid email",backgroundColor: Colors.red);
      return;
    }

    if (password.length < 6) {
      Get.snackbar("Error", "Password must be at least 6 characters long",backgroundColor: Colors.red);
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

      await authRepository.login(email, password);
      Get.offNamed('/home_screen');

    } on FirebaseAuthException catch (e) {
      Get.snackbar("Login Failed", "Email or password is incorrect.",backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  bool isUserLoggedIn() {
    return authRepository.getLoggedInUser() != null;
  }

  String? getLoggedInUserEmail() {
    return authRepository.getLoggedInUserEmail();
  }

  // LOAD SAVED CREDENTIALS
  Map<String, String> getSavedCredentials() {
    final savedEmail = storage.read('savedEmail') ?? '';
    final savedPassword = storage.read('savedPassword') ?? '';
    return {"email": savedEmail, "password": savedPassword};
  }
}
