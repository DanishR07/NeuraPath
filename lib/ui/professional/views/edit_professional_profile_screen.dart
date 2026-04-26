import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view_models/professional_profile_view_model.dart';

class AppColors {
  static const Color primaryGreen = Color(0xFF8BA989);
}

class EditProfessionalProfileScreen extends StatefulWidget {
  @override
  State<EditProfessionalProfileScreen> createState() => _EditProfessionalProfileScreenState();
}

class _EditProfessionalProfileScreenState extends State<EditProfessionalProfileScreen> {
  final ProfessionalProfileViewModel _viewModel = Get.find<ProfessionalProfileViewModel>();

  final List<String> jobLevels = ["Senior/Specialist", "Management/Lead", "Director/Executive","Other"];
  final List<String> industries = ["Software & IT", "Finance", "Healthcare", "Education", "Marketing", "Other"];
  final List<String> salaryRanges = ["50k - 100k", "100k - 200k", "200k - 500k", "500k+", "Other"];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          title: const Text("Professional Profile", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
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

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStepTitle("Current Job Level"),
                _buildLevelToggle(),
                const SizedBox(height: 24),

                _buildSection("Current Position", [
                  _buildTextField("Current Job Title", _viewModel.currentJobTitleController),
                  _buildTextField("Current Company", _viewModel.currentCompanyController),
                  _buildTextField("Total Experience (Years)", _viewModel.yearsOfExperienceController, keyboardType: TextInputType.number),
                ]),

                _buildSection("Expertise & Industry", [
                  _buildTextField("Core Professional Skills", _viewModel.skillsController, maxLines: 2),
                  _buildTextField("Top Certifications", _viewModel.certificationsController),
                  _buildDropdownField(
                    label: "Primary Industry",
                    value: _viewModel.industryController.text,
                    items: industries,
                    onChanged: (val) => _viewModel.industryController.text = val!,
                  ),
                ]),

                _buildSection("Career Goals", [
                  _buildTextField("Career Goal / Mission", _viewModel.careerGoalController, maxLines: 2),
                  _buildDropdownField(
                    label: "Gross Salary Range (Monthly)",
                    value: _viewModel.salaryRangeController.text,
                    items: salaryRanges,
                    onChanged: (val) => _viewModel.salaryRangeController.text = val!,
                  ),
                ]),

                const SizedBox(height: 40),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStepTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
    );
  }

  Widget _buildLevelToggle() {
    // Check if current value is one of the standard list items
    bool isOtherSelected = _viewModel.jobLevelController.text.isNotEmpty && 
                           !jobLevels.take(3).contains(_viewModel.jobLevelController.text);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[200]!)),
          child: Column(
            children: jobLevels.map((lvl) {
              bool isSelected;
              if (lvl == "Other") {
                isSelected = isOtherSelected;
              } else {
                isSelected = _viewModel.jobLevelController.text == lvl;
              }

              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (lvl == "Other") {
                      if (!isOtherSelected) _viewModel.jobLevelController.clear();
                    } else {
                      _viewModel.jobLevelController.text = lvl;
                    }
                  });
                },
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
                       Icon(isSelected ? Icons.verified : Icons.circle_outlined, color: isSelected ? Colors.white : Colors.grey, size: 20),
                       const SizedBox(width: 12),
                       Text(lvl, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        if (isOtherSelected || (_viewModel.jobLevelController.text.isEmpty && jobLevels.last == "Other"))
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: _buildTextField("Enter Custom Job Level", _viewModel.jobLevelController),
          ),
      ],
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
