import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../auth_screens/view_models/change_password_vm.dart';
import '../../../customs.dart';

class ChangePasswordScreen extends StatelessWidget {
  final ChangePasswordViewModel viewModel = Get.put(ChangePasswordViewModel());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Change Password", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Obx(() {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Update your security credentials. Your new password will be synced across your account.",
                  style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
                ),
                const SizedBox(height: 32),
                
                _buildPasswordField(
                  label: "Current Password",
                  controller: viewModel.currentPasswordController,
                  isObscure: viewModel.obscureCurrent.value,
                  onToggle: viewModel.toggleCurrent,
                ),
                const SizedBox(height: 20),
                
                _buildPasswordField(
                  label: "New Password",
                  controller: viewModel.newPasswordController,
                  isObscure: viewModel.obscureNew.value,
                  onToggle: viewModel.toggleNew,
                ),
                const SizedBox(height: 20),
                
                _buildPasswordField(
                  label: "Confirm New Password",
                  controller: viewModel.confirmPasswordController,
                  isObscure: viewModel.obscureConfirm.value,
                  onToggle: viewModel.toggleConfirm,
                ),
                
                const SizedBox(height: 48),
                
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: viewModel.isLoading.value ? null : () => viewModel.changePassword(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: viewModel.isLoading.value 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Update Password", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool isObscure,
    required VoidCallback onToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isObscure,
          decoration: InputDecoration(
            hintText: "Enter $label",
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[100]!)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[100]!)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primaryGreen)),
            suffixIcon: IconButton(
              icon: Icon(isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.grey, size: 20),
              onPressed: onToggle,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }
}
