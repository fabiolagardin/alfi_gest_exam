import 'package:alfi_gest/models/enums.dart';
import 'package:alfi_gest/providers/user_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:alfi_gest/providers/member_role_provider.dart';
import 'package:alfi_gest/helpers/string_helper.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userDataProvider);
    final memberRole = ref.watch(roleProvider);
    String pronuon = "";
    if (userData == null) {
      // Gestisci il caso in cui _userData è null
    } else if (userData.pronoun == Pronoun.lei) {
      pronuon = "a";
    } else if (userData.pronoun == Pronoun.lui) {
      pronuon = "o";
    } else {
      pronuon = "*";
    }
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(25, 15, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                userData == null ? "Ciao!" : "Ciao, ${userData.legalName}!",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                memberRole == null
                    ? "Non hai ruoli"
                    : StringHelper.splitOnCaps(memberRole),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
