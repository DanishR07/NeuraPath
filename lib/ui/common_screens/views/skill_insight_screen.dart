import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view_models/skill_insight_vm.dart';
import '../../../customs.dart';

class SkillInsightScreen extends StatelessWidget {
  final SkillInsightViewModel viewModel = Get.put(SkillInsightViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Skill Insight", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (viewModel.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen));
        }

        if (viewModel.isProfileIncomplete.value) {
          return _buildIncompleteView();
        }

        final result = viewModel.analysisResult.value;
        final successAspects = _extractSingleSection(result, "SUCCESS_ASPECTS");
        final majorGaps = _extractSingleSection(result, "MAJOR_GAPS");
        final learning = _extractSingleSection(result, "RECOMMENDED_LEARNING");
        final advice = _extractSingleSection(result, "ADVICE");

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildModernHeader(),
              const SizedBox(height: 32),
              
              if (successAspects.isNotEmpty) ...[
                _buildPlainHeading("Success Strategy & Aspects"),
                _buildPlainContent(successAspects),
                const SizedBox(height: 28),
              ],
              
              if (majorGaps.isNotEmpty) ...[
                _buildPlainHeading("Current Skill Gaps"),
                _buildPlainContent(majorGaps),
                const SizedBox(height: 28),
              ],
              
              if (learning.isNotEmpty) ...[
                _buildPlainHeading("Recommended Learning & Certifications"),
                _buildPlainContent(learning),
                const SizedBox(height: 28),
              ],
              
              if (advice.isNotEmpty) ...[
                _buildPlainHeading("Final Advisor Statement"),
                _buildPlainContent(advice),
              ],
              
              const SizedBox(height: 50),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildModernHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Personalized Intelligence for ${viewModel.userRole.value}",
          style: const TextStyle(fontSize: 13, color: AppColors.primaryGreen, fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        const SizedBox(height: 8),
        const Text(
          "Skill Insight & Learning Advisor",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: -0.5),
        ),
      ],
    );
  }

  Widget _buildPlainHeading(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: 0.2),
      ),
    );
  }

  Widget _buildPlainContent(String content) {
    return Text(
      content.replaceAll('*', '').trim(),
      style: TextStyle(fontSize: 15, color: Colors.grey[800], height: 1.6, fontWeight: FontWeight.normal),
    );
  }

  Widget _buildIncompleteView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.info_outline, size: 48, color: Colors.grey),
            const SizedBox(height: 24),
            const Text("Analysis Incomplete", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text(
              "Please complete your profile first to receive targeted insights.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
              ),
              child: const Text("Go Back", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  String _extractSingleSection(String text, String section) {
    final regExp = RegExp('# $section:' + r'([\s\S]*?)(?=#|$)');
    final match = regExp.firstMatch(text);
    return match?.group(1)?.trim() ?? "";
  }
}
