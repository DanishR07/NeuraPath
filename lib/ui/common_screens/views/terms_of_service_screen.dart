import 'package:flutter/material.dart';

class TermsOfServiceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Terms of Service", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
              "Effective Date: April 2026",
              style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _buildSection(
              "1. Acceptance of Terms",
              "By accessing or using this application, you agree to be bound by these Terms of Service. If you do not agree, please do not use the application.",
            ),
            _buildSection(
              "2. User Accounts",
              "You are responsible for maintaining the confidentiality of your account credentials. You agree to provide accurate and complete information during profile setup and updates.",
            ),
            _buildSection(
              "3. Proper Use",
              "This platform is designed for career development and intelligence purposes. Users are prohibited from using the platform for any illegal activities or attempting to circumvent AI safeguards.",
            ),
            _buildSection(
              "4. Intellectual Property",
              "All content, logos, and software used in this application are the property of the developer and are protected by intellectual property laws.",
            ),
            _buildSection(
              "5. Limitation of Liability",
              "While we strive to provide high-accuracy AI insights, recommendations are for guidance purposes only. We are not liable for any career or academic decisions made based on platform insights.",
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
