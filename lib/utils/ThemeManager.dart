import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager {
  static final ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.system);

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