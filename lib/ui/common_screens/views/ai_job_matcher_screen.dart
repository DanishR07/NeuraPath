import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../view_models/ai_job_matcher_vm.dart';
import '../../../customs.dart';
import '../../custom_widgets/incomplete_profile_widget.dart';

class AIJobMatcherScreen extends StatelessWidget {
  final AIJobMatcherViewModel viewModel = Get.put(AIJobMatcherViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("AI Job Matcher", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
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
          return const IncompleteProfileWidget();
        }

        if (viewModel.matchedJobs.isEmpty) {
          return _buildNoMatchesView();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              _buildHeader(),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: viewModel.matchedJobs.length,
                  itemBuilder: (context, index) {
                    final job = viewModel.matchedJobs[index];
                    return _buildJobCard(job);
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeader() {
    bool isProfessional = viewModel.userRole.value == "Professional";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isProfessional ? "Next-Level Opportunities" : "Matched Opportunities",
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 4),
        Text(
          isProfessional 
            ? "Exclusive roles selected to advance your current seniority level."
            : "Jobs curated based on your unique skills and career preferences.",
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildJobCard(dynamic job) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppColors.primaryGreen.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.business_center, color: AppColors.primaryGreen, size: 24),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Text(job.level, style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(job.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          Text(job.company, style: const TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w500)),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(job.location, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(width: 16),
                const Icon(Icons.monetization_on_outlined, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(job.salary, style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: (job.skills as List<String>).map((skill) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(6)),
              child: Text(skill, style: TextStyle(color: Colors.grey[800], fontSize: 11, fontWeight: FontWeight.w500)),
            )).toList(),
          ),
          if (job.link.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Divider(color: Colors.black12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: job.link));
                  Get.snackbar(
                    "Link Copied",
                    "Job link copied to clipboard!",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.black87,
                    colorText: Colors.white,
                    margin: const EdgeInsets.all(16),
                  );
                },
                icon: const Icon(Icons.copy, size: 16, color: AppColors.primaryGreen),
                label: const Text("Copy Link", style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold)),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  backgroundColor: AppColors.primaryGreen.withOpacity(0.1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNoMatchesView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text("No matches found just yet.", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text("Keep your profile updated for better recommendations.", textAlign: TextAlign.center, style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 24),
          TextButton(onPressed: () => viewModel.findMatches(), child: const Text("Refresh Matches", style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }
}
