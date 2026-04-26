import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../customs.dart';
import '../view_models/student_profile_view_model.dart';

class EditStudentProfileScreen extends StatefulWidget {
  @override
  State<EditStudentProfileScreen> createState() => _EditStudentProfileScreenState();
}

class _EditStudentProfileScreenState extends State<EditStudentProfileScreen> {
  final StudentProfileViewModel _viewModel = Get.find<StudentProfileViewModel>();

  // Dropdown Lists
  final List<String> educationLevels = ["Matric", "Intermediate", "University"];
  
  final List<String> matricMajors = ["Science (Biology)", "Science (Computer)", "Arts", "Other"];
  final List<String> interMajors = ["Pre-Engineering", "Pre-Medical", "ICS (Physics)", "ICS (Stats)", "ICOM", "FA", "Other"];
  final List<String> uniMajors = ["Computer Science", "Information Technology", "Software Engineering", "Electrical Engineering", "BBA", "Mechanical Engineering", "Psychology", "Other"];

  // Visibility states for "Other" text fields
  bool showOtherInstitution = false;
  bool showOtherMajor = false;
  bool showOtherDegree = false;

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
        
        final level = _viewModel.educationLevel.value;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStepTitle("Select Education Level"),
              _buildEducationToggle(),
              const SizedBox(height: 24),

              _buildSection("Academic Details", [
                _buildDropdownField(
                  label: level == "University" ? "Select University" : (level == "Matric" ? "Select School" : "Select College"),
                  value: _viewModel.institutionController.text,
                  items: level == "University" 
                    ? ["NUST", "FAST-NUCES", "PU", "COMSATS", "UET", "LUMS", "Other"]
                    : ["Government School/College", "Private School/College", "Other"],
                  onChanged: (val) {
                    setState(() {
                      showOtherInstitution = val == "Other";
                      _viewModel.institutionController.text = val!;
                    });
                  },
                ),
                if (showOtherInstitution)
                  _buildTextField("Enter Institution Name", _viewModel.institutionController),

                _buildDropdownField(
                  label: "Major / Field",
                  value: _viewModel.majorController.text,
                  items: level == "Matric" ? matricMajors : (level == "Intermediate" ? interMajors : uniMajors),
                  onChanged: (val) {
                    setState(() {
                      showOtherMajor = val == "Other";
                      _viewModel.majorController.text = val!;
                    });
                  },
                ),
                if (showOtherMajor)
                  _buildTextField("Enter Your Major", _viewModel.majorController),

                if (level == "University") ...[
                  _buildDropdownField(
                    label: "Degree Type",
                    value: _viewModel.degreeController.text,
                    items: ["BS", "MS", "PhD", "AD", "Other"],
                    onChanged: (val) {
                      setState(() {
                        showOtherDegree = val == "Other";
                        _viewModel.degreeController.text = val!;
                      });
                    },
                  ),
                  if (showOtherDegree)
                    _buildTextField("Enter Degree Title", _viewModel.degreeController),
                  
                  _buildTextField("Current Semester / Year", _viewModel.semesterYearController),
                  _buildTextField("CGPA", _viewModel.cgpaController, keyboardType: TextInputType.number),
                ] else ...[
                  Row(
                    children: [
                      Expanded(child: _buildTextField("Total Marks", _viewModel.totalMarksController, keyboardType: TextInputType.number)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildTextField("Obtained Marks", _viewModel.obtainedMarksController, keyboardType: TextInputType.number)),
                    ],
                  ),
                ],
              ]),

              if (level == "University")
                _buildSection("Skills", [
                  _buildTextField("Technical Skills (e.g. Python, Flutter)", _viewModel.technicalSkillsController, maxLines: 2),
                ])
              else
                _buildSection("Interest Areas", [
                  _buildTextField("Favorite Subjects (e.g. Math, Physics)", _viewModel.favoriteSubjectsController, maxLines: 2),
                ]),

              _buildSection("Future Goals", [
                _buildTextField("Preferred Career Fields (e.g. AI, Medical, Arts)", _viewModel.preferredCareerFieldsController),
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

  Widget _buildEducationToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[200]!)),
      child: Row(
        children: educationLevels.map((level) {
          final isSelected = _viewModel.educationLevel.value == level;
          return Expanded(
            child: GestureDetector(
              onTap: () => _viewModel.educationLevel.value = level,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryGreen : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    level,
                    style: TextStyle(color: isSelected ? Colors.white : Colors.black54, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
                  ),
                ),
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
          labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
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
          labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
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

