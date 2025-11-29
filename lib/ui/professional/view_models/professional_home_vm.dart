import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../model/user_model.dart';
import '../../../services/connectivity_service.dart';

class ProfessionalHomeViewModel extends GetxController {
  AuthRepository authRepository = Get.find();
  var isLoading = false.obs;

  Future<UserModel?> getCurrentUser() async {
    return await authRepository.getCurrentUser();
  }

  Future<void> confirmLogout() async {
    final hasInternet = await ConnectivityService.hasInternetConnection();
    if (!hasInternet) {
      Get.snackbar("No Internet", ConnectivityService.getNoInternetMessage(), backgroundColor: Colors.red);
      return;
    }

    try {
      Get.back();
      await authRepository.logout();
      Get.offAllNamed('/login_screen');
      Get.snackbar('Logout', "Logged out successfully", backgroundColor: Colors.green);
    } catch (e) {
      Get.snackbar('Error', "Failed to logout: ${e.toString()}", backgroundColor: Colors.red);
    }
  }
}
