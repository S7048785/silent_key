import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

class ToastUtil {
  static void showText(String msg, {required BuildContext context}) {
    BotToast.showCustomText(
      // 仅显示1条
        onlyOne: true,
        // 生成需要显示的Widget的函数
        toastBuilder: (CancelFunc cancelFunc) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSecondary,
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
          child: Text(msg),
        )
    );
  }
}
