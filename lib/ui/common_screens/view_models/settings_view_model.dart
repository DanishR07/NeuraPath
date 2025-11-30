import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../views/notifications_screen.dart';
import '../views/privacy_security_screen.dart';
import '../views/help_support_screen.dart';
import '../views/about_app_screen.dart';
import '../views/edit_profile_screen.dart';

class SettingsViewModel extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();

  void navigateToEditProfile() async {
    final user = await _authRepository.getCurrentUser();
    if (user != null && user.id != null) {
      Get.to(() => EditProfileScreen(userId: user.id!));
    } else {
      Get.snackbar("Error", "User not found");
    }
  }

  void navigateToNotifications() {
    Get.to(() => NotificationsScreen());
  }

  void navigateToPrivacySecurity() {
    Get.to(() => PrivacySecurityScreen());
  }

  void navigateToHelpSupport() {
    Get.to(() => HelpSupportScreen());
  }

  void navigateToAboutApp() {
    Get.to(() => AboutAppScreen());
  }

  Future logout() async {
    try {
      await _authRepository.logout();
      Get.offAllNamed("/login_screen");

      Get.snackbar(
        "Success",
        "Logged out successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to logout: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
