import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ToastUtil {
  static void showText({required String text}) {
    // 尝试通过 Get.context 获取主题，如果失败则使用默认样式
    final context = Get.context;
    if (context != null) {
      _showThemedToast(context, text);
    } else {
      _showFallbackToast(text);
    }
  }

  static void _showThemedToast(BuildContext context, String text) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    BotToast.showCustomText(
      // 仅显示1条
        onlyOne: true,
        // 生成需要显示的Widget的函数
        toastBuilder: (CancelFunc cancelFunc) => Container(
          decoration: BoxDecoration(
            color: colorScheme.onSecondary,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Text(text, style: TextStyle(color: colorScheme.secondary),),
        )
    );
  }

  static void _showFallbackToast(String text) {
    // 当无法获取主题时使用默认样式
    BotToast.showCustomText(
        onlyOne: true,
        toastBuilder: (CancelFunc cancelFunc) => Container(
          decoration: BoxDecoration(
            color: Colors.grey[700]!,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        )
    );
  }
}