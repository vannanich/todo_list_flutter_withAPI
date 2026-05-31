import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

class ThemeColorController extends GetxController {
  static ThemeColorController get to => Get.find();
  final box = GetStorage();
  var themeMode = ThemeMode.light.obs;

  @override
  void onInit() {
    super.onInit();
    final savedTheme = box.read("theme") ?? "light";
    themeMode.value = savedTheme == "dark" ? ThemeMode.dark : ThemeMode.light;
  }

  bool get isDark => themeMode.value == ThemeMode.dark;

  void toggleTheme() {
    if (isDark) {
      themeMode.value = ThemeMode.light;
      box.write("theme", "light");
    } else {
      themeMode.value = ThemeMode.dark;
      box.write("theme", "dark");
    }
  }
}