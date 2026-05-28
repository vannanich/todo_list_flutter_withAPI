part of 'setting_view.dart';

class SettingController extends GetxController {
  var authService = AuthService();
  var box = GetStorage();

  var isLoading = false.obs;
  var isUpdating = false.obs;

  // ── FIX: initialize with empty user instead of late ──
  var user = UserModel(id: "", name: "", avatar: "", email: "").obs;

  @override
  void onInit() {
    super.onInit();
    getProfile();
  }

  // ── FIX: wrap in try/catch + null check ──
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

  // ── KEPT EXACTLY THE SAME ──
  void logout() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Logout",
            style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w700)),
        content: Text("Are you sure you want to logout?",
            style: GoogleFonts.spaceGrotesk(color: Colors.black54)),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Cancel",
                style: GoogleFonts.spaceGrotesk(color: Colors.black)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              box.remove("token");
              Get.offAllNamed(AppRoutes.login);
            },
            child: Text("Logout",
                style: GoogleFonts.spaceGrotesk(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ── KEPT EXACTLY THE SAME ──
  void showChangeNameDialog() {
    final nameCtrl = TextEditingController(text: user.value.name);
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Change Name",
            style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w700)),
        content: TextField(
          controller: nameCtrl,
          decoration: InputDecoration(
            hintText: "Enter your full name",
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Cancel",
                style: GoogleFonts.spaceGrotesk(color: Colors.black)),
          ),
          Obx(
            () => ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: isUpdating.value
                  ? null
                  : () async {
                      if (nameCtrl.text.isEmpty) {
                        Get.snackbar("Failed", "Name cannot be empty");
                        return;
                      }
                      try {
                        isUpdating.value = true;
                        var response = await authService.updateName(
                            name: nameCtrl.text);
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
              child: isUpdating.value
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : Text("Save",
                      style: GoogleFonts.spaceGrotesk(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  // ── FIX: added currentPassCtrl field + validation ──
  void showChangeEmailDialog() {
    final emailCtrl = TextEditingController(text: user.value.email);
    final currentPassCtrl = TextEditingController(); // ✅ ADD THIS
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Change Email",
            style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ✅ Current password field added
            TextField(
              controller: currentPassCtrl,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Enter current password",
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: "Enter new email address",
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Cancel",
                style: GoogleFonts.spaceGrotesk(color: Colors.black)),
          ),
          Obx(
            () => ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: isUpdating.value
                  ? null
                  : () async {
                      // ✅ proper validation
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
                          currentPass: currentPassCtrl.text, // ✅ send real password
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
              child: isUpdating.value
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : Text("Save",
                      style: GoogleFonts.spaceGrotesk(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  // ── KEPT EXACTLY THE SAME ──
  void showChangePasswordDialog() {
    final passCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Change Password",
            style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: passCtrl,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "New password",
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: confirmCtrl,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Confirm password",
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Cancel",
                style: GoogleFonts.spaceGrotesk(color: Colors.black)),
          ),
          Obx(
            () => ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: isUpdating.value
                  ? null
                  : () async {
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
                        var response = await authService.updatePassword(
                            password: passCtrl.text);
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
              child: isUpdating.value
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : Text("Save",
                      style: GoogleFonts.spaceGrotesk(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}