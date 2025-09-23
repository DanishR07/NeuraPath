import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0xFFF5F5F5)),
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 20),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 5),
                Text(
                  'Reset Password',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    textAlign: TextAlign.center,
                    'Enter your email address to receive a reset OTP and regain access to your account.',
                    style: TextStyle(fontSize: 13.5),
                  ),
                ),
                SizedBox(height: 60),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "New Password",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 5),
                TextField(
                  controller: _passwordController,
                  cursorColor: Color(0xFF8BA989),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    hintText: "Enter password",
                    hintStyle: TextStyle(fontSize: 13.5),
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: Color(0xFF8BA989),
                    ),
                    suffixIcon: Icon(
                      Icons.remove_red_eye_outlined,
                      color: Color(0xFF8BA989),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Confirm New Password",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 5),
                TextField(
                  controller: _confirmPasswordController,
                  cursorColor: Color(0xFF8BA989),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    hintText: "Enter password again",
                    hintStyle: TextStyle(fontSize: 13.5),
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: Color(0xFF8BA989),
                    ),
                    suffixIcon: Icon(
                      Icons.remove_red_eye_outlined,
                      color: Color(0xFF8BA989),
                    ),
                  ),
                ),
                SizedBox(height: 70),
                ElevatedButton(
                  onPressed: () => Get.offNamed("/password_reset_success_message_screen"),
                  style: ElevatedButton.styleFrom(
                    elevation: 3,
                    minimumSize: const Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Color(0xFF8BA989),
                  ),
                  child: const Text(
                    "Save",
                    style: TextStyle(fontSize: 18, color: Colors.white),
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
