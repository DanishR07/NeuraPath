import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view_models/growth_pathway_vm.dart';
import '../../../customs.dart';

class GrowthPathwayScreen extends StatelessWidget {
  final GrowthPathwayViewModel viewModel = Get.put(GrowthPathwayViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Growth Pathway", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
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

        final result = viewModel.pathwayResult.value;
        final promotion = _extractSection(result, "PROMOTION_PATHWAY");
        final skills = _extractSection(result, "STRATEGIC_SKILLS");
        final benchmark = _extractSingleSection(result, "MARKET_BENCHMARK");
        final advice = _extractSingleSection(result, "ADVICE");
        
        final profile = viewModel.professionalProfile.value;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGrowthHeader(profile?.firstName, profile?.jobLevel),
              const SizedBox(height: 30),
              
              _buildSectionLabel("Executive Promotion Roadmap"),
              ...promotion.map((p) => _buildPathwayCard(p)).toList(),
              
              const SizedBox(height: 24),
              _buildSectionLabel("Critical Power Skills"),
              _buildCleanList(skills, Icons.auto_awesome, Colors.amber),
              
              const SizedBox(height: 24),
              _buildSectionLabel("Industry Market Benchmark"),
              _buildBenchmarkCard(benchmark),
              
              const SizedBox(height: 24),
              _buildSectionLabel("Internal Growth Strategy"),
              _buildAdviceCard(advice),
              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildGrowthHeader(String? name, String? level) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Strategic Roadmap for $name",
          style: const TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        const Text(
          "Growth Pathway Analysis",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primaryGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            "Current Tier: $level",
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

  Widget _buildPathwayCard(String text) {
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
              const Icon(Icons.keyboard_double_arrow_up, size: 14, color: AppColors.primaryGreen),
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
              padding: const EdgeInsets.only(left: 22),
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

  Widget _buildCleanList(List<String> items, IconData icon, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        final cleaned = item.replaceAll(RegExp(r'^[-*]\s*'), '').replaceAll('*', '').trim();
        return Padding(
          padding: const EdgeInsets.only(bottom: 12, left: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  cleaned,
                  style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBenchmarkCard(String benchmark) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Text(
        benchmark.replaceAll('*', '').trim(),
        style: const TextStyle(color: Colors.black87, fontSize: 14, height: 1.6, fontStyle: FontStyle.italic),
      ),
    );
  }

  Widget _buildAdviceCard(String advice) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryGreen.withOpacity(0.05), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryGreen.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lightbulb_outline, color: AppColors.primaryGreen, size: 20),
              SizedBox(width: 8),
              Text(
                "Strategic Advice",
                style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            advice.replaceAll('*', '').trim(),
            style: const TextStyle(color: Colors.black87, fontSize: 14, height: 1.6),
          ),
        ],
      ),
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
              child: const Icon(Icons.rocket_launch_outlined, size: 64, color: Colors.orange),
            ),
            const SizedBox(height: 24),
            const Text("Analysis Readiness Required", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text(
              "To perform a high-tier growth analysis, please ensure your Professional Identity (Level, Title, Experience) is fully updated.",
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
              child: const Text("Update Profile", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
