import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:silent_key/models/Account.dart';
import 'package:silent_key/pages/home/pages/password/widgets/bottom_sheet_content.dart';
import 'package:silent_key/stores/hive_service.dart';

import '../home/pages/password/widgets/account_item.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  List<Account> _searchResults = [];

  void _onSearch() {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }
    final results = hiveService.getAccountsByUsername(query);
    setState(() {
      _searchResults = results;
    });
  }

  void _showBottomSheet(Account account) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: BottomSheetContent(account: account),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: ListView(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onEditingComplete: _onSearch,
                      autofocus: true,
                      decoration: InputDecoration(
                        hoverColor: Theme.of(
                          context,
                        ).colorScheme.inversePrimary,
                        isCollapsed: true,
                        //重点，相当于高度包裹的意思，必须设置为true，不然有默认奇妙的最小高度
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 12,
                        ),
                        //内容内边距，影响高度
                        hintText: "搜索用户名",
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
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _onSearch,
                    child: const Text(
                      "搜索",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (_searchResults.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  "搜索结果",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ..._searchResults.map(
                  (a) => AccountItem(
                    account: a,
                    onTap: () {
                      _showBottomSheet(a);
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
