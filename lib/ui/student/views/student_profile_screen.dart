import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view_models/student_profile_view_model.dart';
import 'edit_student_profile_screen.dart';

class StudentProfileScreen extends StatelessWidget {
  final StudentProfileViewModel _viewModel = Get.put(StudentProfileViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("My Profile", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Color(0xFF4E6E58)),
            onPressed: () => Get.to(() => EditStudentProfileScreen()),
          ),
        ],
      ),
      body: Obx(() {
        if (_viewModel.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF8BA989)));
        }

        final user = _viewModel.user.value;
        final profile = _viewModel.studentProfile.value;

        if (user == null) return const Center(child: Text("User not found"));

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header & Progress
              _buildHeader(user, _viewModel.completionPercentage.value),
              const SizedBox(height: 24),

              // 1. Academic Info
              _buildSectionTitle("Academic Information"),
              _buildInfoCard([
                _buildInfoRow("University", profile?.university),
                _buildInfoRow("Degree", profile?.currentDegree),
                _buildInfoRow("Major", profile?.major),
                _buildInfoRow("Semester/Year", profile?.semesterYear),
                _buildInfoRow("CGPA", profile?.cgpa),
                _buildInfoRow("Graduation", profile?.expectedGraduationYear),
                _buildInfoRow("Projects", profile?.projectsCompleted),
                _buildInfoRow("Preferred Domains", profile?.preferredIndustryDomains),
              ]),

              // 2. Skills
              _buildSectionTitle("Skills"),
              _buildInfoCard([
                _buildInfoRow("Technical", profile?.technicalSkills),
                _buildInfoRow("Soft Skills", profile?.softSkills),
                _buildInfoRow("Languages", profile?.programmingLanguages),
                _buildInfoRow("Tools", profile?.toolsTechnologies),
              ]),

              // 3. Career Interests
              _buildSectionTitle("Career Interests"),
              _buildInfoCard([
                _buildInfoRow("Fields", profile?.preferredCareerFields),
                _buildInfoRow("Target Roles", profile?.targetJobRoles),
                _buildInfoRow("Work Type", profile?.preferredWorkType),
                _buildInfoRow("Locations", profile?.preferredLocations),
              ]),

              // 4. Experience
              _buildSectionTitle("Experience"),
              _buildInfoCard([
                _buildInfoRow("Internships", profile?.internships),
                _buildInfoRow("Part-time Jobs", profile?.partTimeJobs),
              ]),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeader(user, double progress) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: const Color(0xFF8BA989).withOpacity(0.2),
            backgroundImage: (user.profileImageUrl != null && user.profileImageUrl!.isNotEmpty)
                ? NetworkImage(user.profileImageUrl!)
                : null,
            child: (user.profileImageUrl == null || user.profileImageUrl!.isEmpty)
                ? const Icon(Icons.person, size: 40, color: Color(0xFF4E6E58))
                : null,
          ),
          const SizedBox(height: 16),
          Text("${user.firstName} ${user.lastName}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text("Student", style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Profile Completion", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  Text("${(progress * 100).toInt()}%", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF4E6E58))),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[200],
                color: const Color(0xFF4E6E58),
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 12, left: 4),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF4E6E58))),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    // Filter out empty rows
    final validChildren = children.where((w) => w is! SizedBox).toList();
    if (validChildren.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Text("No information added yet.", style: TextStyle(color: Colors.grey[500], fontStyle: FontStyle.italic)),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: validChildren),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Divider(color: Colors.grey[100], height: 1),
        ],
      ),
    );
  }
}
