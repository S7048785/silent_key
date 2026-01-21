import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 键盘监听Widget，用于捕获数字键和退格键事件
class LoginKeyboardListener extends StatefulWidget {
  final void Function(int number) onNumberInput;
  final VoidCallback onBackspace;

  const LoginKeyboardListener({
    super.key,
    required this.onNumberInput,
    required this.onBackspace,
  });

  @override
  State<LoginKeyboardListener> createState() => _LoginKeyboardListenerState();
}

class _LoginKeyboardListenerState extends State<LoginKeyboardListener>
    with WidgetsBindingObserver {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestFocus();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _requestFocus();
  }

  @override
  void didUpdateWidget(LoginKeyboardListener oldWidget) {
    super.didUpdateWidget(oldWidget);
    _requestFocus();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _requestFocus();
    }
  }

  void _requestFocus() {
    if (mounted) {
      _focusNode.requestFocus();
    }
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    final logicalKey = event.logicalKey;

    // 处理数字键 0-9 (主键盘)
    if (logicalKey.keyId >= 48 && logicalKey.keyId <= 57) {
      widget.onNumberInput(logicalKey.keyId - 48);
    }
    // 处理数字键 0-9 (小键盘)
    else if (logicalKey.keyId >= 8589935152 && logicalKey.keyId <= 8589935161) {
      widget.onNumberInput(logicalKey.keyId - 8589935152);
    }
    // 处理退格键
    else if (logicalKey.keyId == 8 || logicalKey.keyId == 4294967304) {
      widget.onBackspace();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyEvent,
      autofocus: true,
      child: const SizedBox.shrink(),
    );
  }
}
