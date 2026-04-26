import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../customs.dart';
import '../view_models/career_engine_vm.dart';

class CareerRecommendationScreen extends StatelessWidget {
  final CareerEngineViewModel viewModel = Get.put(CareerEngineViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text('AI Career Intelligence', 
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
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
        
        final level = viewModel.studentProfile.value?.educationLevel;
        String mainTitle = "Career Roadmap";
        if (level == "Matric") mainTitle = "Intermediate Studies Path";
        if (level == "Intermediate") mainTitle = "University & Degree Options";

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildModernHeader(mainTitle),
              const SizedBox(height: 24),
              
              _buildSectionLabel(level == "University" ? "Suggested Career Paths" : "Recommended Next Steps"),
              ...recommendations.map((r) => _buildModernPathCard(r)).toList(),
              
              const SizedBox(height: 24),
              _buildSectionLabel(level == "University" ? "Skill Gap Analysis" : "Preparatory Requirements"),
              _buildCleanListCard(gaps, level == "University" ? Icons.add_chart_outlined : Icons.menu_book_outlined, Colors.orange),
              
              const SizedBox(height: 24),
              _buildSectionLabel("Advisor's Summary"),
              _buildProfessionalAdviceCard(advice),
              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildIncompleteProfileView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_outline, size: 80, color: Colors.orange.withOpacity(0.5)),
            const SizedBox(height: 24),
            const Text(
              "Incomplete Profile",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              "To provide accurate career recommendations, we need your Degree, Major, Technical Skills, and Career Interests. Please complete your profile first.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, height: 1.5),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Get.back(), // User can go back and click profile
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Go Back", style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernHeader(String mainTitle) {
    final profile = viewModel.studentProfile.value;
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
            "Current: ${profile?.major} (${profile?.educationLevel})",
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

  // --- Regex Helpers ---
  List<String> _extractSection(String text, String section) {
    final regExp = RegExp('# $section:' + r'([\s\S]*?)(?=#|$)');
    final match = regExp.firstMatch(text);
    if (match != null) {
      final content = match.group(1)?.trim() ?? "";
      return content.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    }
    return ["No trends found"];
  }

  String _extractSingleSection(String text, String section) {
    final regExp = RegExp('# $section:' + r'([\s\S]*?)(?=#|$)');
    final match = regExp.firstMatch(text);
    return match?.group(1)?.trim() ?? "Preparing your personalized roadmap...";
  }

}
