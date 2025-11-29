import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../views/notifications_screen.dart';
import '../views/privacy_security_screen.dart';
import '../views/help_support_screen.dart';
import '../views/about_app_screen.dart';

class SettingsViewModel extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();

  void navigateToEditProfile() async {
    final user = await _authRepository.getCurrentUser();
    if (user != null) {
      Get.toNamed("/profile_setup_screen", arguments: user.id);
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

  void logout() {
    Get.defaultDialog(
      title: "Logout",
      middleText: "Are you sure you want to log out?",
      textConfirm: "Yes",
      textCancel: "No",
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      onConfirm: () async {
        try {
          await _authRepository.logout();
          Get.back(); // Close dialog
          Get.offAllNamed("/login_screen");
          Get.snackbar(
            "Success",
            "Logged out successfully",
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } catch (e) {
          Get.back(); // Close dialog
          Get.snackbar(
            "Error",
            "Failed to logout: $e",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      },
      onCancel: () {
        // Dialog dismissed automatically
      },
    );
  }
}
