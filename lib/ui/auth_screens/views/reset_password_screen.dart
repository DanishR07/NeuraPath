import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../customs.dart';
import '../view_models/reset_password_vm.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  late ResetPasswordViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = Get.put(ResetPasswordViewModel());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                    'Create a new password. Make sure it is strong and secure.',
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
                Obx(() {
                  return TextField(
                    controller: _passwordController,
                    obscureText: !_viewModel.isPasswordVisible.value,
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
                      suffixIcon: GestureDetector(
                        onTap: _viewModel.togglePasswordVisibility,
                        child: Icon(
                          _viewModel.isPasswordVisible.value
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ),
                  );
                }),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Confirm New Password",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 5),
                Obx(() {
                  return TextField(
                    controller: _confirmPasswordController,
                    obscureText: !_viewModel.isConfirmPasswordVisible.value,
                    cursorColor: AppColors.primaryGreen,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      hintText: "Confirm password",
                      hintStyle: TextStyle(fontSize: 13.5),
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: AppColors.primaryGreen,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: _viewModel.toggleConfirmPasswordVisibility,
                        child: Icon(
                          _viewModel.isConfirmPasswordVisible.value
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ),
                  );
                }),
                SizedBox(height: 70),
                Obx(() {
                  return ElevatedButton(
                    onPressed: _viewModel.isUpdating.value
                        ? null
                        : () => _viewModel.resetPassword(
                      _passwordController.text,
                      _confirmPasswordController.text,
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 3,
                      minimumSize: Size(double.infinity, 54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: AppColors.primaryGreen,
                    ),
                    child: _viewModel.isUpdating.value
                        ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : const Text(
                      "Save",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
