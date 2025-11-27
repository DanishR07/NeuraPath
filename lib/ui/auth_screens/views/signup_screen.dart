import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../customs.dart';
import '../../../data/repositories/auth_repository.dart';
import '../view_models/signup_vm.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  late SignUpViewModel signUpViewModel;

  @override
  void initState() {
    super.initState();
    signUpViewModel = Get.find();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 30),
          child: Column(
            children: [
              SizedBox(height: 55),
              Container(
                height: 65,
                width: 65,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Image.asset("assets/images/app_logo.jpeg"),
              ),
              SizedBox(height: 5),
              Text(
                "NeuraPath",
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
                  hintText: "Enter password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
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
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                cursorColor: AppColors.primaryGreen,
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
                    color: AppColors.primaryGreen,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.primaryGreen,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 25),
              Obx(() {
                return signUpViewModel.isLoading.value
                    ? const CircularProgressIndicator(
                        color: AppColors.primaryGreen,
                      )
                    : ElevatedButton(
                        onPressed: () async {
                          FocusScope.of(context).unfocus(); // hide keyboard
                          await signUpViewModel.signup(
                            _emailController.text.trim(),
                            _passwordController.text,
                            _confirmPasswordController.text,
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
                          "Create Account",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      );
              }),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?"),
                  GestureDetector(
                    onTap: () {
                      Get.offNamed("/login_screen");
                    },
                    child: Text(
                      "  Login",
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

class SignUpScreenBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(AuthRepository());
    Get.put(SignUpViewModel());
  }
}
