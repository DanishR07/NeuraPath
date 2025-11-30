import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../services/cloudinary_service.dart';

class EditProfileViewModel extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final CloudinaryService _cloudinaryService = CloudinaryService();

  var isLoading = false.obs;
  var isUploadingImage = false.obs;
  
  var firstName = ''.obs;
  var lastName = ''.obs;
  var phoneNumber = ''.obs;
  var profileImageUrl = Rxn<String>();
  var selectedImageFile = Rxn<File>();

  final ImagePicker _picker = ImagePicker();

  Future<void> loadUserProfile(String userId) async {
    isLoading.value = true;
    try {
      final user = await _authRepository.getUserProfile(userId);
      if (user != null) {
        firstName.value = user.firstName ?? '';
        lastName.value = user.lastName ?? '';
        phoneNumber.value = user.phoneNumber ?? '';
        profileImageUrl.value = user.profileImageUrl;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load profile: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source, imageQuality: 70);
      if (image != null) {
        selectedImageFile.value = File(image.path);
        await _uploadImage(File(image.path));
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    isUploadingImage.value = true;
    try {
      final url = await CloudinaryService.uploadProfileImage(imageFile);
      if (url != null) {
        profileImageUrl.value = url;
      } else {
        Get.snackbar('Error', 'Failed to upload image',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Image upload error: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isUploadingImage.value = false;
    }
  }

  void showImageSourceDialog() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Image Source',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSourceOption(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  onTap: () {
                    Get.back();
                    pickImage(ImageSource.camera);
                  },
                ),
                _buildSourceOption(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  onTap: () {
                    Get.back();
                    pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: const Color(0xFFF5F5F5),
            child: Icon(icon, color: const Color(0xFF8BA989), size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Future<void> saveProfile(String userId, String fName, String lName, String phone) async {
    if (fName.isEmpty || lName.isEmpty || phone.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      await _authRepository.updateBasicUserInfo(
        userId: userId,
        firstName: fName,
        lastName: lName,
        phoneNumber: phone,
        profileImageUrl: profileImageUrl.value,
      );
      Get.back();
      Get.snackbar('Success', 'Profile updated successfully',
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}
