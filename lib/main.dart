import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fyp/ui/auth_screens/views/forgot_password_screen.dart';
import 'package:fyp/ui/auth_screens/views/login_screen.dart';
import 'package:fyp/ui/auth_screens/views/otp_verification_screen.dart';
import 'package:fyp/ui/auth_screens/views/reset_password_screen.dart';
import 'package:fyp/ui/auth_screens/views/signup_screen.dart';
import 'package:fyp/ui/home_screen/views/home_screen.dart';
import 'package:fyp/ui/boarding_screen/onboarding_screen.dart';
import 'package:fyp/ui/launcher_screen/launcher_screen.dart';
import 'package:fyp/ui/profile_setup_screen/view_models/profile_setup_vm.dart';
import 'package:fyp/ui/profile_setup_screen/views/profile_setup_screen.dart';
import 'package:fyp/ui/success_message_screens/password_reset_success_message_screen.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'firebase_options.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'NeuraPath App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: Color(0xFFF5F5F5),
          appBarTheme: AppBarTheme(
            backgroundColor: Color(0xFFF5F5F5),
          )
      ),
      getPages: [
        GetPage(name: "/launcher_screen", page: () => LauncherScreen(),),
        GetPage(name: "/home_screen", page: () => HomeScreen(),binding: HomeScreenBinding()),
        GetPage(name: "/on_boarding_screen", page: () => OnboardingScreen(),),
        GetPage(name: "/login_screen", page: () => LoginScreen(),binding: LoginScreenBinding()),
        GetPage(name: "/signup_screen", page: () => SignupScreen(),binding: SignUpScreenBinding()),
        GetPage(name: "/profile_setup_screen", page: () {
          final userId = Get.arguments as String?;
          if (userId == null) {
            return Scaffold(body: Center(child: Text('Error: No user ID provided')));
          }
          return ProfileSetupScreen(userId: userId);
        }, binding: ProfileSetupScreenBinding()),
        GetPage(name: "/forgot_password_screen", page: () => ForgotPasswordScreen(),),
        GetPage(name: "/otp_verification_screen", page: () => OtpVerificationScreen(),),
        GetPage(name: "/reset_password_screen", page: () => ResetPasswordScreen(),),
        GetPage(name: "/password_reset_success_message_screen", page: () => PasswordResetSuccessMessageScreen(),),
      ],
      initialRoute: "/launcher_screen",
    );
  }
}
