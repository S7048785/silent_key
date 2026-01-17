import 'package:flutter/material.dart';

class ThemeManager {
  static final ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.system);

  static void toggleTheme() {
    if (themeMode.value == ThemeMode.dark) {
      themeMode.value = ThemeMode.light;
    } else {
      themeMode.value = ThemeMode.dark;
    }
  }

  // 可选：保存到本地（如 SharedPreferences）
  static void saveThemeToDisk(ThemeMode mode) {
    // 实现略，见下文扩展
  }
}