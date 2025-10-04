import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp/ui/custom_widgets/otp_pin_box_widget.dart';
import 'package:get/get.dart';

import '../../../colors.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {

  int _secondsRemaining = 30;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0,right: 15,bottom: 30),
          child: Column(
            children: [
              SizedBox(height: 5,),
              Text(
                'Enter OTP',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  textAlign: TextAlign.center,
                  'A one-time-password (OTP) has been sent to your registered email.',
                  style: TextStyle(fontSize: 13.5),
                ),
              ),
              SizedBox(height: 40),
              Form(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OtpPinBoxWidget(),
                      OtpPinBoxWidget(),
                      OtpPinBoxWidget(),
                      OtpPinBoxWidget(),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Text("Resend code in 00.$_secondsRemaining"),
              SizedBox(height: 40,),
              ElevatedButton(
                onPressed: () => Get.offNamed("/reset_password_screen"),
                style: ElevatedButton.styleFrom(
                  elevation: 3,
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: AppColors.primaryGreen,
                ),
                child: const Text(
                  "Verify",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              SizedBox(height: 230,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Didn't receive the code?"),
                  GestureDetector(
                    onTap: null,
                    child: Text(
                      "  Resend",
                      style: TextStyle(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
