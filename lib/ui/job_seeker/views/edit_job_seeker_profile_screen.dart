import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view_models/job_seeker_profile_view_model.dart';
import '../../../customs.dart';

class EditJobSeekerProfileScreen extends StatefulWidget {
  @override
  State<EditJobSeekerProfileScreen> createState() => _EditJobSeekerProfileScreenState();
}

class _EditJobSeekerProfileScreenState extends State<EditJobSeekerProfileScreen> {
  final JobSeekerProfileViewModel _viewModel = Get.find<JobSeekerProfileViewModel>();

  final List<String> expLevels = ["Fresh Graduate", "Experienced Professional", "Senior/Executive"];
  final List<String> salaryRanges = ["20k - 50k", "50k - 100k", "100k - 200k", "200k+", "Other"];
  final List<String> jobTypes = ["Remote", "On-site", "Hybrid"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Complete Profile", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => _viewModel.saveProfile(),
            child: const Text("Save", style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold, fontSize: 16)),
          )
        ],
      ),
      body: Obx(() {
        if (_viewModel.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen));
        }

        final level = _viewModel.experienceLevel.value;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStepTitle("Professional Experience Level"),
              _buildTierToggle(),
              const SizedBox(height: 24),

              _buildSection("Career Identity", [
                if (level != "Fresh Graduate")
                  _buildTextField("Current Job Title", _viewModel.currentJobTitleController),
                _buildTextField("Highest Qualification (e.g. BSCS, MBA)", _viewModel.highestQualificationController),
                if (level != "Fresh Graduate")
                  _buildTextField("Total Years of Experience", _viewModel.totalExperienceController, keyboardType: TextInputType.number),
              ]),

              _buildSection("Skills & Expertise", [
                _buildTextField("Core Technical Skills (e.g. React, Python)", _viewModel.technicalSkillsController, maxLines: 2),
                _buildTextField("Professional Certifications (Optional)", _viewModel.certificationsController),
              ]),

              _buildSection("Job Preferences", [
                _buildTextField("Target Job Roles (e.g. Frontend Dev, Manager)", _viewModel.targetJobRolesController),
                _buildTextField("Preferred Industries (e.g. Fintech, Healthcare)", _viewModel.preferredIndustriesController),
                _buildDropdownField(
                  label: "Expected Salary Range (PKR)",
                  value: _viewModel.expectedSalaryRangeController.text,
                  items: salaryRanges,
                  onChanged: (val) => _viewModel.expectedSalaryRangeController.text = val!,
                ),
                _buildDropdownField(
                  label: "Preferred Work Type",
                  value: _viewModel.jobTypeController.text,
                  items: jobTypes,
                  onChanged: (val) => _viewModel.jobTypeController.text = val!,
                ),
              ]),

              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStepTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
    );
  }

  Widget _buildTierToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[200]!)),
      child: Column(
        children: expLevels.map((lvl) {
          final isSelected = _viewModel.experienceLevel.value == lvl;
          return GestureDetector(
            onTap: () => _viewModel.experienceLevel.value = lvl,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 2),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryGreen : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                   Icon(isSelected ? Icons.check_circle : Icons.circle_outlined, color: isSelected ? Colors.white : Colors.grey, size: 20),
                   const SizedBox(width: 12),
                   Text(lvl, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryGreen)),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))]),
          child: Column(children: children),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[600], fontSize: 13),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[200]!)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[200]!)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primaryGreen)),
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildDropdownField({required String label, required String value, required List<String> items, required Function(String?) onChanged}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: items.contains(value) ? value : null,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[600], fontSize: 13),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[200]!)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[200]!)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primaryGreen)),
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        items: items.map((i) => DropdownMenuItem(value: i, child: Text(i, style: const TextStyle(fontSize: 14)))).toList(),
        onChanged: onChanged,
        icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.primaryGreen),
      ),
    );
  }
}

