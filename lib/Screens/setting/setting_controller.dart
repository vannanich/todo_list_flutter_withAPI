part of 'setting_view.dart';

class SettingController extends GetxController {
  var authService = AuthService();
  var box = GetStorage();

  var isLoading = false.obs;
  var isUpdating = false.obs;

  var user = UserModel(id: "", name: "", avatar: "", email: "").obs;

  @override
  void onInit() {
    super.onInit();
    getProfile();
  }

  void getProfile() async {
    try {
      isLoading.value = true;
      var response = await authService.fixProfile();
      isLoading.value = false;
      if (response["data"] != null) {
        user.value = UserModel.fromMap(response["data"]);
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint("getProfile error: ${e.toString()}");
    }
  }

  Widget _buildDialogShell({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    required Widget body,
    required List<Widget> actions,
  }) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28),
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: iconColor.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(icon, color: iconColor, size: 28),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: body,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Row(
                children: actions
                    .map((e) => Expanded(child: e))
                    .toList()
                    .expand((e) => [e, const SizedBox(width: 10)])
                    .toList()
                  ..removeLast(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController ctrl,
    required String hint,
    required IconData icon,
    bool obscure = false,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F7),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: ctrl,
        obscureText: obscure,
        keyboardType: keyboard,
        style: GoogleFonts.spaceGrotesk(fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.spaceGrotesk(
            color: Colors.grey.shade400,
            fontSize: 14,
          ),
          prefixIcon: Icon(icon, color: Colors.grey.shade400, size: 20),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _cancelBtn() {
    return OutlinedButton(
      onPressed: () => Get.back(),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        side: BorderSide(color: Colors.grey.shade300),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: Text(
        "Cancel",
        style: GoogleFonts.spaceGrotesk(
          color: Colors.black54,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _saveBtn({
    required Color color,
    required String label,
    required VoidCallback? onTap,
  }) {
    return Obx(
      () => ElevatedButton(
        onPressed: isUpdating.value ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 14),
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: isUpdating.value
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              )
            : Text(
                label,
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }

  void logout() {
    Get.dialog(
      _buildDialogShell(
        icon: Icons.logout_rounded,
        iconColor: Colors.red,
        iconBg: const Color(0xFFE53935),
        title: "Logout",
        subtitle: "We'll miss you!",
        body: Text(
          "Are you sure you want to logout from your account?",
          textAlign: TextAlign.center,
          style: GoogleFonts.spaceGrotesk(
            color: Colors.black54,
            fontSize: 14,
            height: 1.5,
          ),
        ),
        actions: [
          _cancelBtn(),
          ElevatedButton(
            onPressed: () {
              box.remove("token");
              Get.offAllNamed(AppRoutes.login);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 14),
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            child: Text(
              "Logout",
              style: GoogleFonts.spaceGrotesk(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showChangeNameDialog() {
    final nameCtrl = TextEditingController(text: user.value.name);
    Get.dialog(
      _buildDialogShell(
        icon: Icons.badge_rounded,
        iconColor: const Color(0xFF6C63FF),
        iconBg: const Color(0xFF6C63FF),
        title: "Change Name",
        subtitle: "Update your display name",
        body: _buildField(
          ctrl: nameCtrl,
          hint: "Enter your full name",
          icon: Icons.person_outline_rounded,
        ),
        actions: [
          _cancelBtn(),
          _saveBtn(
            color: const Color(0xFF6C63FF),
            label: "Save",
            onTap: () async {
              if (nameCtrl.text.isEmpty) {
                Get.snackbar("Failed", "Name cannot be empty");
                return;
              }
              try {
                isUpdating.value = true;
                var response =
                    await authService.updateName(name: nameCtrl.text);
                isUpdating.value = false;
                if (response["result"] == true) {
                  user.value.name = nameCtrl.text;
                  Get.back();
                  Get.snackbar("Success", "Name updated");
                  getProfile();
                } else {
                  Get.snackbar("Failed", "Could not update name");
                }
              } catch (e) {
                isUpdating.value = false;
                Get.snackbar("Failed", "Something went wrong");
                debugPrint("Update name error: ${e.toString()}");
              }
            },
          ),
        ],
      ),
    );
  }

  void showChangeEmailDialog() {
    final emailCtrl = TextEditingController(text: user.value.email);
    final currentPassCtrl = TextEditingController();
    Get.dialog(
      _buildDialogShell(
        icon: Icons.mail_rounded,
        iconColor: const Color(0xFF00897B),
        iconBg: const Color(0xFF00897B),
        title: "Change Email",
        subtitle: "Verify your identity first",
        body: Column(
          children: [
            _buildField(
              ctrl: currentPassCtrl,
              hint: "Current password",
              icon: Icons.lock_outline_rounded,
              obscure: true,
            ),
            const SizedBox(height: 12),
            _buildField(
              ctrl: emailCtrl,
              hint: "New email address",
              icon: Icons.mail_outline_rounded,
              keyboard: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          _cancelBtn(),
          _saveBtn(
            color: const Color(0xFF00897B),
            label: "Update",
            onTap: () async {
              if (currentPassCtrl.text.isEmpty) {
                Get.snackbar("Failed", "Current password cannot be empty");
                return;
              }
              if (currentPassCtrl.text.length < 8) {
                Get.snackbar("Failed", "Password must be at least 8 characters");
                return;
              }
              if (emailCtrl.text.isEmpty) {
                Get.snackbar("Failed", "Email cannot be empty");
                return;
              }
              try {
                isUpdating.value = true;
                var response = await authService.updateEmail(
                  email: emailCtrl.text,
                  currentPass: currentPassCtrl.text,
                );
                isUpdating.value = false;
                if (response["result"] == true) {
                  user.value.email = emailCtrl.text;
                  Get.back();
                  Get.snackbar("Success", "Email updated");
                  getProfile();
                } else {
                  Get.snackbar("Failed", "Could not update email");
                }
              } catch (e) {
                isUpdating.value = false;
                Get.snackbar("Failed", "Something went wrong");
                debugPrint("Update email error: ${e.toString()}");
              }
            },
          ),
        ],
      ),
    );
  }

  void showChangePasswordDialog() {
    final passCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    Get.dialog(
      _buildDialogShell(
        icon: Icons.shield_rounded,
        iconColor: const Color(0xFFF57C00),
        iconBg: const Color(0xFFF57C00),
        title: "Change Password",
        subtitle: "Keep your account secure",
        body: Column(
          children: [
            _buildField(
              ctrl: passCtrl,
              hint: "New password",
              icon: Icons.lock_outline_rounded,
              obscure: true,
            ),
            const SizedBox(height: 12),
            _buildField(
              ctrl: confirmCtrl,
              hint: "Confirm new password",
              icon: Icons.lock_reset_rounded,
              obscure: true,
            ),
          ],
        ),
        actions: [
          _cancelBtn(),
          _saveBtn(
            color: const Color(0xFFF57C00),
            label: "Update",
            onTap: () async {
              if (passCtrl.text.isEmpty || confirmCtrl.text.isEmpty) {
                Get.snackbar("Failed", "All fields are required");
                return;
              }
              if (passCtrl.text.length < 8) {
                Get.snackbar("Failed", "Password must be at least 8 characters");
                return;
              }
              if (passCtrl.text != confirmCtrl.text) {
                Get.snackbar("Failed", "Passwords do not match");
                return;
              }
              try {
                isUpdating.value = true;
                var response =
                    await authService.updatePassword(password: passCtrl.text);
                isUpdating.value = false;
                if (response["result"] == true) {
                  Get.back();
                  Get.snackbar("Success", "Password updated");
                } else {
                  Get.snackbar("Failed", "Could not update password");
                }
              } catch (e) {
                isUpdating.value = false;
                Get.snackbar("Failed", "Something went wrong");
                debugPrint("Update password error: ${e.toString()}");
              }
            },
          ),
        ],
      ),
    );
  }
}