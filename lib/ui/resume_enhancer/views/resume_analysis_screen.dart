import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../customs.dart';
import '../view_models/resume_enhancer_view_model.dart';

class ResumeAnalysisScreen extends StatelessWidget {
  final ResumeEnhancerViewModel viewModel = Get.find<ResumeEnhancerViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text('AI Analysis Dashboard', 
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black54),
          onPressed: () {
            viewModel.clearAnalysis();
            Get.back();
          },
        ),
      ),
      body: Obx(() {
        if (viewModel.analysisResult.value.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen));
        }

        final result = viewModel.analysisResult.value;
        final score = _extractScore(result);
        final strengths = _extractSection(result, "STRENGTHS");
        final weaknesses = _extractSection(result, "WEAKNESSES");
        final keywords = _extractKeywords(result);
        final summary = _extractSection(result, "SUMMARY").first;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildScoreHeader(score),
              const SizedBox(height: 24),
              _buildSummaryCard(summary),
              const SizedBox(height: 24),
              if (strengths.isNotEmpty && strengths.first != "No detail provided") ...[
                _buildSectionTitle("Top Strengths", Icons.check_circle_outline, Colors.green),
                const SizedBox(height: 12),
                ...strengths.map((s) => _buildPointCard(s, Colors.green)).toList(),
                const SizedBox(height: 24),
              ],
              if (weaknesses.isNotEmpty && weaknesses.first != "No detail provided") ...[
                _buildSectionTitle("Areas to Improve", Icons.error_outline, Colors.orange),
                const SizedBox(height: 12),
                ...weaknesses.map((w) => _buildPointCard(w, Colors.orange)).toList(),
                const SizedBox(height: 24),
              ],
              if (keywords.isNotEmpty) ...[
                _buildSectionTitle("Optimization Keywords", Icons.local_offer_outlined, AppColors.primaryGreen),
                const SizedBox(height: 12),
                _buildKeywordWrap(keywords),
              ],
              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildScoreHeader(int score) {
    Color scoreColor = score > 75 ? Colors.green : (score > 50 ? Colors.orange : Colors.red);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10))
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 120,
            width: 120,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: score / 100,
                  strokeWidth: 10,
                  backgroundColor: scoreColor.withOpacity(0.1),
                  color: scoreColor,
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("$score", 
                        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: scoreColor)),
                      const Text("ATS Score", style: TextStyle(fontSize: 10, color: Colors.black45)),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            score > 75 ? "Excellent Match!" : (score > 50 ? "Good Foundation" : "Needs Improvement"),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String summary) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.primaryGreen, AppColors.primaryGreen.withOpacity(0.8)]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        summary,
        style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5, fontStyle: FontStyle.italic),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
      ],
    );
  }

  Widget _buildPointCard(String text, Color color) {
    if (text.trim().isEmpty || text == "No detail provided") return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Icon(Icons.arrow_right, color: color, size: 16),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.4))),
        ],
      ),
    );
  }

  Widget _buildKeywordWrap(List<String> keywords) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: keywords.map((k) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primaryGreen.withOpacity(0.1),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.primaryGreen.withOpacity(0.2)),
        ),
        child: Text(k, style: const TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.w600, fontSize: 13)),
      )).toList(),
    );
  }

  // --- Helper Methods for Parsing AI Response ---
  
  int _extractScore(String text) {
    final match = RegExp(r'ATS_SCORE:\s*(\d+)').firstMatch(text);
    return int.tryParse(match?.group(1) ?? "0") ?? 0;
  }

  List<String> _extractSection(String text, String section) {
    final regExp = RegExp('# $section:' + r'([\s\S]*?)(?=#|$)');
    final match = regExp.firstMatch(text);
    if (match != null) {
      final content = match.group(1)?.trim() ?? "";
      return content.split('\n').map((e) => e.replaceAll(RegExp(r'^[-*]\s*'), '').trim()).where((e) => e.isNotEmpty).toList();
    }
    return ["No detail provided"];
  }

  List<String> _extractKeywords(String text) {
    final regExp = RegExp('# KEYWORDS:' + r'([\s\S]*?)(?=#|$)');
    final match = regExp.firstMatch(text);
    if (match != null) {
      return match.group(1)?.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList() ?? [];
    }
    return [];
  }
}
