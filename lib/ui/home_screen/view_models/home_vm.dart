import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeViewModel extends GetxController {
  final storage = GetStorage();
  var isLoading = false.obs;

  /// Logout Function
  Future<void> logout() async {
    final token = storage.read('token');

    if (token == null) {
      storage.remove('token');
      storage.remove('user');
      Get.offAllNamed('/login_screen');
      return;
    }

    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse('http://192.168.100.181:8000/api/logout'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        // Clear local storage
        await storage.remove('token');
        await storage.remove('user');

        // Navigate to login screen
        Get.offAllNamed('/login_screen');

        Get.snackbar(
          'Success',
          data['message'] ?? 'Logged out successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          data['message'] ?? 'Failed to logout',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to connect to server: $e',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
