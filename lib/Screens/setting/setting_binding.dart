part of 'setting_view.dart';

class SettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingController(), fenix: true);
  }
}