import 'package:alfi_gest/providers/clubs/clubs_provider.dart';
import 'package:alfi_gest/providers/member/create_member_provider.dart';
import 'package:alfi_gest/widgets/clubs/clubs_select.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MembershipDetailsForm extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  MembershipDetailsForm({Key? key, required this.formKey}) : super(key: key);

  final TextEditingController clubController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(createMemberFormProvider);
    final clubs = ref.watch(filteredClubsProvider);
    final matchingClubs =
        clubs.where((element) => element.idClub == formState.idClub).toList();
    clubController.text =
        (matchingClubs.isNotEmpty) ? matchingClubs.first.nameClub : '';
    return Form(
      key: formKey,
      child: Column(
        children: [
          ClubsSelectWidget(
              clubController: clubController, clubs: clubs, isTextField: true),
          const SizedBox(height: 22),
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: Text(
              'Oltre alla tessera ALFI, vuoi aggiungere la tessera ARCI?',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    height: 1.2,
                  ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Switch(
                value: formState.haveCardARCI,
                onChanged: (bool haveCardARCI) {
                  ref
                      .read(createMemberFormProvider.notifier)
                      .updateHaveCardARCI(haveCardARCI);
                },
              ),
              SizedBox(width: 10),
              Text(
                'Tessera ARCI',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(right: 60),
            child: Text(
              '*La singola tessera ha il costo di 10 euro, le due tessere assieme 15 euro',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    height: 1.2,
                  ),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }
}
