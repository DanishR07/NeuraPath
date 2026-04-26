import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fyp/data/repositories/auth_repository.dart';

class HelpSupportViewModel extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var isLoading = false.obs;

  Future<bool> submitSupportTicket(String subject, String message) async {
    if (subject.isEmpty || message.isEmpty) {
      Get.snackbar("Error", "Please fill in all fields");
      return false;
    }

    isLoading.value = true;
    try {
      final user = await _authRepository.getCurrentUser();
      if (user == null) throw "User not authenticated";

      await _firestore.collection('support_requests').add({
        'userId': user.id,
        'userEmail': user.email,
        'userName': "${user.firstName ?? ''} ${user.lastName ?? ''}".trim(),
        'subject': subject,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'Pending',
      });

      Get.snackbar("Message Sent", "We have received your request and will contact you via email soon.",backgroundColor: Colors.green);
      return true;
    } catch (e) {
      Get.snackbar("Error", "Failed to send message: $e",backgroundColor: Colors.red);
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
