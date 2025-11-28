import 'package:flutter/material.dart';
import 'package:fyp/ui/home_screen/view_models/home_vm.dart';
import 'package:get/get.dart';

import '../../../data/repositories/auth_repository.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeViewModel homeViewModel;

  @override
  void initState() {
    super.initState();
    homeViewModel = Get.find();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                Get.dialog(
                  AlertDialog(
                    title: Text('Confirm logout!'),
                    content: Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text('No'),
                      ),
                      TextButton(
                        onPressed: () async {
                          await homeViewModel.confirmLogout();
                        },
                        child: Text(
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
      body: const Center(child: Text('Home Screen')),
    );
  }
}
class HomeScreenBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(AuthRepository());
    Get.put(HomeViewModel());
  }
}