import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LauncherScreen extends StatefulWidget {
  const LauncherScreen({super.key});

  @override
  State<LauncherScreen> createState() => _LauncherScreenState();
}

class _LauncherScreenState extends State<LauncherScreen> {
  final storage = GetStorage();

  @override
  void initState() {
    super.initState();
    navigateUser();
  }

  void navigateUser() async {
    await Future.delayed(const Duration(seconds: 2));

    bool onboardingCompleted = storage.read('onboarding_completed') ?? false;
    String? token = storage.read('token');
    final dynamic userDyn = storage.read('user');
    String? category;

    if (userDyn is Map) {
      final user = Map<String, dynamic>.from(userDyn as Map);
      final c = user['category'];
      if (c != null && c.toString().trim().isNotEmpty) {
        category = c.toString().trim();
      }
    }

    if (!onboardingCompleted) {
      Get.offAllNamed("/on_boarding_screen");
    } else if (token != null && token.isNotEmpty) {
      if (category == null) {
        Get.offAllNamed("/category_screen");
      } else {
        Get.offAllNamed("/home_screen");
      }
    } else {
      Get.offAllNamed("/login_screen");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          height: 150,
          width: 150,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Image.asset("assets/images/app_logo.png"),
        ),
      ),
    );
  }
}
