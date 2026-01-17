import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:silent_key/pages/login/page.dart';
import 'package:silent_key/theme/theme.dart';
import 'package:silent_key/utils/ThemeManager.dart';

void main() {
  runApp(const Application());
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
          builder: (context, child) {
            // 在这里全局添加 SafeArea
            Widget widget = SafeArea(child: child!);
            // 同时保留 BotToast 的初始化
            widget = BotToastInit()(context, widget);
            return widget;
          }, //1.调用BotToastInit
          navigatorObservers: [BotToastNavigatorObserver()], //2.注册路由观察者
        );
      },
    );
  }
}
