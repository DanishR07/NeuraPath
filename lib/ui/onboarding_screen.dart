import 'package:flutter/material.dart';
import 'package:fyp/ui/intro_screens/intro_page1.dart';
import 'package:fyp/ui/intro_screens/intro_page2.dart';
import 'package:fyp/ui/intro_screens/intro_page3.dart';
import 'package:fyp/ui/intro_screens/intro_page4.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:lottie/lottie.dart';

import 'home_page.dart';
import 'intro_screens/intro_page5.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // Controller to keep track of pages
  PageController onBoardScreenController = PageController();

  // to check if we are on the last page
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
              IntroPage1(),
              IntroPage2(),
              IntroPage3(),
              IntroPage4(),
              IntroPage5(),
            ],
          ),
          Container(
            alignment: const Alignment(0, 0.8),
            child: onLastPage
                ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return HomePage();
                            },
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF8BA989),
                        // yellow background
                        padding: const EdgeInsets.symmetric(
                          horizontal: 0,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // pill shape
                        ),
                        elevation: 6,
                        shadowColor: Colors.black45,
                      ),
                      child: Row(

                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // Left black circle with arrows
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

                          // Right arrow
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
                      // skip
                      GestureDetector(
                        onTap: () {
                          onBoardScreenController.jumpToPage(2);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xFF8BA989),
                                width: 2,
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.only(bottom: 4),
                          child: const Text(
                            'skip',
                            style: TextStyle(
                              color: Color(0xFF8BA989),
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
                          activeDotColor: Colors.white,
                          dotColor: Color(0xFF8BA989),
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
                                color: Color(0xFF8BA989),
                                width: 2, // thickness of the border
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.only(bottom: 4),
                          child: const Text(
                            'next',
                            style: TextStyle(
                              color: Color(0xFF8BA989),
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
