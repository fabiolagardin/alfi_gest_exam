import 'package:alfi_gest/models/enums.dart';
import 'package:alfi_gest/pages/clubs/clubs_page.dart';
import 'package:alfi_gest/providers/clubs/clubs_provider.dart';
import 'package:alfi_gest/providers/clubs/create_club_provider.dart';
import 'package:alfi_gest/providers/member/create_member_provider.dart';
import 'package:alfi_gest/providers/member/member_role_provider.dart';
import 'package:alfi_gest/providers/member/members_data_provider.dart';
import 'package:alfi_gest/screens/main_screen.dart';
import 'package:alfi_gest/services/club_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClubDetailsPage extends ConsumerStatefulWidget {
  const ClubDetailsPage({super.key});
  @override
  ClubDetailsPageState createState() => ClubDetailsPageState();
}

class ClubDetailsPageState extends ConsumerState<ClubDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final club = ref.watch(clubSelected);
    final formState = ref.read(createClubFormProvider);
    final userRole = ref.watch(roleProvider);

    final memberManager = ref
        .watch(filteredMembersProvider)
        .where((m) => m.id == club.idMemberManager)
        .firstOrNull;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
          toolbarHeight: 70,
          leading: userRole == Role.responsabileCircolo
              ? null
              : IconButton(
                  icon: Icon(Icons.chevron_left),
                  color: Theme.of(context).colorScheme.secondary,
                  onPressed: () {
                    ref.read(isClubPageProvider.notifier).state = true;
                    ref.read(isMainAppBarProvider.notifier).state = true;
                  }),
          actions: [
            TextButton(
              onPressed: () {
                formState.idClub = club.idClub;
                formState.idMemberManager = club.idMemberManager;
                formState.address = club.address;
                formState.city = club.city;
                formState.isClosed = club.isClosed;
                formState.nameClub = club.nameClub;
                formState.creationDate = club.creationDate;
                formState.email = club.email;
                formState.creationDate = club.creationDate;
                formState.isSuspended = club.isSuspended;
                formState.logoPath = club.logoPath;
                formState.updateDate = club.updateDate;
                formState.updateUser = club.updateUser;
                formState.userCreation = club.userCreation;
                ref.read(isClubPageProvider.notifier).state = false;
                ref.read(isClubDetailsUpdatePageProvider.notifier).state = true;
                ref.read(isClubReadyFor.notifier).state = true;
                ref.read(isClubDetailsPageProvider.notifier).state = false;
              },
              child: Text(
                "Modifica",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  child: Text(
                    club.nameClub,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ),
                Card(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                        child: Row(
                          children: [
                            Text(
                              'Anagrafica',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(color: Theme.of(context).colorScheme.primary),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 13,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Città',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                                Text(
                                  club.city.isNotEmpty
                                      ? club.city
                                      : "Nessuna città",
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                                color: Theme.of(context)
                                    .colorScheme
                                    .outlineVariant),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Email',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                                Text(
                                  club.email.isNotEmpty
                                      ? club.email
                                      : "Nessuna email",
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                                color: Theme.of(context)
                                    .colorScheme
                                    .outlineVariant),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Responsabile',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                                Text(
                                  memberManager != null
                                      ? "${memberManager.legalName} ${memberManager.lastName}"
                                      : "Nessun responsabile",
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                                color: Theme.of(context)
                                    .colorScheme
                                    .outlineVariant),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Sede',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    club.address.isNotEmpty
                                        ? club.address
                                        : "Nessun indirizzo",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
        floatingActionButton: userRole == Role.responsabileCircolo
            ? null
            : Padding(
                padding: const EdgeInsets.fromLTRB(34, 8, 0, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    club.isSuspend || club.isClosed
                        ? ElevatedButton(
                            onPressed: () async {
                              ref.read(isLoadingProvider.notifier).state = true;
                              var result = await ClubService()
                                  .updateClubStatus(club.idClub, false, false);
                              if (result.valid) {
                                ref.read(isLoadingProvider.notifier).state =
                                    false;
                                ref.read(isClubPageProvider.notifier).state =
                                    true;
                                ref.read(isMainAppBarProvider.notifier).state =
                                    true;

                                var updatedClubs = await ref
                                    .read(clubsDataProvider)
                                    .getClubs();

                                // Aggiorna la lista dei club nel FilteredClubsNotifier
                                ref
                                    .read(filteredClubsProvider.notifier)
                                    .updateAllClubs(updatedClubs);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      content: Text(
                                        "Circolo ${club.nameClub} è stato attivato!",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary),
                                      ),
                                      behavior: SnackBarBehavior.floating),
                                );
                              } else {
                                ref.read(isLoadingProvider.notifier).state =
                                    false;

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .errorContainer,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      content: Text(
                                        result.error!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onTertiary),
                                      ),
                                      behavior: SnackBarBehavior.floating),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            child: Text("Attiva",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    )),
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              ref.read(isLoadingProvider.notifier).state = true;
                              var result = await ClubService()
                                  .updateClubStatus(club.idClub, true, true);
                              if (result.valid) {
                                ref.read(isLoadingProvider.notifier).state =
                                    false;
                                ref.read(isClubPageProvider.notifier).state =
                                    true;
                                ref.read(isMainAppBarProvider.notifier).state =
                                    true;

                                var updatedClubs = await ref
                                    .read(clubsDataProvider)
                                    .getClubs();

                                // Aggiorna la lista dei club nel FilteredClubsNotifier
                                ref
                                    .read(filteredClubsProvider.notifier)
                                    .updateAllClubs(updatedClubs);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      content: Text(
                                        "Circolo ${club.nameClub} è stato sospeso!",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary),
                                      ),
                                      behavior: SnackBarBehavior.floating),
                                );
                              } else {
                                ref.read(isLoadingProvider.notifier).state =
                                    false;

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .errorContainer,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      content: Text(
                                        result.error!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onTertiary),
                                      ),
                                      behavior: SnackBarBehavior.floating),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            child: Text("Sospendi",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    )),
                          ),
                    club.isSuspend || club.isClosed
                        ? const SizedBox()
                        : ElevatedButton(
                            onPressed: () async {
                              ref.read(isLoadingProvider.notifier).state = true;
                              var result = await ClubService()
                                  .updateClubStatus(club.idClub, false, true);
                              ref.read(isLoadingProvider.notifier).state =
                                  false;
                              ref.read(isClubPageProvider.notifier).state =
                                  true;
                              ref.read(isMainAppBarProvider.notifier).state =
                                  true;

                              var updatedClubs =
                                  await ref.read(clubsDataProvider).getClubs();

                              // Aggiorna la lista dei club nel FilteredClubsNotifier
                              ref
                                  .read(filteredClubsProvider.notifier)
                                  .updateAllClubs(updatedClubs);

                              if (result.valid) {
                                ref.read(isClubPageProvider.notifier).state =
                                    true;

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      content: Text(
                                        "Circolo ${club.nameClub} è stato chiuso!",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary),
                                      ),
                                      behavior: SnackBarBehavior.floating),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .errorContainer,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      content: Text(
                                        result.error!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onTertiary),
                                      ),
                                      behavior: SnackBarBehavior.floating),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            child: Text("Chiudi",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    )),
                          ),
                  ],
                ),
              ));
  }
}
