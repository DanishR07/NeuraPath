import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp/ui/auth_screens/view_models/login_vm.dart';
import 'package:get/get.dart';

import '../../../customs.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool rememberMe = false;
  final LoginViewModel loginViewModel = Get.put(LoginViewModel());
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    final creds = loginViewModel.getSavedCredentials();
    if (creds["email"]!.isNotEmpty && creds["password"]!.isNotEmpty) {
      _emailController.text = creds["email"]!;
      _passwordController.text = creds["password"]!;
      rememberMe = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0,right: 15,bottom: 20),
          child: Column(
            children: [
              SizedBox(height: 55),
              Container(
                height: 40,
                width: 40,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Image.asset("assets/images/app_logo.png"),
              ),
              SizedBox(height: 5),
              Text(
                "CareerCompass",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 17),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: GestureDetector(
                  onTap: null,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.white,
                        child: Image.asset("assets/icons/google.png"),
                      ),
                      Expanded(
                        child: Center(child: Text("Continue with Google")),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 17),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: GestureDetector(
                  onTap: null,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.white,
                        child: Image.asset("assets/icons/facebook.png"),
                      ),
                      Expanded(
                        child: Center(child: Text("Continue with Facebook")),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 17),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: GestureDetector(
                  onTap: null,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.white,
                        child: Image.asset("assets/icons/linkedin.png"),
                      ),
                      Expanded(
                        child: Center(child: Text("Continue with Linkedin")),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Email",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 5),
              TextField(
                controller: _emailController,
                cursorColor: AppColors.primaryGreen,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "Enter email",
                  hintStyle: TextStyle(fontSize: 13.5),
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Password",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 5),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                cursorColor: AppColors.primaryGreen,
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
                    color: AppColors.primaryGreen,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.primaryGreen,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: CheckboxListTile(
                      value: rememberMe,
                      onChanged: (newValue) {
                        setState(() {
                          rememberMe = newValue!;
                        });
                      },
                      title: Transform.translate(
                        offset: const Offset(-18, 0),
                        child: const Text("Remember Me"),
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      checkboxShape: CircleBorder(),
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      activeColor: AppColors.primaryGreen,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed("/forgot_password_screen");
                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: AppColors.primaryGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Obx(() {
                return loginViewModel.isLoading.value
                    ? const CircularProgressIndicator(color: AppColors.primaryGreen)
                    : ElevatedButton(
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                    await loginViewModel.login(
                      email: _emailController.text.trim(),
                      password: _passwordController.text,
                      rememberMe: rememberMe,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 3,
                    minimumSize: const Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: AppColors.primaryGreen,
                  ),
                  child: const Text(
                    "Log In",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                );
              }),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?"),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed("/signup_screen");
                    },
                    child: Text(
                      "  Sign Up",
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
