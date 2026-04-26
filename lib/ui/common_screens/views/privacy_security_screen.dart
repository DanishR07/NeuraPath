import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'privacy_policy_screen.dart';
import 'terms_of_service_screen.dart';
import 'change_password_screen.dart';

class PrivacySecurityScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          "Privacy & Security",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildActionTile(
            title: "Change Password",
            icon: Icons.lock_reset,
            onTap: () async {
              final result = await Get.to(() => ChangePasswordScreen());
              if (result == true) {
                Get.snackbar(
                  "Success", 
                  "Your password has been updated across your account.",
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 3),
                );
              }
            },
          ),
          const SizedBox(height: 20),
          const Text(
            "Data Privacy",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF8BA989),
            ),
          ),
          const SizedBox(height: 10),
          _buildActionTile(
            title: "Privacy Policy",
            icon: Icons.description_outlined,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()),
            ),
          ),
          _buildActionTile(
            title: "Terms of Service",
            icon: Icons.gavel_outlined,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TermsOfServiceScreen()),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildActionTile({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF8BA989).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF8BA989)),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black87),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
