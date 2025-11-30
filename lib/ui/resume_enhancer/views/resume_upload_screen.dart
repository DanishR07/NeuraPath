import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../view_models/resume_enhancer_view_model.dart';
import 'resume_analysis_screen.dart';

class ResumeUploadScreen extends StatelessWidget {
  final ResumeEnhancerViewModel viewModel = Get.put(ResumeEnhancerViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Resume Enhancer'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Text(
              'Optimize Your Resume with AI',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8BA989),
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Upload your resume (PDF) to get an ATS score, strengths, and improvement suggestions.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            // Placeholder for an illustration/Lottie
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Color(0xFF8BA989).withOpacity(.3),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Color(0xFF8BA989).withOpacity(0.6)),
              ),
              child: Center(
                child: Icon(
                  Icons.upload_file,
                  size: 80,
                  color: Color(0xFF8BA989),
                ),
              ),
            ),
            const Spacer(),
            Obx(() {
              if (viewModel.isAnalyzing.value) {
                return const Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(color: Color(0xFF8BA989),),
                      SizedBox(height: 16),
                      Text("Analyzing your resume..."),
                    ],
                  ),
                );
              }
              
              if (viewModel.analysisResult.value.isNotEmpty) {
                 WidgetsBinding.instance.addPostFrameCallback((_) {
                   Get.to(() => ResumeAnalysisScreen());
                 });
                 return ElevatedButton(
                   onPressed: () => Get.to(() => ResumeAnalysisScreen()),
                   style: ElevatedButton.styleFrom(
                     padding: const EdgeInsets.symmetric(vertical: 16),
                     backgroundColor: Color(0xFF8BA989),
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(12),
                     ),
                   ),
                   child: const Text(
                     'View Analysis Results',
                     style: TextStyle(fontSize: 18, color: Colors.white),
                   ),
                 );
              }

              return ElevatedButton.icon(
                onPressed: () => viewModel.pickAndAnalyzeResume(),
                icon: const Icon(Icons.upload_file),
                label: const Text('Upload Resume (PDF)'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Color(0xFF8BA989),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            }),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
