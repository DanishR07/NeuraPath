import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../services/connectivity_service.dart';

class ResetPasswordViewModel extends GetxController {
  AuthRepository authRepository = Get.find();

  var isUpdating = false.obs;
  var errorMessage = RxnString();
  var successMessage = RxnString();

  var password = ''.obs;
  var confirmPassword = ''.obs;
  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

  Map<String, bool> _validatePassword(String passwordInput) {
    return {
      'minLength': passwordInput.length >= 6,
      'hasUpperCase': passwordInput.contains(RegExp(r'[A-Z]')),
      'hasLowerCase': passwordInput.contains(RegExp(r'[a-z]')),
      'hasDigit': passwordInput.contains(RegExp(r'[0-9]')),
    };
  }

  String? validatePasswordStrength(String passwordInput) {
    if (passwordInput.isEmpty) {
      return 'Password cannot be empty';
    }

    final validation = _validatePassword(passwordInput);

    if (!validation['minLength']!) {
      return 'Password must be at least 6 characters long';
    }
    if (!validation['hasUpperCase']!) {
      return 'Password must contain an uppercase letter';
    }
    if (!validation['hasLowerCase']!) {
      return 'Password must contain a lowercase letter';
    }
    if (!validation['hasDigit']!) {
      return 'Password must contain a digit';
    }

    return null;
  }

  String? validatePasswordMatch(String pwd, String confirmPwd) {
    if (pwd != confirmPwd) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> resetPassword(String passwordInput, String confirmPasswordInput) async {
    // Reset messages
    errorMessage.value = null;
    successMessage.value = null;

    print('  [ResetPasswordVM] resetPassword: Checking reset email status');
    final resetEmail = authRepository.getResetEmail();
    print('  [ResetPasswordVM] resetPassword: Reset email from repository: $resetEmail');

    // Validate password strength
    final strengthError = validatePasswordStrength(passwordInput);
    if (strengthError != null) {
      Get.snackbar("Error", strengthError, backgroundColor: Colors.red);
      return;
    }
    // Validate password match
    final matchError = validatePasswordMatch(passwordInput, confirmPasswordInput);
    if (matchError != null) {
      Get.snackbar("Error", matchError, backgroundColor: Colors.red);
      return;
    }

    final hasInternet = await ConnectivityService.hasInternetConnection();
    if (!hasInternet) {
      Get.snackbar("No Internet", ConnectivityService.getNoInternetMessage(), backgroundColor: Colors.red);
      return;
    }

    try {
      isUpdating.value=true;
      print('  [ResetPasswordVM] resetPassword: Starting password reset process');
      // Call repository to update password via Cloud Function
      await authRepository.updatePassword(passwordInput);

      print('  [ResetPasswordVM] resetPassword: Password updated successfully');

      // Clear reset data
      authRepository.clearResetData();

      successMessage.value = 'Password reset successfully!';

      // Navigate to success screen
      Get.offNamed('/password_reset_success_message_screen');

    } on Exception catch (e) {
      print('  [ResetPasswordVM] resetPassword: ERROR - ${e.toString()}');
      errorMessage.value = 'Error: ${e.toString()}';
    } finally {
      isUpdating.value = false;
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.toggle();
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.toggle();
  }

  void clearError() {
    errorMessage.value = null;
  }
}
