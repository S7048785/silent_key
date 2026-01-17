import 'package:flutter/material.dart';
import 'package:silent_key/pages/home/pages/add/page.dart';
import 'package:silent_key/pages/home/pages/password/page.dart';
import 'package:silent_key/pages/home/pages/settings/page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SilentKey', style: TextStyle(fontSize: 24)),
      ),
      body: IndexedStack(
        index: _index,
        children: [
          PasswordPage(),
          AddPage(),
          SettingsPage(),
        ],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(48)),
        // 确保子组件也应用圆角
        child: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.password),
              label: 'Password',
            ),
            NavigationDestination(icon: Icon(Icons.add), label: 'Add'),
            NavigationDestination(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
