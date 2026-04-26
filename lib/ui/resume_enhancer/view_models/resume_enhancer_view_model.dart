import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:read_pdf_text/read_pdf_text.dart';
import '../../../services/ai_service.dart';
import '../views/resume_analysis_screen.dart';

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
      You are an expert Resume Analyst. First, determine if the following text belongs to a Resume or CV.
      If it is NOT a Resume/CV (e.g., it's a random document, book, or article), respond EXACTLY with: "ERROR: NOT_A_RESUME".
      
      If it IS a Resume/CV, analyze it based on the following rules:
      1. Calculate an ATS Score (0-100).
      2. If the Score is > 90 (Strong Resume): 
         - Provide the ATS_SCORE.
         - For SUMMARY, provide a highly appreciative and encouraging feedback.
         - Keep STRENGTHS, WEAKNESSES, and KEYWORDS sections minimal or empty.
      3. If the Score is 50-89 (Moderate Resume):
         - Provide the ATS_SCORE.
         - Provide a balanced SUMMARY.
         - Provide detailed STRENGTHS, WEAKNESSES, and KEYWORDS.
      4. If the Score is < 50 (Beginner Resume):
         - Provide the ATS_SCORE.
         - Provide a supportive and guiding SUMMARY for beginners.
         - Provide fundamental STRENGTHS, WEAKNESSES, and foundational KEYWORDS.

      Format your output as followed:
      # ATS_SCORE: [number]
      # STRENGTHS: [points]
      # WEAKNESSES: [points]
      # KEYWORDS: [comma separated]
      # SUMMARY: [text]
      
      Resume Text:
      $text
      """;

      // Assuming sendMessage returns a String response from Gemini
      // You might need to adjust this based on your actual AIService implementation
      final response = await _aiService.sendMessage(prompt);
      
      if (response != null && response.contains("ERROR: NOT_A_RESUME")) {
        Get.snackbar(
          'Invalid Document', 
          'The uploaded document does not appear to be a Resume or CV. Please upload a valid resume.',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        analysisResult.value = '';
        return;
      }

      analysisResult.value = response ?? "Failed to get analysis from AI.";
      Get.to(() => ResumeAnalysisScreen());
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
