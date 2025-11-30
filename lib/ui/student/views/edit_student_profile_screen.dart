import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view_models/student_profile_view_model.dart';

class EditStudentProfileScreen extends StatelessWidget {
  final StudentProfileViewModel _viewModel = Get.find<StudentProfileViewModel>();

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
            child: const Text("Save", style: TextStyle(color: Color(0xFF4E6E58), fontWeight: FontWeight.bold, fontSize: 16)),
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
              _buildSection("Academic Information", [
                _buildTextField("University / College", _viewModel.universityController),
                _buildTextField("Current Degree", _viewModel.currentDegreeController),
                _buildTextField("Major / Field of Study", _viewModel.majorController),
                _buildTextField("Semester / Year", _viewModel.semesterYearController),
                _buildTextField("CGPA / Percentage", _viewModel.cgpaController),
                _buildTextField("Expected Graduation Year", _viewModel.expectedGraduationYearController),
                _buildTextField("Projects Completed", _viewModel.projectsCompletedController, maxLines: 3),
                _buildTextField("Preferred Industry Domains", _viewModel.preferredIndustryDomainsController),
              ]),

              _buildSection("Skills", [
                _buildTextField("Technical Skills", _viewModel.technicalSkillsController, maxLines: 2),
                _buildTextField("Soft Skills", _viewModel.softSkillsController, maxLines: 2),
                _buildTextField("Programming Languages", _viewModel.programmingLanguagesController),
                _buildTextField("Tools & Technologies", _viewModel.toolsTechnologiesController),
              ]),

              _buildSection("Career Interests", [
                _buildTextField("Preferred Career Fields", _viewModel.preferredCareerFieldsController),
                _buildTextField("Target Job Roles", _viewModel.targetJobRolesController),
                _buildTextField("Preferred Work Type", _viewModel.preferredWorkTypeController),
                _buildTextField("Preferred Locations", _viewModel.preferredLocationsController),
              ]),

              _buildSection("Experience", [
                _buildTextField("Internships", _viewModel.internshipsController, maxLines: 3),
                _buildTextField("Part-time Jobs", _viewModel.partTimeJobsController, maxLines: 3),
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
          child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF4E6E58))),
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
