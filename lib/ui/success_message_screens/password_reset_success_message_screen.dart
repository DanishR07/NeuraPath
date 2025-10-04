import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../colors.dart';

class PasswordResetSuccessMessageScreen extends StatefulWidget {
  const PasswordResetSuccessMessageScreen({super.key});

  @override
  State<PasswordResetSuccessMessageScreen> createState() => _PasswordResetSuccessMessageScreenState();
}

class _PasswordResetSuccessMessageScreenState extends State<PasswordResetSuccessMessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          children: [
            SizedBox(height: 25),
            Container(
              height: 70,
              width: 70,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(Icons.check,size:35,color: Colors.white,),
            ),
            SizedBox(height: 40),
            Text(
              'Password Changed',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                textAlign: TextAlign.center,
                'Your password has been changed successfully',
                style: TextStyle(fontSize: 13.5),
              ),
            ),
            SizedBox(height: 100,),
            ElevatedButton(
              onPressed: () => Get.offAllNamed("/login_screen"),
              style: ElevatedButton.styleFrom(
                elevation: 3,
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: AppColors.primaryGreen,
              ),
              child: const Text(
                "Back to login",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
