import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 全局访问方便、轻量、无需 Get.put()
class ThemeManager {
  static final Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  static Future<void> loadThemeFromDisk() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString('theme');
    if (theme == null) {
      return;
    }
    themeMode.value = ThemeMode.values.firstWhere((element) => element.toString() == theme);
  }

  static Future<void> toggleTheme() async {

    // 切换主题
    if (themeMode.value == ThemeMode.dark) {
      themeMode.value = ThemeMode.light;
      // Get.changeTheme(ThemeData.light());

    } else {
      themeMode.value = ThemeMode.dark;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', themeMode.value.toString());
  }

  // 可选：保存到本地（如 SharedPreferences）
  static void saveThemeToDisk(ThemeMode mode) {
    // 实现略，见下文扩展
  }
}