import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fyp/data/repositories/auth_repository.dart';
import 'package:fyp/services/cloudinary_service.dart';

class ProfileSetupViewModel extends GetxController {
  final AuthRepository _authRepository = Get.find();

  final isLoading = false.obs;
  final isUploadingImage = false.obs;
  final profileImageUrl = Rxn<String>();
  final selectedImageFile = Rxn<File>();
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> pickProfileImage(ImageSource source) async {
    try {
      final pickedFile = await _imagePicker.pickImage(source: source);

      if (pickedFile != null) {
        selectedImageFile.value = File(pickedFile.path);
        print('[v0] ProfileSetupViewModel: Image picked - ${pickedFile.path}');

        // Upload to Cloudinary immediately
        await uploadImageToCloudinary();
      }
    } catch (e) {
      print('[v0] ProfileSetupViewModel: Error picking image - ${e.toString()}');
      Get.snackbar('Error', 'Failed to pick image');
    }
  }

  Future<void> uploadImageToCloudinary() async {
    try {
      if (selectedImageFile.value == null) {
        print('[v0] ProfileSetupViewModel: No image file selected');
        return;
      }

      isUploadingImage.value = true;
      print('[v0] ProfileSetupViewModel: Starting Cloudinary upload');

      final uploadedUrl = await CloudinaryService.uploadProfileImage(selectedImageFile.value!);

      if (uploadedUrl != null) {
        profileImageUrl.value = uploadedUrl;
        print('[v0] ProfileSetupViewModel: Image URL set - $uploadedUrl');
        Get.snackbar('Success', 'Profile picture uploaded successfully', snackPosition: SnackPosition.BOTTOM);
      } else {
        print('[v0] ProfileSetupViewModel: Upload returned null');
        Get.snackbar('Error', 'Failed to upload image to Cloudinary');
      }

      isUploadingImage.value = false;
    } catch (e) {
      isUploadingImage.value = false;
      print('[v0] ProfileSetupViewModel: Error uploading image - ${e.toString()}');
      Get.snackbar('Error', 'Failed to upload image: ${e.toString()}');
    }
  }

  void showImageSourceDialog() {
    Get.dialog(
      AlertDialog(
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt, color: const Color(0xFF8BA989)),
              title: const Text('Camera'),
              onTap: () {
                Get.back();
                pickProfileImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.image, color: const Color(0xFF8BA989)),
              title: const Text('Gallery'),
              onTap: () {
                Get.back();
                pickProfileImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> handleCompleteProfile({
    required String userId,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String role,
  }) async {
    try {
      // Validate required fields
      if (firstName.trim().isEmpty || lastName.trim().isEmpty ||
          phoneNumber.trim().isEmpty || role.isEmpty) {
        Get.snackbar(
          'Validation Error',
          'Please fill all required fields',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }

      // Validate phone number format (basic validation)
      if (!RegExp(r'^[0-9]{10,}$').hasMatch(phoneNumber.trim())) {
        Get.snackbar(
          'Validation Error',
          'Please enter a valid phone number',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }

      isLoading.value = true;
      print('[v0] ProfileSetupViewModel: Updating profile for user - $userId');

      await _authRepository.updateUserProfile(
        userId: userId,
        firstName: firstName.trim(),
        lastName: lastName.trim(),
        phoneNumber: phoneNumber.trim(),
        role: role,
        profileImageUrl: profileImageUrl.value,
      );

      print('[v0] ProfileSetupViewModel: Profile updated successfully');
      isLoading.value = false;

      // Navigate to home screen based on role
      _navigateToHomeScreen(role);
      return true;
    } catch (e) {
      isLoading.value = false;
      print('[v0] ProfileSetupViewModel: Error updating profile - ${e.toString()}');
      Get.snackbar(
        'Error',
        'Failed to update profile: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  void _navigateToHomeScreen(String role) {
    // TODO: Replace with actual role-based home screens when available
    Get.offNamed('/home_screen');
    print('[v0] ProfileSetupViewModel: Navigated to home screen for role: $role');
  }

  void clearProfileImageUrl() {
    profileImageUrl.value = null;
    selectedImageFile.value = null;
  }

  @override
  void onClose() {
    clearProfileImageUrl();
    super.onClose();
  }
}

class ProfileSetupScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileSetupViewModel>(() => ProfileSetupViewModel());
  }
}
