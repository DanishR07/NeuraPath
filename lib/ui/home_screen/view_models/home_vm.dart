import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';

class HomeViewModel extends GetxController {
  AuthRepository authRepository = Get.find();
  var isLoading=false.obs;
  Future<void> confirmLogout() async {
    try{
      Get.back();
      await authRepository.logout();
      Get.offAllNamed('/login_screen');
      Get.snackbar('Logout', "Logged out successfully",backgroundColor: Colors.green);
    } catch(e){
      Get.snackbar('Error', "Failed to logout: ${e.toString()}",backgroundColor: Colors.red);
    }
  }
}
