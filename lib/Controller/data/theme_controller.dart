import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:middleman_all/View/utilities/strings.dart';

class ThemeController {
  final GetStorage storage = GetStorage();

  void changeThemeMode() {
    Get.changeThemeMode(isDarkMode() ? ThemeMode.light : ThemeMode.dark);
    storage.write(
        Strings.mode, isDarkMode() ? Strings.lightMode : Strings.darkMode);
  }

  bool isDarkMode() {
    String mode = storage.read(Strings.mode) ?? Strings.lightMode;
    if (mode == Strings.lightMode) {
      return false;
    } else {
      return true;
    }
  }

  ThemeMode getThemeMode() {
    String mode = storage.read(Strings.mode) ?? Strings.lightMode;

    if (mode == Strings.lightMode) {
      return ThemeMode.light;
    } else {
      return ThemeMode.dark;
    }
  }
}
