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
    // navigateUser();
  }

  // void navigateUser() async {
  //   await Future.delayed(const Duration(seconds: 2));
  //
  //   bool onboardingCompleted = storage.read('onboarding_completed') ?? false;
  //   if (!onboardingCompleted) {
  //     Get.offAllNamed("/on_boarding_screen");
  //   } else {
  //     Get.offAllNamed("/login_screen");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 38.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    height: 150,
                    width: 20,
                    decoration: BoxDecoration(color: Colors.deepOrange),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Container(
                      height: 60,
                      width: 2,
                      decoration: BoxDecoration(color: Colors.green),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 70),
              Container(
                height: 150,
                width: 150,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Image.asset("assets/images/app_logo.jpeg"),
              ),
              SizedBox(height: 70),
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 18.0),
                      child: Container(
                        height: 60,
                        width: 2,
                        decoration: BoxDecoration(color: Colors.deepOrange),
                      ),
                    ),
                    Container(
                      height: 150,
                      width: 20,
                      decoration: BoxDecoration(color: Colors.green),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
