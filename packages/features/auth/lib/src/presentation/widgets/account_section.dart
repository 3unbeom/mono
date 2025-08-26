import 'package:flutter/material.dart';

import 'delete_account_bottom_sheet.dart';
import 'logout_bottom_sheet.dart';

class AccountSection extends StatelessWidget {
  const AccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            '계정',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text('로그아웃', style: theme.textTheme.bodyLarge?.copyWith()),
          trailing: Icon(Icons.chevron_right),
          onTap: () => LogoutBottomSheet.show(context: context),
        ),
        ListTile(
          leading: Icon(Icons.person_off_outlined),
          title: Text('회원 탈퇴', style: theme.textTheme.bodyLarge?.copyWith()),
          trailing: Icon(Icons.chevron_right),
          onTap: () => DeleteAccountBottomSheet.show(context: context),
        ),
      ],
    );
  }
}
