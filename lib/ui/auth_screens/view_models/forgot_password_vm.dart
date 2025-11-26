import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../services/connectivity_service.dart';

class ForgotPasswordViewModel extends GetxController {
  AuthRepository authRepository = Get.find();
  var isLoading = false.obs;
  var errorMessage = RxnString();
  var email = ''.obs;

  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return regex.hasMatch(email);
  }

  String? validateEmail(String emailInput) {
    if (emailInput.isEmpty) {
      return 'Please enter your email address';
    }
    if (!_isValidEmail(emailInput)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  Future<void> continueWithEmail(String emailInput) async {
    final validation = validateEmail(emailInput);
    if (validation != null) {
      errorMessage.value = validation;
      return;
    }

    final hasInternet = await ConnectivityService.hasInternetConnection();
    if (!hasInternet) {
      Get.snackbar("No Internet", ConnectivityService.getNoInternetMessage(), backgroundColor: Colors.red);
      return;
    }

    print('  [ForgotPassword] Step 1: ViewModel received emailInput: $emailInput');

    isLoading.value = true;
    errorMessage.value = null;

    try {
      email.value = emailInput.trim();

      print('  [ForgotPassword] Step 2: Trimmed email: ${email.value}');
      print('  [ForgotPassword] Step 3: Email length: ${email.value.length}');

      // Check if user exists
      final userExists = await authRepository.checkUserExists(email.value);
      print('  [ForgotPassword] Step 4: User exists check result: $userExists');

      if (!userExists) {
        print('  [ForgotPassword] Step 5: Email not found in database');
        errorMessage.value = 'No account found with this email';
        isLoading.value = false;
        return;
      }

      print('  [ForgotPassword] Step 6: User found, generating OTP');
      // Generate and send OTP via Cloud Function
      await authRepository.generateAndSendOTP(email.value);

      print('  [ForgotPassword] Step 7: OTP generated, checking reset email in repo');
      final storedResetEmail = authRepository.getResetEmail();
      print('  [ForgotPassword] Step 8: Reset email stored in repo: $storedResetEmail');

      // Navigate to OTP verification screen
      print('  [ForgotPassword] Step 9: Navigating to OTP verification screen');
      Get.offNamed('/otp_verification_screen');
    } on Exception catch (e) {
      print('  [ForgotPassword] Error: ${e.toString()}');
      errorMessage.value = 'An error occurred: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  void clearError() {
    errorMessage.value = null;
  }
}
