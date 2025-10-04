import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../colors.dart';

class SignupViewModel extends GetxController {
  final storage = GetStorage();
  var isLoading = false.obs;

  /// Normalize the role text to match the backend format
  String normalizeRole(String role) {
    // Convert to lowercase and replace spaces with underscores
    return role.trim().toLowerCase().replaceAll(' ', '_');
  }

  /// Signup function
  Future<void> signup({
    required String name,
    required String email,
    required String role,
    required String password,
    required String confirmPassword,
  }) async {
    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        role.isEmpty) {
      Get.snackbar(
        "Missing Fields",
        "Please fill all fields.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar(
        "Password Mismatch",
        "Passwords do not match.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      // Normalize role (e.g. "Job Seeker" → "job_seeker")
      final normalizedRole = normalizeRole(role);

      final response = await http.post(
        Uri.parse("http://192.168.100.181:8000/api/register"),
        headers: {"Accept": "application/json"},
        body: {
          "name": name,
          "email": email,
          "role": normalizedRole,
          "password": password,
          "password_confirmation": confirmPassword,
        },
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data['data'] != null && data['data']['token'] != null) {
          await storage.write('token', data['data']['token']);
          await storage.write('user', data['data']['user']);
        }

        Get.snackbar(
          "Success",
          "Account created successfully!",
          backgroundColor: AppColors.primaryGreen,
          colorText: Colors.white,
        );

        Get.offAllNamed("/home_screen");
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
            data["message"] ?? "Validation failed",
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          "Error",
          data["message"] ?? "Something went wrong",
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
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}
