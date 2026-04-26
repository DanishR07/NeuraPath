import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view_models/job_seeker_career_engine_vm.dart';
import '../../../customs.dart';

class JobSeekerCareerRecommendationScreen extends StatelessWidget {
  final JobSeekerCareerEngineViewModel viewModel = Get.put(JobSeekerCareerEngineViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Career Intelligence", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (viewModel.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen));
        }

        if (viewModel.isProfileIncomplete.value) {
          return _buildIncompleteProfileView();
        }

        final result = viewModel.recommendations.value;
        final recommendations = _extractSection(result, "RECOMMENDATIONS");
        final gaps = _extractSection(result, "SKILL_GAPS");
        final advice = _extractSingleSection(result, "ADVICE");
        
        final stage = viewModel.jobSeekerProfile.value?.experienceLevel;
        String mainTitle = "Professional Roadmap";
        if (stage == "Fresh Graduate") mainTitle = "Early Career Transition";
        if (stage == "Senior/Executive") mainTitle = "Executive Leadership Strategy";

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildModernHeader(mainTitle),
              const SizedBox(height: 24),
              
              _buildSectionLabel("Strategic Recommendations"),
              ...recommendations.map((r) => _buildModernPathCard(r)).toList(),
              
              const SizedBox(height: 24),
              _buildSectionLabel("Competency Gaps"),
              _buildCleanListCard(gaps, Icons.radar_outlined, Colors.orange),
              
              const SizedBox(height: 24),
              _buildSectionLabel("Career Advisor's Summary"),
              _buildProfessionalAdviceCard(advice),
              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildModernHeader(String mainTitle) {
    final profile = viewModel.jobSeekerProfile.value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Personalized Analysis for ${profile?.firstName}",
          style: const TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Text(
          mainTitle,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primaryGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            "Stage: ${profile?.experienceLevel}",
            style: const TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black54, letterSpacing: 0.5)),
    );
  }

  Widget _buildModernPathCard(String text) {
    final parts = text.split(':');
    final title = parts[0].replaceAll(RegExp(r'^[-*]\s*'), '').replaceAll('*', '').trim();
    final description = parts.length > 1 ? parts[1].replaceAll('*', '').trim() : "";

    return Padding(
      padding: const EdgeInsets.only(bottom: 20, left: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.primaryGreen),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
              ),
            ],
          ),
          if (description.isNotEmpty) ...[
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                description,
                style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCleanListCard(List<String> items, IconData icon, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        final cleanedItem = item.replaceAll(RegExp(r'^[-*]\s*'), '').replaceAll('*', '').trim();
        return Padding(
          padding: const EdgeInsets.only(bottom: 12, left: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  cleanedItem,
                  style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildProfessionalAdviceCard(String advice) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.verified_user_outlined, color: AppColors.primaryGreen, size: 18),
            SizedBox(width: 8),
            Text(
              "Expert Perspective",
              style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            advice.replaceAll('*', '').trim(),
            style: const TextStyle(color: Colors.black87, fontSize: 14, height: 1.6),
          ),
        ),
      ],
    );
  }

  Widget _buildIncompleteProfileView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), shape: BoxShape.circle),
              child: const Icon(Icons.assignment_late_outlined, size: 64, color: Colors.orange),
            ),
            const SizedBox(height: 24),
            const Text("Profile Incomplete", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text(
              "To get high-accuracy career advice, please complete your professional details first.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, height: 1.5),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Back to Profile", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  List<String> _extractSection(String text, String section) {
    final regExp = RegExp('# $section:' + r'([\s\S]*?)(?=#|$)');
    final match = regExp.firstMatch(text);
    if (match != null) {
      final content = match.group(1)?.trim() ?? "";
      return content.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    }
    return [];
  }

  String _extractSingleSection(String text, String section) {
    final regExp = RegExp('# $section:' + r'([\s\S]*?)(?=#|$)');
    final match = regExp.firstMatch(text);
    return match?.group(1)?.trim() ?? "";
  }
}
