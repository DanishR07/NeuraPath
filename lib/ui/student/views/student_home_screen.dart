import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:fyp/ui/common_screens/views/ai_chat_screen.dart';
import 'package:fyp/ui/common_screens/views/settings_screen.dart';
import 'package:fyp/ui/resume_enhancer/views/resume_upload_screen.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/profile_repository.dart';
import '../../custom_widgets/feature_card.dart';
import '../view_models/student_home_vm.dart';
import 'student_profile_screen.dart';
import 'career_recommendation_screen.dart';
import '../../common_screens/views/skill_insight_screen.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  late StudentHomeViewModel homeViewModel;
  final box = GetStorage();
  int currentIndex = 0;
  String? cachedName;
  String? liveName;
  bool loadingUser = true;
  
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    homeViewModel = Get.find<StudentHomeViewModel>();
    cachedName = box.read("firstName");
    loadUser();
  }


  Future<void> loadUser() async {
    try {
      final user = await homeViewModel.getCurrentUser();
      liveName = user?.firstName;
      if (liveName != null && liveName!.isNotEmpty) {
        box.write("firstName", liveName);
      }
    } catch (_) {
    }
    setState(() => loadingUser = false);
  }

  @override
  Widget build(BuildContext context) {
    final displayName = liveName ?? cachedName ?? "Guest";

    final pages = [
      homeSection(displayName),
      AIChatScreen(),
      SettingsScreen(),
      StudentProfileScreen(),
    ];

    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: const Color(0xFFF5F5F5),
        animationDuration: const Duration(milliseconds: 400),
        height: 60,
        index: currentIndex,
        onTap: (index) {
          _searchFocusNode.unfocus();
          setState(() => currentIndex = index);
        },
        items: [
          Icon(
            Icons.home,
            color: currentIndex == 0 ? Colors.black : Color(0xFF8BA989),
          ),
          Icon(
            Icons.messenger_outline,
            color: currentIndex == 1 ? Colors.black : Color(0xFF8BA989),
          ),
          Icon(
            Icons.settings,
            color: currentIndex == 2 ? Colors.black : Color(0xFF8BA989),
          ),
          Icon(
            Icons.account_circle_outlined,
            color: currentIndex == 3 ? Colors.black : Color(0xFF8BA989),
          ),
        ],
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => _searchFocusNode.unfocus(),
          behavior: HitTestBehavior.opaque,
          child: pages[currentIndex],
        ),
      ),

    );
  }

  Widget homeSection(String displayName) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 18.0, bottom: 10,top: 20,right: 18),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Color(0xFF8BA989).withOpacity(.5)),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.waving_hand,
                    color: Color(0xFF8BA989),
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Hello, ",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    displayName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4E6E58),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: SearchBar(
                controller: _searchController,
                focusNode: _searchFocusNode,
                leading: const Icon(Icons.search, color: Color(0xFF8BA989)),
                hintText: "Search tasks or modules...",
                hintStyle: WidgetStatePropertyAll(
                  TextStyle(color: Colors.black54, fontSize: 14),
                ),
                elevation: const WidgetStatePropertyAll(0),
                backgroundColor: WidgetStatePropertyAll(
                  Colors.white.withOpacity(0.15),
                ),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Color(0xFF8BA989).withOpacity(.5)),
                  ),
                ),
                onChanged: (value) {
                   // Add search logic here later
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Student Modules",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: _searchController,
                builder: (context, value, child) {
                  final query = value.text.toLowerCase();
                  final modules = [
                    {
                      "title": "AI Career Intelligence Engine",
                      "subtitle": "Get personalized career path recommendations based on your current academic background.",
                      "icon": Icons.psychology,
                      "onTap": () => Get.to(() => CareerRecommendationScreen()),
                    },
                    {
                      "title": "Smart Resume Enhancer",
                      "subtitle": "Optimize your resume for ATS compliance and get tailored improvement suggestions.",
                      "icon": Icons.description,
                      "onTap": () => Get.to(() => ResumeUploadScreen()),
                    },
                    {
                      "title": "Skill Insight & Learning Advisor",
                      "subtitle": "Identify skill gaps and receive recommendations for top courses and certifications.",
                      "icon": Icons.school_outlined,
                      "onTap": () => Get.to(() => SkillInsightScreen()),
                    },
                  ];

                  final filteredModules = modules.where((m) {
                    return (m['title'] as String).toLowerCase().contains(query) ||
                           (m['subtitle'] as String).toLowerCase().contains(query);
                  }).toList();

                  if (filteredModules.isEmpty) {
                    return const Center(child: Text("No modules found."));
                  }

                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: filteredModules.length,
                    itemBuilder: (context, index) {
                      final m = filteredModules[index];
                      return buildModuleContainer(
                        context,
                        title: m['title'] as String,
                        subtitle: m['subtitle'] as String,
                        icon: m['icon'] as IconData,
                        color: const Color(0xFF8BA989),
                        onTap: m['onTap'] as VoidCallback,
                      );
                    },
                  );
                },
              ),
            ),


          ],
        ),
      ),
    );
  }
}

class StudentHomeScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthRepository());
    Get.put(ProfileRepository());
    Get.put(StudentHomeViewModel());
  }

}
