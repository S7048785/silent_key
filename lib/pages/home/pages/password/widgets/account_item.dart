import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:silent_key/models/Account.dart';
import 'package:silent_key/utils/ToastUtil.dart';

class AccountItem extends StatelessWidget {
  final Account account;
  final VoidCallback onTap;
  final VoidCallback? onCopyPassword;

  const AccountItem({
    super.key,
    required this.account,
    required this.onTap,
    this.onCopyPassword,
  });

  void _copyPassword(BuildContext context) {
    Clipboard.setData(ClipboardData(text: account.password));
    ToastUtil.showText("复制成功", context: context);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Text(account.username),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.copy),
          onPressed: () => _copyPassword(context),
        ),
      ),
    );
  }
}
