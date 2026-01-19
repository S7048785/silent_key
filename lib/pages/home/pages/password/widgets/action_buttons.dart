import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final bool isEditing;
  final VoidCallback onSave;
  final VoidCallback onCancel;
  final VoidCallback onCopyPassword;
  final VoidCallback onCopyAndClose;

  const ActionButtons({
    super.key,
    required this.isEditing,
    required this.onSave,
    required this.onCancel,
    required this.onCopyPassword,
    required this.onCopyAndClose,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        spacing: 12,
        children: [
          if (isEditing)
            Expanded(
              child: OutlinedButton(
                onPressed: onCancel,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text('取消'),
              ),
            ),
          if (isEditing)
            Expanded(
              child: ElevatedButton(
                onPressed: onSave,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text('保存'),
              ),
            ),
          if (!isEditing)
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onCopyPassword,
                icon: const Icon(Icons.content_copy_outlined),
                label: const Text('复制密码'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
            ),
          // if (!isEditing)
          //   Expanded(
          //     child: ElevatedButton.icon(
          //       onPressed: onCopyAndClose,
          //       icon: const Icon(Icons.content_cut_outlined),
          //       label: const Text('复制并退出'),
          //       style: ElevatedButton.styleFrom(
          //         minimumSize: const Size(double.infinity, 48),
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }
}
