import 'package:flutter/material.dart';
import 'package:silent_key/models/Category.dart';
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

  List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: IndexedStack(
            index: _index,
            children: [
              PasswordPage(),
              AddPage(),
              SettingsPage(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
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
      )
    );
  }
}
