import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
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
                cursorColor: Color(0xFF8BA989),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "Email",
                  hintStyle: TextStyle(fontSize: 13.5),
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: Color(0xFF8BA989),
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
                cursorColor: Color(0xFF8BA989),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "Password",
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
                      activeColor: Color(0xFF8BA989),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed("/forgot_password_screen");
                    },
                    child: Text(
                      "Forgot Password",
                      style: TextStyle(
                        color: Color(0xFF8BA989),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              ElevatedButton(
                onPressed: () => Get.toNamed("/home_screen"),
                style: ElevatedButton.styleFrom(
                  elevation: 3,
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: Color(0xFF8BA989),
                ),
                child: const Text(
                  "Log In",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
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
                        color: Color(0xFF8BA989),
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
