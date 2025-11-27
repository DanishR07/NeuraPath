import 'package:flutter/material.dart';
import 'package:fyp/customs.dart';
import 'package:fyp/ui/intro_screens/intro_screen1.dart';
import 'package:fyp/ui/intro_screens/intro_screen2.dart';
import 'package:fyp/ui/intro_screens/intro_screen3.dart';
import 'package:fyp/ui/intro_screens/intro_screen4.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../intro_screens/intro_screen5.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController onBoardScreenController = PageController();
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: onBoardScreenController,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 4);
              });
            },
            children: const [
              IntroScreen1(),
              IntroScreen2(),
              IntroScreen3(),
              IntroScreen4(),
              IntroScreen5(),
            ],
          ),
          Container(
            alignment: const Alignment(0, 0.8),
            child: onLastPage
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // final storage = GetStorage();
                        // storage.write('onboarding_completed', true);
                        Get.offAllNamed('/login_screen');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 0,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 6,
                        shadowColor: Colors.black45,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.double_arrow,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            "Get started",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.double_arrow,
                            color: Colors.black,
                            size: 22,
                          ),
                        ],
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          onBoardScreenController.jumpToPage(4);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: AppColors.primaryGreen,
                                width: 2,
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.only(bottom: 4),
                          child: const Text(
                            'Skip',
                            style: TextStyle(
                              color: AppColors.primaryGreen,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                      // Dot indicators
                      SmoothPageIndicator(
                        controller: onBoardScreenController,
                        count: 5,
                        onDotClicked: (index) {
                          onBoardScreenController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                        effect: const ExpandingDotsEffect(
                          activeDotColor: Colors.blueGrey,
                          dotColor: AppColors.primaryGreen,
                          dotHeight: 10,
                          dotWidth: 10,
                          spacing: 6,
                        ),
                      ),
                      // next
                      GestureDetector(
                        onTap: () {
                          onBoardScreenController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: AppColors.primaryGreen,
                                width: 2, // thickness of the border
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.only(bottom: 4),
                          child: const Text(
                            'Next',
                            style: TextStyle(
                              color: AppColors.primaryGreen,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
