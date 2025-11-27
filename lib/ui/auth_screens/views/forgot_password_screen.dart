import 'package:flutter/material.dart';
import 'package:fyp/ui/custom_widgets/profile_form.dart';
import 'package:get/get.dart';
import '../../../customs.dart';
import '../view_models/forgot_password_vm.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  late ForgotPasswordViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = Get.put(ForgotPasswordViewModel());
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
                  'Forgot Password',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    textAlign: TextAlign.center,
                    'Enter your email address to receive a reset OTP and regain access to your account.',
                    style: TextStyle(fontSize: 13.5),
                  ),
                ),
                SizedBox(height: 60),
                buildFormField(label: 'Email',
                  hintText: 'Enter your email',
                  controller: _emailController,
                  icon: Icons.email_outlined,),
                Obx(() {
                  if (_viewModel.errorMessage.value != null) {
                    return Column(
                      children: [
                        SizedBox(height: 10),
                        Text(
                          _viewModel.errorMessage.value!,
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ],
                    );
                  }
                  return SizedBox.shrink();
                }),
                SizedBox(height: 70),
                Obx(() {
                  return ElevatedButton(
                    onPressed: _viewModel.isLoading.value
                        ? null
                        : () => _viewModel.continueWithEmail(_emailController.text),
                    style: ElevatedButton.styleFrom(
                      elevation: 3,
                      minimumSize: const Size(double.infinity, 54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: AppColors.primaryGreen,
                    ),
                    child: _viewModel.isLoading.value
                        ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : const Text(
                      "Continue",
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
    _emailController.dispose();
    super.dispose();
  }
}
