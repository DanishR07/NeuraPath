import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view_models/ai_chat_vm.dart';

class AIChatScreen extends StatelessWidget {
  const AIChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AIChatViewModel viewModel = Get.put(AIChatViewModel());
    final TextEditingController messageController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 18, right: 18),
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Color(0xFF8BA989).withOpacity(.5)),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.waving_hand,
                      color: Color(0xFF8BA989),
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Your personal AI assistant",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Expanded(
                child: Obx(() {
                  return ListView.builder(
                    controller: viewModel.scrollController,
                    itemCount: viewModel.messages.length,
                    itemBuilder: (context, index) {
                      final message = viewModel.messages[index];
                      final isUser = message['sender'] == 'user';
                      return Align(
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 10.0,
                          ),
                          decoration: BoxDecoration(
                            color: isUser
                                ? const Color(0xFF8BA989)
                                : Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(12),
                              topRight: const Radius.circular(12),
                              bottomLeft: isUser
                                  ? const Radius.circular(12)
                                  : Radius.zero,
                              bottomRight: isUser
                                  ? Radius.zero
                                  : const Radius.circular(12),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            message['text']!,
                            style: TextStyle(
                              color: isUser ? Colors.white : Colors.black87,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
              Obx(
                () => viewModel.isLoading.value
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "AI is typing...",
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                color: Color(0xFFF5F5F5),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onSubmitted: (text) {
                          viewModel.sendMessage(text);
                          messageController.clear();
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        viewModel.sendMessage(messageController.text);
                        messageController.clear();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Color(0xFF8BA989),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 90.0),
              child: FloatingActionButton(
                tooltip: "delete chat...",
                mini: true,
                shape: CircleBorder(),
                onPressed: () {
                  Get.dialog(
                    AlertDialog(
                      title: const Text('Clear Chat'),
                      content: const Text('Are you sure you want to clear the chat?'),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text('No'),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.back(); // Close dialog
                            bool success = viewModel.clearChat();
                            if (success) {
                              Get.snackbar(
                                'Success',
                                'Chat cleared successfully',
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                              );
                            } else {
                              Get.snackbar(
                                'Error',
                                'Failed to clear chat',
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                            }
                          },
                          child: const Text('Yes', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
                backgroundColor: const Color(0xFF8BA989),
                child: const Icon(Icons.delete_outline, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
