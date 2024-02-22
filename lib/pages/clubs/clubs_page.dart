import 'package:alfi_gest/models/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:alfi_gest/providers/member_data_provider.dart';
import 'package:alfi_gest/providers/member_role_provider.dart';

class ClubsPage extends ConsumerWidget {
  const ClubsPage({Key? key}) : super(key: key);

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
              child: memberData != null
                  ? Text(
                      "Ciao, ${memberData.legalName}!",
                      style: Theme.of(context).textTheme.headlineLarge,
                    )
                  : const Text("Ciao!"),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                "Benvenut$pronuon nel tuo pannello di controllo.",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                "Circoli Page",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
