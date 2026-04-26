import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmailVerificationViewModel extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  var isEmailVerified = false.obs;
  var canResendEmail = false.obs;
  var secondsRemaining = 60.obs;

  Timer? _timer;
  Timer? _verificationTimer;

  // We receive the userId when navigating to this screen
  late String userId;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      userId = Get.arguments as String;
    } else {
      // Fallback
      userId = _auth.currentUser?.uid ?? '';
    }

    isEmailVerified.value = _auth.currentUser?.emailVerified ?? false;

    if (!isEmailVerified.value) {
      startResendTimer();
      startVerificationCheck();
    }
  }

  void startResendTimer() {
    canResendEmail.value = false;
    secondsRemaining.value = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        canResendEmail.value = true;
        timer.cancel();
      }
    });
  }

  void startVerificationCheck() {
    _verificationTimer?.cancel();
    _verificationTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      final user = _auth.currentUser;
      if (user != null) {
        await user.reload();
        if (user.emailVerified) {
          isEmailVerified.value = true;
          timer.cancel();
          _timer?.cancel();
          Get.snackbar(
            'Success',
            'Email successfully verified!',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        }
      }
    });
  }

  Future<void> resendVerificationEmail() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.sendEmailVerification();
        startResendTimer();
        Get.snackbar(
          'Email Sent',
          'A new verification link has been sent.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void checkManualVerificationStatus() async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.reload();
      if (user.emailVerified) {
        isEmailVerified.value = true;
        _verificationTimer?.cancel();
        _timer?.cancel();
        Get.snackbar(
          'Success',
          'Email successfully verified!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Oops',
          'Email not verified yet. Please check your inbox.',
          backgroundColor: Colors.blue,
          colorText: Colors.white,
        );
      }
    }
  }

  void proceedToProfile() {
    if (isEmailVerified.value) {
      Get.offNamed("/profile_setup_screen", arguments: userId);
    } else {
      Get.snackbar(
        'Warning',
        'Please verify your email first.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    _verificationTimer?.cancel();
    super.onClose();
  }
}
