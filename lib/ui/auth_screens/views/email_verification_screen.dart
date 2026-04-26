import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../customs.dart';
import '../../../data/repositories/auth_repository.dart';
import '../view_models/email_verification_vm.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the view model
    final vm = Get.find<EmailVerificationViewModel>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0,),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.mark_email_unread_outlined,
                    size: 50,
                    color: AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "Verify your email",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  "We've sent a verification link to your email address. Please click the link to verify your account.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 40),
                
                // Proceed Button
                Obx(() => ElevatedButton(
                      onPressed: vm.isEmailVerified.value
                          ? () => vm.proceedToProfile()
                          : null, // Disabled when not verified
                      style: ElevatedButton.styleFrom(
                        elevation: 3,
                        minimumSize: const Size(double.infinity, 54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        backgroundColor: vm.isEmailVerified.value
                            ? AppColors.primaryGreen
                            : Colors.grey[400],
                      ),
                      child: const Text(
                        "Proceed to Profile Setup",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    )),
                    
                const SizedBox(height: 30),
                
                // Resend Section
                Obx(() {
                  if (vm.isEmailVerified.value) {
                    return const SizedBox.shrink(); // Hide if already verified
                  }
                  return Column(
                    children: [
                      const Text(
                        "Didn't receive the email?",
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 10),
                      if (!vm.canResendEmail.value)
                        Text(
                          "Resend in ${vm.secondsRemaining.value}s",
                          style: const TextStyle(
                            color: AppColors.primaryGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      else
                        TextButton(
                          onPressed: () => vm.resendVerificationEmail(),
                          child: const Text(
                            "Resend Link",
                            style: TextStyle(
                              color: AppColors.primaryGreen,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                    ],
                  );
                }),
                
                const SizedBox(height: 130),
                
                // Manual Check Button (Fallback)

                Obx(() {
                  if (vm.isEmailVerified.value) {
                     return const SizedBox.shrink();
                  }
                  return Column(
                    children: [
                      Text("Tip! Check your spam folder if email not found",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                      TextButton(
                        onPressed: () => vm.checkManualVerificationStatus(),
                        child: const Text(
                          "I have verified",
                          style: TextStyle(
                            color: Colors.grey,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmailVerificationScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthRepository());
    Get.put(EmailVerificationViewModel());
  }
}
