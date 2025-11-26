import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../services/connectivity_service.dart';

class OtpVerificationViewModel extends GetxController {
  AuthRepository authRepository = Get.find();

  var isVerifying = false.obs;
  var errorMessage = RxnString();
  var successMessage = RxnString();

  var otpSecondsRemaining = 300.obs; // 5 minutes
  var resendCooldownSeconds = 60.obs;
  var isOTPExpired = false.obs;
  var isResendCooldownActive = true.obs;
  var isResending = false.obs;


  late Timer _otpExpiryTimer;
  late Timer _resendCooldownTimer;

  @override
  void onInit() {
    super.onInit();
    final email = authRepository.getResetEmail();
    print('[v1] [OTPVerification] onInit: Email from repo: $email');
    _startOTPExpiryTimer();
    _startResendCooldownTimer();
  }

  void _startOTPExpiryTimer() {
    _otpExpiryTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      otpSecondsRemaining.value--;
      if (otpSecondsRemaining.value <= 0) {
        isOTPExpired.value = true;
        _otpExpiryTimer.cancel();
      }
    });
  }

  void _startResendCooldownTimer() {
    isResendCooldownActive.value = true;
    _resendCooldownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      resendCooldownSeconds.value--;
      if (resendCooldownSeconds.value <= 0) {
        isResendCooldownActive.value = false;
        _resendCooldownTimer.cancel();
      }
    });
  }

  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  Future<void> verifyOTP(String enteredOTP) async {
    if (enteredOTP.length != 4) {
      errorMessage.value = 'Please enter a valid 4-digit OTP';
      return;
    }

    if (isOTPExpired.value) {
      errorMessage.value = 'OTP has expired. Please request a new one.';
      return;
    }

    final hasInternet = await ConnectivityService.hasInternetConnection();
    if (!hasInternet) {
      Get.snackbar("No Internet", ConnectivityService.getNoInternetMessage(), backgroundColor: Colors.red);
      return;
    }

    isVerifying.value = true;
    errorMessage.value = null;

    try {
      final email = authRepository.getResetEmail();
      print('[v1] [OTPVerification] verifyOTP: Retrieved email: $email');

      if (email == null) {
        errorMessage.value = 'Session expired. Please start over.';
        isVerifying.value = false;
        return;
      }

      final isValid = await authRepository.verifyOTP(email, enteredOTP);
      print('[v1] [OTPVerification] verifyOTP: result: $isValid');

      if (isValid) {
        Get.offNamed('/reset_password_screen');
      } else {
        errorMessage.value = 'Incorrect OTP. Please try again.';
      }
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isVerifying.value = false;
    }
  }

  Future<void> resendOTP() async {
    final hasInternet = await ConnectivityService.hasInternetConnection();
    if (!hasInternet) {
      Get.snackbar("No Internet", ConnectivityService.getNoInternetMessage(), backgroundColor: Colors.red);
      return;
    }

    try {
      isResending.value = true;
      final email = authRepository.getResetEmail();
      errorMessage.value = null;

      print('[v1] [OTPVerification] resendOTP: email: $email');

      if (email != null) {
        await authRepository.generateAndSendOTP(email);

        // Reset timers
        otpSecondsRemaining.value = 300;
        resendCooldownSeconds.value = 60;
        isOTPExpired.value = false;

        successMessage.value = null; // no UI message now

        _otpExpiryTimer.cancel();
        _resendCooldownTimer.cancel();

        _startOTPExpiryTimer();
        _startResendCooldownTimer();

        // Snackbar notification
        Get.snackbar(
          "Success",
          "OTP has been resent to your email",
          backgroundColor: Colors.green,
        );
      }
    } catch (e) {
      errorMessage.value = "Failed to resend OTP. Please try again.";
    } finally {
      isResending.value = false;
    }
  }

  @override
  void onClose() {
    _otpExpiryTimer.cancel();
    _resendCooldownTimer.cancel();
    super.onClose();
  }
}
