import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/repositories/auth_repository.dart';
import '../view_models/student_home_vm.dart';

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
      const Center(child: Text("AI Chat")),
      const Center(child: Text("Settings")),
      const Center(child: Text("Profile")),
    ];

    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: const Color(0xFFF5F5F5),
        animationDuration: const Duration(milliseconds: 400),
        height: 60,
        index: currentIndex,
        onTap: (index) {
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
      body: SafeArea(child: pages[currentIndex]),
    );
  }

  Widget homeSection(String displayName) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 18.0, bottom: 10,top: 20,right: 18),
        child: Column(
          children: [
            const SizedBox(height: 10),
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
            const SizedBox(height: 19),
            SizedBox(
              width: 300,
              child: SearchBar(
                leading: const Icon(Icons.search, color: Color(0xFF8BA989)),
                hintText: "Search...",
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
              ),
            ),
            const SizedBox(height: 20),
            const Text("Student section"),
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
    Get.put(StudentHomeViewModel());
  }
}
