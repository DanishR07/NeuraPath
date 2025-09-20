import 'package:flutter/material.dart';

class IntroPage3 extends StatelessWidget {
  const IntroPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: Column(
          children: [
            SizedBox(height: 110,),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.15),
              ),
              child: const Icon(
                Icons.description, // Compass-like icon
                color: Color(0xFF8BA989),
                size: 90,
              ),
            ),

            const SizedBox(height: 60),

            // App Title
            const Text(
              "Optimize Your Resume",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 15),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "AI-powered resume optimization ensures ATS compliance, keyword matching, and formatting that gets you noticed.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
