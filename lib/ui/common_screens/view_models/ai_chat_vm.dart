import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/ai_repository.dart';

class AIChatViewModel extends GetxController {
  final AIRepository _aiRepository = AIRepository();

  var messages = <Map<String, String>>[
    {'sender': 'ai', 'text': 'Hello! How can I assist you today?'}
  ].obs;

  var isLoading = false.obs;
  final ScrollController scrollController = ScrollController();

  void sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add user message
    messages.add({'sender': 'user', 'text': text.trim()});
    _scrollToBottom();

    isLoading.value = true;

    // Get AI response
    String aiResponse = await _aiRepository.sendMessage(text.trim());

    // Add AI message
    messages.add({'sender': 'ai', 'text': aiResponse});
    isLoading.value = false;
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  bool clearChat() {
    try {
      messages.clear();
      messages.add({'sender': 'ai', 'text': 'Hello! How can I assist you today?'});
      return true;
    } catch (e) {
      return false;
    }
  }
}