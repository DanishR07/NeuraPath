import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fyp/customs.dart';
import '../../custom_widgets/profile_form.dart';
import '../view_models/edit_profile_view_model.dart';

class EditProfileScreen extends StatefulWidget {
  final String userId;

  const EditProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final EditProfileViewModel _viewModel = Get.put(EditProfileViewModel());
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneNumberController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    await _viewModel.loadUserProfile(widget.userId);
    _firstNameController.text = _viewModel.firstName.value;
    _lastNameController.text = _viewModel.lastName.value;
    _phoneNumberController.text = _viewModel.phoneNumber.value;
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
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Edit Profile", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture Section
              Center(
                child: Column(
                  children: [
                    Obx(() {
                      final imageFile = _viewModel.selectedImageFile.value;
                      final imageUrl = _viewModel.profileImageUrl.value;
                      final hasExistingImage = imageUrl != null && imageUrl.isNotEmpty;

                      return GestureDetector(
                        onTap: _viewModel.showImageSourceDialog,
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[200],
                                border: Border.all(color: AppColors.primaryGreen, width: 2),
                              ),
                              child: imageFile != null
                                  ? ClipOval(child: Image.file(imageFile, fit: BoxFit.cover))
                                  : imageUrl != null
                                      ? ClipOval(
                                          child: Image.network(
                                            imageUrl,
                                            fit: BoxFit.cover,
                                            loadingBuilder: (context, child, loadingProgress) {
                                              if (loadingProgress == null) return child;
                                              return Center(child: CircularProgressIndicator(color: AppColors.primaryGreen));
                                            },
                                          ),
                                        )
                                      : Icon(Icons.person, size: 60, color: Colors.grey[400]),
                            ),
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primaryGreen,
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 2))],
                              ),
                              child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                    Obx(() {
                      if (_viewModel.isUploadingImage.value) {
                        return const Text('Uploading...', style: TextStyle(color: AppColors.primaryGreen, fontSize: 12));
                      }
                      return const SizedBox.shrink();
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 36),

              // Form Fields
              buildFormField(
                label: 'First Name',
                hintText: 'Enter your first name',
                controller: _firstNameController,
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 16),

              buildFormField(
                label: 'Last Name',
                hintText: 'Enter your last name',
                controller: _lastNameController,
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 16),

              buildFormField(
                label: 'Phone Number',
                hintText: 'Enter your phone number',
                controller: _phoneNumberController,
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 40),

              // Save Button
              Obx(() {
                return GestureDetector(
                  onTap: _viewModel.isLoading.value
                      ? null
                      : () => _viewModel.saveProfile(
                            widget.userId,
                            _firstNameController.text,
                            _lastNameController.text,
                            _phoneNumberController.text,
                          ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: _viewModel.isLoading.value ? AppColors.primaryGreen.withOpacity(0.6) : AppColors.primaryGreen,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: _viewModel.isLoading.value
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                          : const Text('Save Changes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
