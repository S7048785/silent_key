import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final TextEditingController controller;
  final bool enabled;
  final ThemeData theme;
  final bool obscureText;
  final VoidCallback? onToggleVisibility;
  final bool showCopy;
  final VoidCallback? onCopy;

  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.controller,
    required this.enabled,
    required this.theme,
    this.obscureText = false,
    this.onToggleVisibility,
    this.showCopy = false,
    this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: theme.colorScheme.primary,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: enabled ? Border.all(color: theme.dividerColor) : null,
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Icon(icon, size: 20, color: theme.colorScheme.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    enabled
                        ? TextField(
                            controller: controller,
                            obscureText: obscureText,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                          )
                        : Text(
                            obscureText ? '••••••••' : controller.text,
                            style: theme.textTheme.bodyLarge,
                          ),
                  ],
                ),
              ),
              if (!enabled && showCopy)
                IconButton(
                  icon: const Icon(Icons.content_copy_outlined, size: 18),
                  onPressed: onCopy,
                ),
              if (onToggleVisibility != null)
                IconButton(
                  icon: Icon(
                    obscureText
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 18,
                  ),
                  onPressed: onToggleVisibility,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
