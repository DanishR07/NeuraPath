import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:fyp/ui/job_seeker/view_models/job_seeker_home_vm.dart';
import 'package:fyp/ui/student/view_models/student_home_vm.dart';
import 'package:get/get.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../model/user_model.dart';
import '../../../services/connectivity_service.dart';

class JobSeekerHomeScreen extends StatefulWidget {
  const JobSeekerHomeScreen({super.key});

  @override
  State<JobSeekerHomeScreen> createState() => _JobSeekerHomeScreenState();
}

class _JobSeekerHomeScreenState extends State<JobSeekerHomeScreen> {
  late JobSeekerHomeViewModel homeViewModel;

  int currentIndex = 0;
  String role = "Job Seeker";

  @override
  void initState() {
    super.initState();
    homeViewModel = Get.find<JobSeekerHomeViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: const Color(0xFF8BA989),
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF8BA989)),
              child: Text(
                '$role Dashboard',
                style: const TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {},
            ),

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {},
            ),

            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {},
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Get.dialog(
                  AlertDialog(
                    title: const Text('Confirm logout!'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text('No'),
                      ),

                      TextButton(
                        onPressed: () async {
                          await homeViewModel.confirmLogout();
                        },
                        child: const Text(
                          'Yes',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),

      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Color(0xFFF5F5F5),
        animationDuration: Duration(milliseconds: 400),
        height: 60,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          Icon(Icons.home, color: const Color(0xFF8BA989)),
          Icon(Icons.messenger_outline, color: const Color(0xFF8BA989)),
          Icon(Icons.account_circle_outlined, color: const Color(0xFF8BA989)),
        ],
      ),

      body: Center(
        child: [
          const Center(child: Text("Job Seeker Home Content")),
          const Center(child: Text('Chat')),
          const Center(child: Text('Profile')),
        ][currentIndex],
      ),
    );
  }
}

class JobSeekerHomeScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthRepository());
    Get.put(JobSeekerHomeViewModel());
  }
}

class JobSeekerHomeViewModel extends GetxController {
  AuthRepository authRepository = Get.find();
  var isLoading = false.obs;

  Future<UserModel?> getCurrentUser() async {
    return await authRepository.getCurrentUser();
  }

  Future<void> confirmLogout() async {
    final hasInternet = await ConnectivityService.hasInternetConnection();
    if (!hasInternet) {
      Get.snackbar("No Internet", ConnectivityService.getNoInternetMessage(), backgroundColor: Colors.red);
      return;
    }

    try {
      Get.back();
      await authRepository.logout();
      Get.offAllNamed('/login_screen');
      Get.snackbar('Logout', "Logged out successfully", backgroundColor: Colors.green);
    } catch (e) {
      Get.snackbar('Error', "Failed to logout: ${e.toString()}", backgroundColor: Colors.red);
    }
  }
}
