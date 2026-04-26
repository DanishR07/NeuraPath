import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fyp/data/repositories/auth_repository.dart';

class ChangePasswordViewModel extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();

  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isLoading = false.obs;
  var obscureCurrent = true.obs;
  var obscureNew = true.obs;
  var obscureConfirm = true.obs;

  void toggleCurrent() => obscureCurrent.value = !obscureCurrent.value;
  void toggleNew() => obscureNew.value = !obscureNew.value;
  void toggleConfirm() => obscureConfirm.value = !obscureConfirm.value;

  Future<void> changePassword() async {
    final current = currentPasswordController.text.trim();
    final newPass = newPasswordController.text.trim();
    final confirm = confirmPasswordController.text.trim();

    if (current.isEmpty || newPass.isEmpty || confirm.isEmpty) {
      Get.snackbar("Error", "Please fill all fields", backgroundColor: Colors.red);
      return;
    }

    if (newPass.length < 6) {
      Get.snackbar("Error", "New password must be at least 6 characters", backgroundColor: Colors.red);
      return;
    }

    // Complexity Validation: One uppercase, one lowercase, and one digit
    final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$');
    if (!passwordRegex.hasMatch(newPass)) {
      Get.snackbar(
        "Strong Password Required", 
        "Password must contain at least one uppercase letter, one lowercase letter, and one digit.",
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    if (newPass != confirm) {
      Get.snackbar("Error", "Passwords do not match", backgroundColor: Colors.red);
      return;
    }

    if (current == newPass) {
       Get.snackbar("Error", "New password must be different from current", backgroundColor: Colors.red);
       return;
    }

    isLoading.value = true;
    try {
      await _authRepository.reauthenticateAndChangePassword(current, newPass);
      // Return true to calling screen without showing snackbar here
      Get.back(result: true);
    } catch (e) {

      Get.snackbar("Failed", e.toString().replaceAll("Exception:", ""), backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
