import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:read_pdf_text/read_pdf_text.dart';
import '../../../services/ai_service.dart';

class ResumeEnhancerViewModel extends GetxController {
  final AIService _aiService = AIService();
  
  var isAnalyzing = false.obs;
  var analysisResult = ''.obs;
  var selectedFileName = ''.obs;
  var selectedFilePath = ''.obs;

  Future<void> pickAndAnalyzeResume() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        selectedFilePath.value = result.files.single.path!;
        selectedFileName.value = result.files.single.name;
        
        await _analyzeResume(selectedFilePath.value);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick file: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  Future<void> _analyzeResume(String path) async {
    isAnalyzing.value = true;
    analysisResult.value = '';
    
    try {
      String text = await ReadPdfText.getPDFtext(path);
      
      if (text.isEmpty) {
        throw Exception("Could not extract text from PDF");
      }

      String prompt = """
      Analyze the following resume text for ATS compliance and overall quality.
      Provide the output in the following format:
      
      **ATS Score:** [Score]/100
      
      **Strengths:**
      - [Point 1]
      - [Point 2]
      
      **Weaknesses & Gaps:**
      - [Point 1]
      - [Point 2]
      
      **Suggested Keywords:**
      [Keyword 1], [Keyword 2], [Keyword 3]
      
      Resume Text:
      $text
      """;

      // Assuming sendMessage returns a String response from Gemini
      // You might need to adjust this based on your actual AIService implementation
      final response = await _aiService.sendMessage(prompt);
      analysisResult.value = response ?? "Failed to get analysis from AI.";
      
    } catch (e) {
      Get.snackbar('Error', 'Analysis failed: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      analysisResult.value = "Error analyzing resume.";
    } finally {
      isAnalyzing.value = false;
    }
  }

  void clearAnalysis() {
    selectedFileName.value = '';
    selectedFilePath.value = '';
    analysisResult.value = '';
    isAnalyzing.value = false;
  }
}
