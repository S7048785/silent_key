import 'package:flutter/material.dart';
import 'package:silent_key/utils/ThemeManager.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: OutlinedButton(
        onPressed: () => ThemeManager.toggleTheme(),

        child: Text('Outlined Button'),
      ),
    );
  }
}
