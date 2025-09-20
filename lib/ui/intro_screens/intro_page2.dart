import 'package:flutter/material.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

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
                Icons.school, // Compass-like icon
                color: Color(0xFF8BA989),
                size: 90,
              ),
            ),

            const SizedBox(height: 60),

            // App Title
            const Text(
              "Discover Your Career Path",
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
                "Get personalized career recommendations and internship guidance based on your skills, interests, and education.",
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
