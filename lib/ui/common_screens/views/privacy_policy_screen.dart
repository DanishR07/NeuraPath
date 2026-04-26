import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Privacy Policy", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Last Updated: April 2026",
              style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _buildSection(
              "1. Information Collection",
              "We collect information that you provide directly to us when you create an account, update your profile (Student, Job Seeker, or Professional), or use our AI-driven career services. This includes your name, contact details, educational background, skills, and professional experience.",
            ),
            _buildSection(
              "2. How We Use Information",
              "We use the collected data to provide personalized career recommendations, identify skill gaps, and match you with growth opportunities. Your data is processed by our AI services (Groq/Llama) to generate insights tailored to your specific profile.",
            ),
            _buildSection(
              "3. Data Security",
              "We implement industry-standard security measures to protect your personal information. However, please note that no method of transmission over the internet is 100% secure.",
            ),
            _buildSection(
              "4. Third-Party Services",
              "Our application integrates with AI providers (like Groq) to process career data. These providers receive information only as necessary to perform their services and are obligated to protect your privacy.",
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(fontSize: 14, color: Colors.grey[800], height: 1.6),
          ),
        ],
      ),
    );
  }
}
