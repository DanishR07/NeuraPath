import 'package:flutter/material.dart';
import 'package:fyp/ui/home_screen/view_models/home_vm.dart';
import 'package:get/get.dart';

import '../../../colors.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final HomeViewModel homeViewModel = Get.put(HomeViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: AppColors.primaryGreen),
              child: Text(
                'CareerCompass',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            Obx(() {
              return homeViewModel.isLoading.value
                  ? const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: Text('Logging out...')),
              )
                  : ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Confirm Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close dialog
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            homeViewModel.logout();
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Logout',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ],
        ),
      ),
      body: const Center(child: Text('Home Page')),
    );
  }
}
