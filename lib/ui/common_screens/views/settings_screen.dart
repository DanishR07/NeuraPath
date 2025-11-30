import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../custom_widgets/build_section_header.dart';
import '../../custom_widgets/build_setting_tile.dart';
import '../view_models/settings_view_model.dart';

class SettingsScreen extends StatelessWidget {
  final SettingsViewModel _viewModel = Get.put(SettingsViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 10,
              ),
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
                    "Settings",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  buildSectionHeader("Account"),
                  buildSettingsTile(
                    icon: Icons.person_outline,
                    title: "Edit Profile",
                    onTap: () => _viewModel.navigateToEditProfile(),
                  ),
                  buildSettingsTile(
                    icon: Icons.notifications_outlined,
                    title: "Notifications",
                    onTap: () => _viewModel.navigateToNotifications(),
                  ),
                  buildSettingsTile(
                    icon: Icons.lock_outline,
                    title: "Privacy & Security",
                    onTap: () => _viewModel.navigateToPrivacySecurity(),
                  ),
                  const SizedBox(height: 24),
                  buildSectionHeader("Support"),
                  buildSettingsTile(
                    icon: Icons.help_outline,
                    title: "Help & Support",
                    onTap: () => _viewModel.navigateToHelpSupport(),
                  ),
                  buildSettingsTile(
                    icon: Icons.info_outline,
                    title: "About App",
                    onTap: () => _viewModel.navigateToAboutApp(),
                  ),
                  const SizedBox(height: 64),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: GestureDetector(
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
                                  await _viewModel.logout();
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.keyboard_backspace, size: 20,color: Colors.red,),
                          SizedBox(width: 1.5),
                          Container(
                            width: 1.4,
                            height: 15,
                            color: Colors.black,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Log out",
                            style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
