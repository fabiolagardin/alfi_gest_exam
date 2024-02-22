import 'package:flutter/material.dart';
import 'package:alfi_gest/providers/auth_provider.dart';
import 'package:alfi_gest/providers/members_data_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(0, 18, 0, 0),
          child: IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 18, 14, 0),
            child: Text(
              "Account",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Container(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              ref.read(membersProvider.notifier).cancelMembersSubscription();
              // Esegui il logout
              ref.read(authProvider.notifier).logout();

              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              shadowColor: Colors.transparent,
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            ),
            child: Text(
              "Esci",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
