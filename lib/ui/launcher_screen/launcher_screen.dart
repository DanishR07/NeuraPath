import 'package:flutter/material.dart';
import 'package:fyp/customs.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LauncherScreen extends StatefulWidget {
  const LauncherScreen({super.key});

  @override
  State<LauncherScreen> createState() => _LauncherScreenState();
}

class _LauncherScreenState extends State<LauncherScreen> with SingleTickerProviderStateMixin {
  final storage = GetStorage();

  late AnimationController _controller;
  late Animation<Offset> _topLinesSlide;
  late Animation<Offset> _bottomLinesSlide;
  late Animation<double> _logoScale;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _topLinesSlide = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
    ));

    _bottomLinesSlide = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
    ));

    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1.0, curve: Curves.elasticOut),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 0.7, curve: Curves.easeIn),
      ),
    );

    _controller.forward();
    
    navigateUser();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void navigateUser() async {
    await Future.delayed(const Duration(milliseconds: 2800));

    bool onboardingCompleted = storage.read('onboarding_completed') ?? false;
    if (!onboardingCompleted) {
      Get.offAllNamed("/on_boarding_screen");
    } else {
      Get.offAllNamed("/login_screen");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 38.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SlideTransition(
                  position: _topLinesSlide,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Row(
                      children: [
                        Container(
                          height: 150,
                          width: 20,
                          decoration: BoxDecoration(
                            color: Colors.deepOrange,
                          ),
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
                  ),
                ),
                SizedBox(height: 70),
                Flexible(
                  child: ScaleTransition(
                    scale: _logoScale,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryGreen.withOpacity(0.2),
                              blurRadius: 30,
                              spreadRadius: 10,
                            )
                          ],
                        ),
                        child: Image.asset("assets/images/app_logo.jpg"),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 70),
                Align(
                  alignment: Alignment.centerRight,
                  child: SlideTransition(
                    position: _bottomLinesSlide,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
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
                            decoration: BoxDecoration(
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
