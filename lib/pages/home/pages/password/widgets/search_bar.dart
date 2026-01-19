import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:silent_key/pages/search/page.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => const SearchPage()),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.inversePrimary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.search),
            const SizedBox(width: 8),
            const Text("Search Password"),
          ],
        ),
      ),
    );
  }
}
