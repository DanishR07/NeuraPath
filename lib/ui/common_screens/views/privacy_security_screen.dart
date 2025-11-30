import 'package:flutter/material.dart';

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
            onTap: () {
              // Navigate to change password screen or show dialog
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Change Password feature coming soon")),
              );
            },
          ),
          _buildActionTile(
            title: "Two-Factor Authentication",
            icon: Icons.security,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("2FA feature coming soon")),
              );
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
            onTap: () {},
          ),
          _buildActionTile(
            title: "Terms of Service",
            icon: Icons.gavel_outlined,
            onTap: () {},
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
