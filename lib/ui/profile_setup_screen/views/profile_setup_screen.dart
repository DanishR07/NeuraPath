import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fyp/customs.dart';
import '../../custom_widgets/profile_form.dart';
import '../view_models/profile_setup_vm.dart';

class ProfileSetupScreen extends StatefulWidget {
  final String userId;

  const ProfileSetupScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final ProfileSetupViewModel _viewModel = Get.find<ProfileSetupViewModel>();

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneNumberController;

  String? _selectedRole;
  final List<String> _roles = ['Student', 'Job Seeker', 'Professional'];

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _phoneNumberController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Complete Your Profile',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Help us know you better to provide personalized recommendations',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              SizedBox(height: 32),

              // Profile Picture Section
              Center(
                child: Column(
                  children: [
                    Obx(() {
                      final imageFile = _viewModel.selectedImageFile.value;
                      final imageUrl = _viewModel.profileImageUrl.value;

                      return Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[200],
                          border: Border.all(
                            color: AppColors.primaryGreen,
                            width: 2,
                          ),
                        ),
                        child: imageFile != null
                            ? ClipOval(
                          child: Image.file(
                            imageFile,
                            fit: BoxFit.cover,
                          ),
                        )
                            : imageUrl != null
                            ? ClipOval(
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primaryGreen,
                                ),
                              );
                            },
                          ),
                        )
                            : Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.grey[400],
                        ),
                      );
                    }),
                    SizedBox(height: 16),
                    Obx(() {
                      if (_viewModel.isUploadingImage.value) {
                        return Column(
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primaryGreen,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Uploading...',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.primaryGreen,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        );
                      }
                      return GestureDetector(
                        onTap: _viewModel.showImageSourceDialog,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.primaryGreen,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.camera_alt,
                                size: 16,
                                color: AppColors.primaryGreen,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Upload Photo',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryGreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              SizedBox(height: 36),

              // Form Fields
              buildFormField(
                label: 'First Name',
                hintText: 'Enter your first name',
                controller: _firstNameController,
                icon: Icons.person_outline,
              ),
              SizedBox(height: 16),

              buildFormField(
                label: 'Last Name',
                hintText: 'Enter your last name',
                controller: _lastNameController,
                icon: Icons.person_outline,
              ),
              SizedBox(height: 16),

              buildFormField(
                label: 'Phone Number',
                hintText: 'Enter your phone number',
                controller: _phoneNumberController,
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16),

              // Role Selection Dropdown
              Text(
                'Select Your Role',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey[300] ?? Colors.grey,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: DropdownButton<String>(
                  value: _selectedRole,
                  isExpanded: true,
                  underline: SizedBox.shrink(),
                  hint: Text(
                    'Choose a role',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                  items: _roles.map((role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(
                        role,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value;
                    });
                  },
                ),
              ),
              SizedBox(height: 40),

              // Complete Profile Button
              Obx(() {
                return GestureDetector(
                  onTap: _viewModel.isLoading.value
                      ? null
                      : () => _viewModel.handleCompleteProfile(
                    userId: widget.userId,
                    firstName: _firstNameController.text,
                    lastName: _lastNameController.text,
                    phoneNumber: _phoneNumberController.text,
                    role: _selectedRole ?? '',
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: _viewModel.isLoading.value
                          ? AppColors.primaryGreen.withOpacity(0.6)
                          : AppColors.primaryGreen,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: _viewModel.isLoading.value
                          ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                          : Text(
                        'Complete Profile',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              }),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
