import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../view_models/resume_enhancer_view_model.dart';

class ResumeAnalysisScreen extends StatelessWidget {
  final ResumeEnhancerViewModel viewModel = Get.find<ResumeEnhancerViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis Results'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            viewModel.clearAnalysis();
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (viewModel.analysisResult.value.isEmpty) {
            return const Center(child: Text("No analysis data available."));
          }
          return Markdown(
            data: viewModel.analysisResult.value,
            styleSheet: MarkdownStyleSheet(
              h1: const TextStyle(color: Colors.blueAccent, fontSize: 24, fontWeight: FontWeight.bold),
              h2: const TextStyle(color: Colors.blueAccent, fontSize: 20, fontWeight: FontWeight.bold),
              p: const TextStyle(fontSize: 16, height: 1.5),
              listBullet: const TextStyle(color: Colors.blueAccent),
            ),
          );
        }),
      ),
    );
  }
}
