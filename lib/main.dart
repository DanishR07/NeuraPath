import 'package:flutter/material.dart';
import 'package:fyp/ui/auth_screens/forgot_password_screen.dart';
import 'package:fyp/ui/auth_screens/login_screen.dart';
import 'package:fyp/ui/auth_screens/otp_verification_screen.dart';
import 'package:fyp/ui/auth_screens/signup_screen.dart';
import 'package:fyp/ui/home_screen/home_screen.dart';
import 'package:fyp/ui/boarding_screen/onboarding_screen.dart';
import 'package:get/get.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'CareerCompass App',
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(name: "/home_screen", page: () => HomeScreen(),),
        GetPage(name: "/on_boarding_screen", page: () => OnboardingScreen(),),
        GetPage(name: "/login_screen", page: () => LoginScreen(),),
        GetPage(name: "/signup_screen", page: () => SignupScreen(),),
        GetPage(name: "/forgot_password_screen", page: () => ForgotPasswordScreen(),),
        GetPage(name: "/otp_verification_screen", page: () => OtpVerificationScreen(),),
      ],
      initialRoute: "/on_boarding_screen",
    );
  }
}


