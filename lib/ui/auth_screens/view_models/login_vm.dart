import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../services/connectivity_service.dart';
import '../../../customs.dart';

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
      String errorMessage = e.toString().replaceAll("Exception: ", "");
      if (errorMessage.startsWith("NOT_VERIFIED:")) {
        final userId = errorMessage.split(":")[1];
        
        Get.dialog(
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.5),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.85),
                      Colors.white.withOpacity(0.65),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen.withOpacity(0.15),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryGreen.withOpacity(0.2),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.mark_email_unread_rounded, color: AppColors.primaryGreen, size: 36),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Email Not Verified",
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: Colors.black87),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "You need to verify your email address before you can log in. Would you like to verify it now?",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: Colors.black54, height: 1.4),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text("Cancel", style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryGreen,
                            elevation: 8,
                            shadowColor: AppColors.primaryGreen.withOpacity(0.4),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () async {
                            Get.back(); // Close dialog
                            try {
                               await FirebaseAuth.instance.currentUser?.sendEmailVerification();
                               Get.offNamed("/email_verification_screen", arguments: userId);
                               Get.snackbar(
                                  'Verify Email',
                                  'We sent a new verification link to your email.',
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white,
                                );
                            } catch(sendError) {
                               Get.snackbar("Error", "Could not send verification email. Please try again later.", backgroundColor: Colors.red);
                            }
                          },
                          child: const Text("Verify Now", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          barrierDismissible: false,
        );
      } else {
        Get.snackbar("Login Failed", errorMessage, backgroundColor: Colors.red);
      }
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
