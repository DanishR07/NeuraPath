import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp/ui/auth_screens/view_models/login_vm.dart';
import 'package:get/get.dart';
import '../../../customs.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../custom_widgets/profile_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool rememberMe = false;
  late LoginViewModel loginViewModel;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    loginViewModel = Get.find();
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
          padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 20),
          child: Column(
            children: [
              SizedBox(height: 55),
              Container(
                height: 90,
                width: 90,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(Icons.lock_person_sharp,size: 40,color: Colors.white,),
              ),
              SizedBox(height: 10),
              Text(
                "NeuraPath",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 50,),
              Align(alignment: Alignment.centerLeft,child: Text("Welcome Back!",style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,color: Colors.black.withOpacity(.8)),)),
              SizedBox(height: 30),
              buildFormField(
                label: 'Email',
                hintText: 'Enter your email',
                controller: _emailController,
                icon: Icons.email_outlined,
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
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey[300] ?? Colors.grey,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  cursorColor: AppColors.primaryGreen,
                  decoration: InputDecoration(
                    hintText: "Enter password",
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey[400]),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 0),
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      size: 20,
                      color: AppColors.primaryGreen.withOpacity(0.6),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 20,
                        color: AppColors.primaryGreen.withOpacity(0.6),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
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
                    ? const CircularProgressIndicator(
                        color: AppColors.primaryGreen,
                      )
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
                          "Login",
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
                      Get.offNamed("/signup_screen");
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

class LoginScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthRepository());
    Get.put(LoginViewModel());
  }
}
