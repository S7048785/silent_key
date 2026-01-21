import 'package:flutter/material.dart';
import 'package:silent_key/models/Category.dart';
import 'package:silent_key/models/Account.dart';
import 'package:silent_key/stores/hive_service.dart';
import 'account_item.dart';

class CategoryItem extends StatelessWidget {
  final Category category;
  final VoidCallback onDelete;
  final Function(Account) onAccountTap;

  const CategoryItem({
    super.key,
    required this.category,
    required this.onDelete,
    required this.onAccountTap,
  });

  @override
  Widget build(BuildContext context) {
    List<Account> accounts = hiveService.getAccountsByCategoryId(category.id);

    return Card(
      elevation: 8,
      shadowColor: Theme.of(context).colorScheme.shadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: InkWell(
        onLongPress: onDelete,
        child: ExpansionTile(
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          collapsedBackgroundColor: Theme.of(context).colorScheme.onPrimary,
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Row(
                  spacing: 8,
                  children: [
                    Icon(
                      Icons.person_outline_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    Text(
                      category.name,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              if (accounts.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "${accounts.length} 个账号",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      fontSize: 14,
                    ),
                  ),
                ),
            ],
          ),
          children: accounts.map((account) {
            return AccountItem(
              account: account,
              onTap: () => onAccountTap(account),
            );
          }).toList(),
        ),
      ),
    );
  }
}
