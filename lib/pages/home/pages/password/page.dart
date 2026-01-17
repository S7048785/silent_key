import 'package:flutter/material.dart';
import 'package:silent_key/pages/search/page.dart';
import 'package:get/get.dart';
import 'package:silent_key/utils/ThemeManager.dart';
class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const .all(16),
      child: Column(
        children: [
          InkWell(
            onTap: () => Get.to(() => SearchPage()),
            child: Container(
              padding: const .all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.search),
                  SizedBox(width: 8),
                  Text("Search Password"),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}
