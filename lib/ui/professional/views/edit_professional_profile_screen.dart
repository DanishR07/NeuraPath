import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view_models/professional_profile_view_model.dart';

class EditProfessionalProfileScreen extends StatelessWidget {
  final ProfessionalProfileViewModel _viewModel = Get.find<ProfessionalProfileViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Edit Profile", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        actions: [
          TextButton(
            onPressed: () => _viewModel.saveProfile(),
            child: const Text("Save", style: TextStyle(color: Color(0xFF8BA989), fontWeight: FontWeight.bold, fontSize: 16)),
          )
        ],
      ),
      body: Obx(() {
        if (_viewModel.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF8BA989)));
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildSection("Career Information", [
                _buildTextField("Current Job Title", _viewModel.currentJobTitleController),
                _buildTextField("Job Level (Junior/Mid/Senior)", _viewModel.jobLevelController),
                _buildTextField("Current Company", _viewModel.currentCompanyController),
                _buildTextField("Years of Experience", _viewModel.yearsOfExperienceController),
                _buildTextField("Employment Type", _viewModel.employmentTypeController),
                _buildTextField("Salary Range", _viewModel.salaryRangeController),
                _buildTextField("Skills (Technical + Soft)", _viewModel.skillsController, maxLines: 2),
                _buildTextField("Tools & Technologies", _viewModel.toolsTechnologiesController),
                _buildTextField("Certifications", _viewModel.certificationsController, maxLines: 2),
              ]),

              _buildSection("Career Growth", [
                _buildTextField("Desired Next Job Role", _viewModel.desiredNextJobRoleController),
                _buildTextField("Long-Term Career Goal", _viewModel.longTermCareerGoalController, maxLines: 2),
                _buildTextField("Industry Interest", _viewModel.industryInterestController),
              ]),

              _buildSection("Work History", [
                _buildTextField("Work History Details", _viewModel.workHistoryDetailsController, maxLines: 4),
              ]),
              
              const SizedBox(height: 30),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF8BA989))),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: Column(children: children),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.purple),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF4E6E58))),
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
