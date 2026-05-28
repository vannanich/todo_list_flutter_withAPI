part of 'setting_view.dart';

class SettingController extends GetxController {
  var authService = AuthService();
  var box = GetStorage();

  var isLoading = false.obs;
  var isUpdating = false.obs;
  late UserModel user;

  @override
  void onInit() {
    super.onInit();
    getProfile();
  }

  void getProfile() async {
    isLoading.value = true;
    var response = await authService.fixProfile();
    isLoading.value = false;
    user = UserModel.fromMap(response["data"]);
  }

  // ── Logout ──
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

  // ── Change Name — CONNECTED TO API ──
  void showChangeNameDialog() {
    final nameCtrl = TextEditingController(text: user.name);
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
                          user.name = nameCtrl.text; // update local
                          Get.back();
                          Get.snackbar("Success", "Name updated");
                          getProfile(); // refresh profile
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

  void showChangeEmailDialog() {
  final emailCtrl = TextEditingController(text: user.email);
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
          // ✅ ADD current password field
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
                    if (emailCtrl.text.isEmpty || currentPassCtrl.text.isEmpty) {
                      Get.snackbar("Failed", "All fields are required");
                      return;
                    }
                    try {
                      isUpdating.value = true;
                      var response = await authService.updateEmail(
                        email: emailCtrl.text,
                        currentPass: currentPassCtrl.text, // ✅ ADD THIS
                      );
                      isUpdating.value = false;
                      if (response["result"] == true) {
                        user.email = emailCtrl.text;
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

  // ── Change Password — CONNECTED TO API ──
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