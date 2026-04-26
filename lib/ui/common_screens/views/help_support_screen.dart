import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view_models/help_support_vm.dart';
import '../../../customs.dart';

class HelpSupportScreen extends StatelessWidget {
  final HelpSupportViewModel viewModel = Get.put(HelpSupportViewModel());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Help & Support", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "How can we help you?",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 8),
              const Text(
                "Search our FAQs or contact our support team directly for specialized assistance.",
                style: TextStyle(color: Colors.black54, height: 1.5),
              ),
              const SizedBox(height: 32),
              
              _buildSectionTitle("Frequently Asked Questions"),
              _buildFAQItem(
                "How does the AI provide recommendations?",
                "Our proprietary Career Intelligence engine analyzes your unique profile data—skills, education level, and goals—using advanced Llama-3 models to generate tailored advice."
              ),
              _buildFAQItem(
                "Is my data shared with others?",
                "No. Your personal and professional information is private. We only share anonymized data with AI providers for processing, and your resume data is encrypted."
              ),
              _buildFAQItem(
                "How does the Professional Job Matcher work?",
                "For Professionals, the matcher is designed as a 'Level-Up' tool. It ignores jobs at your current level and only surfaces roles that represent a seniority advancement (e.g., Manager to Director)."
              ),
              _buildFAQItem(
                "Why is my 'Growth Pathway' locked?",
                "The Growth Pathway module is exclusive to Professionals and requires a 100% completed profile to perform a high-accuracy executive analysis."
              ),
              _buildFAQItem(
                "What is the Smart Resume Enhancer?",
                "It’s an AI tool that scans your uploaded PDF resume against industry standards and gives you a score along with actionable tips to beat ATS systems."
              ),
              _buildFAQItem(
                "How do I use the Skill Insight tool?",
                "The tool automatically scans your current profile against industry standards. It identifies specific technical and leadership gaps and suggests direct courses or certifications to fill them."
              ),
              _buildFAQItem(
                "Can I download my improved resume?",
                "Yes. Once you have followed the AI suggestions in the Resume Enhancer, you can export your updated details as a professionally formatted PDF from the 'Export' tab."
              ),
              _buildFAQItem(
                "How do I reach 100% profile completion?",
                "Ensure every field in your profile (Education, Experience, Skills, and Goals) is filled. A complete profile significantly improves the accuracy of AI career matching."
              ),
              _buildFAQItem(
                "What if the AI recommendations aren't relevant?",
                "The AI depends entirely on the data provided in your profile. If suggestions aren't matching your expectations, try adding more specific technical skills or refining your 'Career Goal' field."
              ),

              const SizedBox(height: 40),
              _buildSectionTitle("Contact Support"),
              _buildContactCard(
                context,
                title: "Send a Message",
                subtitle: "Submit a support ticket to our team",
                icon: Icons.chat_bubble_outline,
                onTap: () => _showSupportForm(context),
              ),
              _buildContactCard(
                context,
                title: "Email Assistance",
                subtitle: "support@neurapath.com",
                icon: Icons.alternate_email,
                showArrow: false,
                onTap: () {}, // Implementation for URL launcher can be added
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryGreen)),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: ExpansionTile(
        title: Text(question, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Text(answer, style: const TextStyle(fontSize: 13, color: Colors.black54, height: 1.5)),
          )
        ],
        shape: const RoundedRectangleBorder(side: BorderSide.none),
      ),
    );
  }

  Widget _buildContactCard(BuildContext context, {required String title, required String subtitle, required IconData icon, required VoidCallback onTap, bool showArrow = true}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppColors.primaryGreen.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: AppColors.primaryGreen, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                ],
              ),
            ),
            if (showArrow) const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }


  void _showSupportForm(BuildContext context) {
    final subController = TextEditingController();
    final msgController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Submit Support Ticket", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(
              controller: subController,
              decoration: InputDecoration(
                labelText: "Subject",
                labelStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: msgController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: "Message",
                labelStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: Obx(() => ElevatedButton(
                onPressed: viewModel.isLoading.value ? null : () async {
                  final success = await viewModel.submitSupportTicket(subController.text, msgController.text);
                  if (success) Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: viewModel.isLoading.value 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Send Ticket", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              )),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
