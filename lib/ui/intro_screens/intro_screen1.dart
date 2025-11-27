import 'package:flutter/material.dart';

import '../../customs.dart';

class IntroScreen1 extends StatelessWidget {
  const IntroScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Color(0xFFF5F5F5),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              SizedBox(height: 110,),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blueGrey,
                ),
                child: const Icon(
                  Icons.explore, // Compass-like icon
                  color: AppColors.primaryGreen,
                  size: 90,
                ),
              ),
              const SizedBox(height: 60),
              const Text(
                "Welcome to NeuraPath",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  "Your AI-powered guide to career success — from choosing the right path to landing your dream job.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.4,
                    color: Colors.blueGrey
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
