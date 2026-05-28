import 'package:dio_todo_llist/Screens/routes/app_routes.dart';
import 'package:dio_todo_llist/core/api/auth_service.dart';
import 'package:dio_todo_llist/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

part 'setting_binding.dart';
part 'setting_controller.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_back, color: Colors.black, size: 20),
          ),
        ),
        title: Text(
          "Setting",
          style: GoogleFonts.spaceGrotesk(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: Obx(
        () => controller.isLoading.value
            ? Center(child: CircularProgressIndicator(color: Colors.black))
            : SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16),

                    Center(
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 48,
                                backgroundImage: NetworkImage(controller.user.avatar),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                  child: Icon(Icons.camera_alt, color: Colors.white, size: 14),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Text(
                            controller.user.name.toUpperCase(),
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            controller.user.email,
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 13,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 32),
                    _sectionLabel("PERSONAL INFORMATION"),
                    SizedBox(height: 8),
                    _settingItem(
                      icon: Icons.person_outline,
                      title: "Change Name",
                      subtitle: "Change your full name",
                      onTap: () => controller.showChangeNameDialog(),
                    ),
                    _divider(),
                    _settingItem(
                      icon: Icons.email_outlined,
                      title: "Change Email",
                      subtitle: "Change your email address",
                      onTap: () => controller.showChangeEmailDialog(),
                    ),
                    _divider(),
                    _settingItem(
                      icon: Icons.lock_outline,
                      title: "Change Password",
                      subtitle: "Change your password",
                      onTap: () => controller.showChangePasswordDialog(),
                    ),

                    SizedBox(height: 24),

                    _sectionLabel("GENERAL"),
                    SizedBox(height: 8),
                    _settingItem(
                      icon: Icons.dark_mode_outlined,
                      title: "Dark Theme",
                      subtitle: "Change your full name",
                      onTap: () {},
                    ),
                    _divider(),
                    _settingItem(
                      icon: Icons.language_outlined,
                      title: "Language",
                      subtitle: "Change your email address",
                      onTap: () {},
                    ),
                    _divider(),
                    _settingItem(
                      icon: Icons.help_outline,
                      title: "FAQ",
                      subtitle: "Change your password",
                      onTap: () {},
                    ),

                    SizedBox(height: 24),

                    _sectionLabel("LEGAL"),
                    SizedBox(height: 8),
                    _settingItem(
                      icon: Icons.privacy_tip_outlined,
                      title: "Data Privacy",
                      subtitle: "Change your full name",
                      onTap: () {},
                    ),
                    _divider(),
                    _settingItem(
                      icon: Icons.description_outlined,
                      title: "Term & Condition",
                      subtitle: "Change your email address",
                      onTap: () {},
                    ),
                    SizedBox(height: 24),
                    _settingItem(
                      icon: Icons.logout,
                      title: "Logout",
                      subtitle: "Change your full name",
                      onTap: () => controller.logout(),
                      isRed: true,
                    ),

                    SizedBox(height: 40),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.spaceGrotesk(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: Colors.black54,
        letterSpacing: 1.1,
      ),
    );
  }

  Widget _divider() {
    return Divider(height: 1, color: Colors.black12, indent: 48);
  }

  Widget _settingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isRed = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: isRed ? Colors.red : Colors.black54,
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isRed ? Colors.red : Colors.black,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 12,
                    color: isRed ? Colors.red.shade200 : Colors.black45,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}