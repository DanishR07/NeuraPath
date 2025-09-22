import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  String? _selectedRole;
  final List<String> _roles = ["Student", "Job Seeker", "Professional"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 30),
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
                  "Full Name",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 5),
              TextField(
                controller: _fullNameController,
                cursorColor: Color(0xFF8BA989),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "Enter full name",
                  hintStyle: TextStyle(fontSize: 13.5),
                  prefixIcon: Icon(
                    Icons.person,
                    color: Color(0xFF8BA989),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Email",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 5),
              TextField(
                controller: _fullNameController,
                cursorColor: Color(0xFF8BA989),
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
                    color: Color(0xFF8BA989),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Select Role",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 5),
              DropdownButtonFormField<String>(
                dropdownColor: Color(0xFF8BA989),
                value: _selectedRole,
                items: _roles
                    .map(
                      (role) => DropdownMenuItem(
                        value: role,
                        child: Text(
                          role,
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Select a role",
                  prefixIcon: Icon(

                    Icons.business_center,
                    color: Color(0xFF8BA989),
                  ),
                  hintStyle: TextStyle(fontSize: 13.5),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
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
                  hintText: " Enter password",
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
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Confirm Password",
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
                  hintText: " Enter same password again",
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
              SizedBox(height: 25),
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
                  "Create Account!",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?"),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed("/login_screen");
                    },
                    child: Text(
                      "  Login In",
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
