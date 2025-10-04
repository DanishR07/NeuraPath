import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../colors.dart';

class LoginViewModel extends GetxController {
  final storage = GetStorage();
  var isLoading = false.obs;

  /// Login Function
  Future<void> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        "Missing Fields",
        "Please fill all fields.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse("http://192.168.100.181:8000/api/login"),
        headers: {"Accept": "application/json"},
        body: {
          "email": email,
          "password": password,
        },
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        // Save token and user
        if (data['data'] != null && data['data']['token'] != null) {
          await storage.write('token', data['data']['token']);
          await storage.write('user', data['data']['user']);
        }

        // Handle Remember Me
        if (rememberMe) {
          await storage.write('savedEmail', email);
          await storage.write('savedPassword', password);
        } else {
          await storage.remove('savedEmail');
          await storage.remove('savedPassword');
        }

        Get.snackbar(
          "Success",
          "Logged in successfully!",
          backgroundColor: AppColors.primaryGreen,
          colorText: Colors.white,
        );

        Get.offAllNamed("/home_screen");
      } else if (response.statusCode == 401) {
        Get.snackbar(
          "Invalid Credentials",
          data["message"] ?? "Email or password is incorrect.",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      } else if (response.statusCode == 422) {
        if (data["errors"] != null) {
          data["errors"].forEach((key, value) {
            Get.snackbar(
              "Invalid Input",
              value[0],
              backgroundColor: Colors.redAccent,
              colorText: Colors.white,
            );
          });
        } else {
          Get.snackbar(
            "Error",
            data["message"] ?? "Validation failed.",
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          "Error",
          data["message"] ?? "Something went wrong.",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to connect to server: $e",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Load saved email and password (for Remember Me)
  Map<String, String> getSavedCredentials() {
    final savedEmail = storage.read('savedEmail') ?? '';
    final savedPassword = storage.read('savedPassword') ?? '';
    return {"email": savedEmail, "password": savedPassword};
  }
}
