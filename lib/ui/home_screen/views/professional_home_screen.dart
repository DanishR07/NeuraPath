import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:fyp/ui/home_screen/view_models/professional_home_vm.dart';
import 'package:get/get.dart';

import '../../../data/repositories/auth_repository.dart';

class ProfessionalHomeScreen extends StatefulWidget {
  const ProfessionalHomeScreen({super.key});

  @override
  State<ProfessionalHomeScreen> createState() => _ProfessionalHomeScreenState();
}

class _ProfessionalHomeScreenState extends State<ProfessionalHomeScreen> {
  late ProfessionalHomeViewModel homeViewModel;

  int currentIndex = 0;
  var userData;
  bool isLoadingUser = true;

  @override
  void initState() {
    super.initState();
    homeViewModel = Get.find<ProfessionalHomeViewModel>();
    loadUser();
  }

  Future<void> loadUser() async {
    userData = await homeViewModel.getCurrentUser();
    setState(() {
      isLoadingUser = false;
    });
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
              decoration: const BoxDecoration(
                color: Color(0xFF8BA989),
              ),
              child: isLoadingUser
                  ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: userData?.profileImageUrl != null
                        ? NetworkImage(userData!.profileImageUrl!)
                        : null,
                    child: userData?.profileImageUrl == null
                        ? const Icon(Icons.person, size: 35)
                        : null,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${userData?.firstName ?? ''} ${userData?.lastName ?? ''}'.trim().isNotEmpty
                        ? '${userData?.firstName ?? ''} ${userData?.lastName ?? ''}'.trim()
                        : 'User',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userData?.email ?? 'email@example.com',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
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
          const Center(child: Text("Professional Home Content")),
          const Center(child: Text('Chat')),
          const Center(child: Text('Profile')),
        ][currentIndex],
      ),
    );
  }
}

class ProfessionalHomeScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthRepository());
    Get.put(ProfessionalHomeViewModel());
  }
}
