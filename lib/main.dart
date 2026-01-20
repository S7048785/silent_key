import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:silent_key/controllers/CategoryController.dart';
import 'package:silent_key/pages/login/page.dart';
import 'package:silent_key/stores/hive_adapters.dart';
import 'package:silent_key/stores/hive_service.dart';
import 'package:silent_key/services/auth_service.dart';
import 'package:silent_key/theme/theme.dart';
import 'package:silent_key/utils/ThemeManager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initServices();
  await ThemeManager.loadThemeFromDisk();
  runApp(const Application());
  Get.put(CategoryController());
}

Future<void> _initServices() async {
  await Hive.initFlutter();
  HiveAdapters.registerAdapters();
  // 先初始化 AuthService（需要在 HiveService 之前）
  await authService.init();
  await hiveService.init();
}

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    // 创建主题实例
    final materialTheme = MaterialTheme(Theme.of(context).textTheme);

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeManager.themeMode,
      builder: (context, themeMode, child) {
        return GetMaterialApp(
          home: const LoginPage(),
          theme: materialTheme.light(),
          darkTheme: materialTheme.dark(),
          themeMode: themeMode,
          debugShowCheckedModeBanner: false,
          builder: BotToastInit(), //1.调用BotToastInit
          navigatorObservers: [BotToastNavigatorObserver()], //2.注册路由观察者
        );
      },
    );
  }
}
