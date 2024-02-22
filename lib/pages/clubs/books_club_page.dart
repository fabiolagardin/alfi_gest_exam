import 'package:alfi_gest/models/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:alfi_gest/providers/member_data_provider.dart';
import 'package:alfi_gest/providers/member_role_provider.dart';

class BooksClubPage extends ConsumerWidget {
  const BooksClubPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memberData = ref.watch(memberProvider);
    final memberRole = ref.watch(roleProvider);
    String pronuon = "";
    if (memberData == null) {
      // Gestisci il caso in cui _memberData è null
    } else if (memberData.pronoun == Pronoun.lei) {
      pronuon = "a";
    } else if (memberData.pronoun == Pronoun.lui) {
      pronuon = "o";
    } else {
      pronuon = "*";
    }
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            memberData == null
                ? Container()
                : Padding(
                    padding: const EdgeInsets.fromLTRB(0, 53, 0, 8),
                    child: Container(
                      width: 34.65,
                      height: 34.65,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                memberData == null ? "Ciao!" : "Ciao, ${memberData.legalName}!",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                "Libri Circolo PAGE.",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
            ),
          ],
        ),
      ),
    );
  }
}
