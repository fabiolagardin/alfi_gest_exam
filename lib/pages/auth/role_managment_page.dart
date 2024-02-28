import 'dart:async';

import 'package:alfi_gest/pages/members/members_helpers.dart';
import 'package:alfi_gest/pages/members/members_page.dart';
import 'package:alfi_gest/providers/clubs/clubs_provder.dart';
import 'package:alfi_gest/providers/member/create_member_provider.dart';
import 'package:alfi_gest/providers/member/members_data_provider.dart';
import 'package:alfi_gest/providers/auth/user_data_provider.dart';
import 'package:alfi_gest/screens/main_screen.dart';
import 'package:alfi_gest/services/member_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoleManagementPage extends ConsumerWidget {
  const RoleManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userDataProvider);
    final isMemberPage = ref.watch(isMemberPageProvider);
    final orderSelected = ref.watch(orderTypeProvider.notifier);
    final filteredSelected = ref.watch(filteredSelectedProvider.notifier);
    final cardStateSelected = ref.watch(cardStateProvider.notifier);
    final clubIdSelected = ref.watch(clubIdSelectedProvider.notifier);
    final isLoading = ref.watch(isLoadingProvider);
    final clubs = ref.watch(clubsProvider).unwrapPrevious().valueOrNull;
    final formState = ref.read(createMemberFormProvider);
    final filteredMembers = ref.watch(filteredMembersProvider);

    MembersPageHelpers helpers = MembersPageHelpers();
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(0, 18, 0, 0),
          child: IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              ref.read(isManageRolesPageProvider.notifier).state = false;
            },
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 18, 14, 0),
            child: Text(
              "Gestione ruoli",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
          ),
        ],
      ),
      body: user == null
          ? Center(child: CircularProgressIndicator())
          : Stack(
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
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant
                                        .withOpacity(0.5),
                                  ),
                              suffixIcon: const Icon(
                                Icons.search,
                              ),
                              suffixIconColor: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                              filled: true,
                              fillColor:
                                  Theme.of(context).colorScheme.background,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(28),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onChanged: (query) {
                              // Aggiorna la query di ricerca
                              ref.read(searchQueryProvider.notifier).state =
                                  query;

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
                                  var isExpiredCard = member.expirationDate
                                      .isBefore(DateTime.now());
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
                                          padding:
                                              const EdgeInsets.only(left: 20.0),
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
                                          padding: const EdgeInsets.only(
                                              right: 20.0),
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

                                      Timer.periodic(Duration(seconds: 1),
                                          (timer) {
                                        countdownController.add(countdownValue);
                                        if (countdownValue == 0) {
                                          timer.cancel();
                                          countdownController.close();
                                        } else {
                                          countdownValue--;
                                        }
                                      });

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4),
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

                                      await Future.delayed(Duration(
                                          seconds: 3)); // Wait for 3 seconds
                                      return shouldDismiss; // Return the value of shouldDismiss
                                    },
                                    onDismissed: (direction) async {
                                      ref
                                          .read(isLoadingProvider.notifier)
                                          .state = true;
                                      var result = await MemberService()
                                          .deleteMember(member.memberId);
                                      ref
                                          .read(isLoadingProvider.notifier)
                                          .state = false;
                                      if (!result.valid) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
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
                                        title: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8),
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
                                          padding:
                                              const EdgeInsets.only(left: 8),
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
                                            const EdgeInsets.symmetric(
                                                horizontal: 0),
                                        onTap: () {
                                          ref
                                              .read(memberSelected.notifier)
                                              .state = member;
                                          var club = ref
                                              .read(clubsProvider)
                                              .asData
                                              ?.value
                                              .where((c) =>
                                                  c.idClub == member.idClub)
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
                                              .read(
                                                  isMemberPageProvider.notifier)
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
              ],
            ),
    );
  }
}
