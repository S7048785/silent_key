import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 16),
          child: Row(
            children: [
              InkWell(
                onTap: () => Get.back(),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(Icons.arrow_back),
                ),
              ),
              Expanded(
                child: TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                    hoverColor: Theme.of(context).colorScheme.inversePrimary,
                    isCollapsed: true,//重点，相当于高度包裹的意思，必须设置为true，不然有默认奇妙的最小高度
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),//内容内边距，影响高度
                    hintText: "Search Password",
                    prefixIcon: Icon(Icons.search),
                    fillColor: Theme.of(context).colorScheme.inversePrimary,
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: const Text("Search", style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
