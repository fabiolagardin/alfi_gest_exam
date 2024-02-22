import 'dart:async';

import 'package:alfi_gest/helpers/date_time.dart';
import 'package:alfi_gest/models/club.dart';
import 'package:alfi_gest/models/enums.dart';
import 'package:alfi_gest/models/member.dart';
import 'package:alfi_gest/pages/members/members_helpers.dart';
import 'package:alfi_gest/providers/clubs_provder.dart';
import 'package:alfi_gest/providers/create_member_provider.dart';
import 'package:alfi_gest/providers/members_data_provider.dart';
import 'package:alfi_gest/screens/main_screen.dart';
import 'package:alfi_gest/services/member_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final memberVoidField = new Member(
    memberId: "",
    legalName: "",
    givenName: "",
    lastName: "",
    pronoun: Pronoun.nonAssegnato,
    address: "",
    birthDate: DateTime.now(),
    taxIdCode: "",
    documentType: TypeDocument.nonAssegnato,
    documentNumber: "",
    telephone: "",
    email: "",
    consentWhatsApp: false,
    consentNewsletter: false,
    workingPartner: false,
    volunteerMember: false,
    numberCard: "",
    idClub: "",
    haveCardARCI: false,
    memberSince: DateTime.now(),
    creationDate: DateTime.now(),
    userCreation: "",
    updateDate: DateTime.now(),
    updateUser: "",
    dateLastRenewal: DateTime.now(),
    expirationDate: DateHelper.calculateExpirationDate(),
    profileImageFile: null,
    replaceCardMotivation: ReplaceCardMotivation.nonAssegnato,
    isSuspended: false);
final memberSelected = StateProvider<Member>((ref) => memberVoidField);

final clubSelected = StateProvider<Club>(
  (ref) => Club(
    idClub: '',
    nameClub: '',
    address: '',
    city: '',
    email: '',
    idMemberManager: '',
    isSuspend: false,
    profileImageFile: null,
    creationDate: DateTime.now(),
    userCreation: '',
    updateDate: DateTime.now(),
    updateUser: '',
  ),
);

class MembersPage extends ConsumerWidget {
  const MembersPage({Key? key}) : super(key: key);
  Widget? statusIndicator(
      {required bool isSuspended,
      required bool isExpiredCard,
      required BuildContext context}) {
    if (!isSuspended && !isExpiredCard) {
      return null;
    }

    if (isExpiredCard) {
      return Container(
        width: 74,
        height: 29,
        margin: const EdgeInsets.symmetric(
          vertical: 9,
          horizontal: 5,
        ),
        alignment: AlignmentDirectional.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.errorContainer,
        ),
        child: Text(
          'Scaduta',
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSecondary,
              ),
        ),
      );
    }

    if (isSuspended) {
      return Container(
        width: 74,
        height: 29,
        margin: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 4,
        ),
        alignment: AlignmentDirectional.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        child: Text('Sospesa',
            style: Theme.of(context)
                .textTheme
                .labelLarge!
                .copyWith(color: Theme.of(context).colorScheme.onSecondary)),
      );
    }

    // Per sicurezza, anche se non dovrebbe mai arrivare qui se i parametri sono usati correttamente.
    return null;
  }

  Color getStatusColor(
      {required bool isSuspended,
      required bool isExpiredCard,
      required BuildContext context}) {
    // Se entrambi i valori sono false, ritorna il colore di surface
    if (!isSuspended && !isExpiredCard) {
      return Colors.transparent;
    }

    // Se la carta è scaduta, ritorna il colore primary
    if (isExpiredCard) {
      return Theme.of(context).colorScheme.primary;
    }

    // Se la carta è sospesa, ritorna il colore surfaceVariant
    if (isSuspended) {
      return Theme.of(context).colorScheme.surfaceVariant;
    }

    // Default a surface se nessuna delle condizioni è soddisfatta
    // Questo punto del codice non dovrebbe mai essere raggiunto grazie ai controlli precedenti
    return Theme.of(context).colorScheme.surface;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMemberPage = ref.watch(isMemberPageProvider);
    final orderSelected = ref.watch(orderTypeProvider.notifier);
    final filteredSelected = ref.watch(filteredSelectedProvider.notifier);
    final cardStateSelected = ref.watch(cardStateProvider.notifier);
    final clubIdSelected = ref.watch(clubIdSelectedProvider.notifier);
    final isLoading = ref.watch(isLoadingProvider);
    final clubs = ref.watch(clubsProvider).unwrapPrevious().valueOrNull;
    final formState = ref.read(createMemberFormProvider);
    MembersPageHelpers helpers = MembersPageHelpers();

    // Get the filtered members
    final filteredMembers = ref.watch(filteredMembersProvider);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsetsDirectional.only(top: 16),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Consumer(
                  builder: (context, ref, child) {
                    return TextField(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 24),
                        hintText: "Cerca socie*",
                        hintStyle:
                            Theme.of(context).textTheme.bodyLarge!.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant
                                      .withOpacity(0.5),
                                ),
                        suffixIcon: const Icon(
                          Icons.search,
                        ),
                        suffixIconColor:
                            Theme.of(context).colorScheme.onSurfaceVariant,
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (query) {
                        // Aggiorna la query di ricerca
                        ref.read(searchQueryProvider.notifier).state = query;

                        // Filtra i membri in base alla query
                        ref
                            .read(filteredMembersProvider.notifier)
                            .searchMember(query);
                      },
                    );
                  },
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: isLoading
                      ? Center(child: const CircularProgressIndicator())
                      : ListView.builder(
                          itemCount: filteredMembers.length,
                          itemBuilder: (context, index) {
                            final member = filteredMembers[index];
                            var isExpiredCard =
                                member.expirationDate.isBefore(DateTime.now());
                            return Dismissible(
                              key: Key(member.memberId),
                              // direction: DismissDirection.startToEnd,
                              background: Container(
                                color: Theme.of(context)
                                    .colorScheme
                                    .errorContainer, // Change as needed
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Icon(Icons.delete,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onTertiary), // Change as needed
                                  ),
                                ),
                              ),
                              secondaryBackground: Container(
                                color: Theme.of(context)
                                    .colorScheme
                                    .errorContainer,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: Icon(Icons.delete,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onTertiary),
                                  ),
                                ),
                              ),
                              confirmDismiss: (direction) async {
                                final countdownController =
                                    StreamController<int>();
                                int countdownValue = 3;
                                bool shouldDismiss = true;

                                Timer.periodic(Duration(seconds: 1), (timer) {
                                  countdownController.add(countdownValue);
                                  if (countdownValue == 0) {
                                    timer.cancel();
                                    countdownController.close();
                                  } else {
                                    countdownValue--;
                                  }
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    duration: Duration(seconds: 3),
                                    content: StreamBuilder<int>(
                                      stream: countdownController.stream,
                                      builder: (context, snapshot) {
                                        return Text(
                                            'Socia si cancella in ${snapshot.data ?? 3}');
                                      },
                                    ),
                                    action: SnackBarAction(
                                      label: 'Annulla',
                                      onPressed: () {
                                        shouldDismiss = false;
                                        ScaffoldMessenger.of(context)
                                            .hideCurrentSnackBar();
                                      },
                                    ),
                                  ),
                                );

                                await Future.delayed(
                                    Duration(seconds: 3)); // Wait for 3 seconds
                                return shouldDismiss; // Return the value of shouldDismiss
                              },
                              onDismissed: (direction) async {
                                ref.read(isLoadingProvider.notifier).state =
                                    true;
                                var result = await MemberService()
                                    .deleteMember(member.memberId);
                                ref.read(isLoadingProvider.notifier).state =
                                    false;
                                if (!result.valid) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(result.error ??
                                          "Errore nella cancellazione del socio"),
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .errorContainer,
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 1.0,
                                        color: isExpiredCard
                                            ? Theme.of(context)
                                                .colorScheme
                                                .onPrimary
                                            : Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                  ),
                                ),
                                child: ListTile(
                                  tileColor: getStatusColor(
                                    isSuspended: member.isSuspended,
                                    isExpiredCard: isExpiredCard,
                                    context: context,
                                  ),
                                  title: Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Text(
                                      '${member.lastName} ${member.givenName.isEmpty ? member.legalName : member.givenName}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                            color: isExpiredCard
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                          ),
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                          member.numberCard.isEmpty
                                              ? "Senza Tessera"
                                              : member.numberCard,
                                          style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                              color: isExpiredCard
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                            )),
                                  ),
                                  contentPadding:
                                      const EdgeInsets.symmetric(horizontal: 0),
                                  trailing: Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: statusIndicator(
                                      isSuspended: member.isSuspended,
                                      isExpiredCard: isExpiredCard,
                                      context: context,
                                    ),
                                  ),
                                  onTap: () {
                                    ref.read(memberSelected.notifier).state =
                                        member;
                                    var club = ref
                                        .read(clubsProvider)
                                        .asData
                                        ?.value
                                        .where((c) => c.idClub == member.idClub)
                                        .firstOrNull;
                                    club != null
                                        ? ref
                                            .read(clubSelected.notifier)
                                            .state = club
                                        : null;
                                    ref
                                        .read(isMemberDetailsPageProvider
                                            .notifier)
                                        .state = true;
                                    ref
                                        .read(isMemberPageProvider.notifier)
                                        .state = false;
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 18,
            left: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surfaceVariant, // Colore di sfondo della Row
                borderRadius: BorderRadius.circular(100), // Raggio del bordo
                // Se vuoi un bordo visibile, puoi aggiungere il Border.all
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .secondary, // Colore del bordo
                  width: 0.5, // Larghezza del bordo
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 6,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize
                      .min, // Riduce la grandezza della Row alla grandezza minima dei figli
                  children: [
                    Container(
                      height: 27,
                      width: 27,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        borderRadius:
                            BorderRadius.circular(100), // Raggio del bordo
                        // Se vuoi un bordo visibile, puoi aggiungere il Border.all
                        border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .secondary, // Colore del bordo
                          width: 0.5, // Larghezza del bordo
                        ),
                      ),
                      child: FloatingActionButton(
                        onPressed: () => helpers.showFilterOptions(
                            context,
                            ref,
                            filteredSelected,
                            orderSelected,
                            cardStateSelected,
                            clubIdSelected,
                            clubs ?? List<Club>.empty()),
                        backgroundColor:
                            Theme.of(context).colorScheme.surfaceVariant,
                        // Se vuoi usare un FAB più piccolo standard
                        mini: true,
                        child: Icon(
                          Icons.filter_list,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 20,
                        ), // Imposta la dimensione del FAB a mini
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      height: 27,
                      width: 27,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        borderRadius:
                            BorderRadius.circular(100), // Raggio del bordo
                        // Se vuoi un bordo visibile, puoi aggiungere il Border.all
                        border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .secondary, // Colore del bordo
                          width: 0.5, // Larghezza del bordo
                        ),
                      ),
                      child: FloatingActionButton(
                        onPressed: () => helpers.showSortingOptions(
                            context, ref, orderSelected),
                        backgroundColor:
                            Theme.of(context).colorScheme.surfaceVariant,
                        // Se vuoi usare un FAB più piccolo standard
                        mini: true,
                        child: Icon(
                          Icons.swap_vert,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 20,
                        ), // Imposta la dimensione del FAB a mini
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      height: 27,
                      width: 27,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceVariant, // Colore di sfondo della Row
                        borderRadius:
                            BorderRadius.circular(100), // Raggio del bordo
                        // Se vuoi un bordo visibile, puoi aggiungere il Border.all
                        border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .secondary, // Colore del bordo
                          width: 0.5, // Larghezza del bordo
                        ),
                      ),
                      child: FloatingActionButton(
                        onPressed: () {
                          // Logica per mostrare il menu
                        },
                        backgroundColor:
                            Theme.of(context).colorScheme.surfaceVariant,
                        // Se vuoi usare un FAB più piccolo standard

                        mini: true,
                        child: Icon(
                          Icons.file_download_outlined,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 20,
                        ), // Imposta la dimensione del FAB a mini
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          formState.reset();
          ref.read(isMemberDetailsPageProvider.notifier).state = false;
          ref.read(isMemberPageProvider.notifier).state = !isMemberPage;
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        mini: true,
        child: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
      ),
    );
  }
}
