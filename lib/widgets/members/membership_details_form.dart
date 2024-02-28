import 'package:alfi_gest/providers/clubs/clubs_provder.dart';
import 'package:alfi_gest/providers/member/create_member_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MembershipDetailsForm extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  const MembershipDetailsForm({Key? key, required this.formKey})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(createMemberFormProvider);
    final clubsAsyncValue = ref.watch(clubsProvider);

    return Form(
      key: formKey,
      child: Column(
        children: [
          clubsAsyncValue.when(
            data: (clubs) => DropdownButtonFormField<String>(
              value: formState.idClub != null &&
                      clubs.any((club) => club.idClub == formState.idClub)
                  ? formState.idClub
                  : null, // Assicurati che il valore corrente esista nell'elenco, altrimenti imposta su null
              onChanged: (String? newValue) {
                ref
                    .read(createMemberFormProvider.notifier)
                    .updateIdClub(newValue ?? '');
              },
              items: clubs.map<DropdownMenuItem<String>>((club) {
                return DropdownMenuItem<String>(
                  value: club.idClub,
                  child: Text(club.nameClub),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Circolo',
                fillColor: Theme.of(context).colorScheme.surfaceVariant,
                filled: true,
                border: InputBorder.none,
              ),
            ),
            loading: () => const CircularProgressIndicator(),
            error: (e, _) => Text('Error: $e'),
          ),
          const SizedBox(height: 22),
          Padding(
            padding: const EdgeInsets.only(right: 60),
            child: Text(
              'Oltre alla tessera ALFI, vuoi aggiungere la tessera ARCI?',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    height: 1.2,
                  ),
            ),
          ),
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
