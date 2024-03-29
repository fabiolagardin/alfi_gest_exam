import 'package:alfi_gest/core/pair.dart';
import 'package:alfi_gest/models/club.dart';
import 'package:alfi_gest/models/enums.dart';
import 'package:alfi_gest/models/member.dart';
import 'package:alfi_gest/pages/members/members_helpers.dart';
import 'package:alfi_gest/providers/clubs/clubs_provider.dart';
import 'package:alfi_gest/providers/member/create_member_provider.dart';
import 'package:alfi_gest/providers/member/member_data_provider.dart';
import 'package:alfi_gest/providers/member/member_role_provider.dart';
import 'package:alfi_gest/providers/member/members_data_provider.dart';
import 'package:alfi_gest/screens/main_screen.dart';
import 'package:alfi_gest/services/member_service.dart';
import 'package:alfi_gest/widgets/list_views_items.dart';
import 'package:alfi_gest/widgets/utility_button.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final memberVoidField = Member.empty();
final memberSelected = StateProvider<Member>((ref) => memberVoidField);

final clubSelected = StateProvider<Club>(
  (ref) => Club.empty(),
);

class MembersPage extends ConsumerStatefulWidget {
  const MembersPage({Key? key}) : super(key: key);

  @override
  _MembersPageState createState() => _MembersPageState();
}

class _MembersPageState extends ConsumerState<MembersPage> {
  @override
  Widget build(BuildContext context) {
    final isMemberPage = ref.watch(isMemberPageProvider);
    final orderSelected = ref.watch(orderTypeProvider.notifier);
    final filteredSelected = ref.watch(filteredSelectedProvider.notifier);
    final cardStateSelected = ref.watch(cardStateProvider.notifier);
    final clubIdSelected = ref.watch(clubIdSelectedProvider.notifier);
    final clubs = ref.watch(clubsProvider);
    final formState = ref.read(createMemberFormProvider);
    final userRole = ref.watch(roleProvider);
    final userData = ref.watch(memberProvider);
    MembersPageHelpers helpers = MembersPageHelpers();
    // Get the filtered members
    final filteredMembers =
        userRole == Role.responsabileCircolo && userData != null
            ? ref
                .watch(filteredMembersProvider)
                .where((m) => !m.isSuspend && m.idClub == userData.idClub)
                .toList()
            : ref.watch(filteredMembersProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(filteredMembersProvider.notifier).filterMembers(
              cardState: cardStateSelected.state, clubId: clubIdSelected.state);
        },
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsetsDirectional.only(top: 25),
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
                  filteredMembers.length < 1
                      ? Center(
                          heightFactor: 2.5,
                          child: Text(
                            "Nessun risultato",
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                          ))
                      : ListViewItem(
                          itemCount: filteredMembers.length,
                          items: filteredMembers,
                          callServiceItem: (identifiable) async =>
                              await MemberService()
                                  .deleteMember(identifiable.id),
                          onTapListTile: (identifiable) {
                            ref.read(memberSelected.notifier).state =
                                identifiable as Member;
                            var club = ref
                                .read(clubsProvider)
                                .value
                                ?.data!
                                .where((c) => c.idClub == identifiable.idClub)
                                .firstOrNull;
                            club != null
                                ? ref.read(clubSelected.notifier).state = club
                                : null;
                            ref
                                .read(isMemberDetailsPageProvider.notifier)
                                .state = true;
                            ref.read(isMemberPageProvider.notifier).state =
                                false;
                            ref.read(isMainAppBarProvider.notifier).state =
                                false;
                          },
                          nameOfItemForMessage: "socia*",
                          statusDataFirst: Pair('Sospesa',
                              Theme.of(context).colorScheme.onSurfaceVariant),
                          statusDataSecond: Pair('Scaduta',
                              Theme.of(context).colorScheme.errorContainer),
                          statusColorFirst:
                              Theme.of(context).colorScheme.surfaceVariant,
                          statusColorSecond:
                              Theme.of(context).colorScheme.primary,
                          titleConditionColors: Pair(
                            Theme.of(context).colorScheme.onPrimary,
                            Theme.of(context).colorScheme.onPrimary,
                          ),
                          subtitleConditionColors: Pair(
                            Theme.of(context).colorScheme.onPrimary,
                            Theme.of(context).colorScheme.onPrimary,
                          ),
                          itemsAdditional: clubs.value?.data ?? [],
                          userRole: userRole,
                          isDeleteItemPermesse: true,
                          showIconRoles: true,
                        ),
                ],
              ),
            ),

            // menu filtri
            Positioned(
              bottom: 16,
              left: 20,
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(100),
                child: Container(
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize
                          .min, // Riduce la grandezza della Row alla grandezza minima dei figli
                      children: [
                        UtilityButton(
                          icon: Icon(
                            Icons.filter_list,
                            color: Theme.of(context).colorScheme.secondary,
                            size: 22,
                          ),
                          onPressed: () => helpers.showFilterOptions(
                              context,
                              ref,
                              filteredSelected,
                              orderSelected,
                              cardStateSelected,
                              clubIdSelected,
                              userRole == Role.responsabileCircolo
                                  ? []
                                  : clubs.value?.data ?? []),
                          isSelected: filteredSelected.state !=
                              FilterdSelected.notSelected,
                        ),
                        const SizedBox(width: 5),
                        UtilityButton(
                          icon: Icon(
                            Icons.swap_vert,
                            color: Theme.of(context).colorScheme.secondary,
                            size: 22,
                          ),
                          onPressed: () => helpers.showSortingOptions(
                              context, ref, orderSelected),
                          isSelected:
                              orderSelected.state != OrderType.notSelected,
                        ),
                        const SizedBox(width: 5),
                        UtilityButton(
                          icon: Icon(
                            Icons.file_download_outlined,
                            color: Theme.of(context).colorScheme.secondary,
                            size: 22,
                          ),
                          onPressed: () {
                            // Azione quando il pulsante Person viene premuto
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 50,
        height: 50,
        child: FloatingActionButton(
          onPressed: () {
            formState.reset();
            ref.read(isMemberDetailsPageProvider.notifier).state = false;
            ref.read(isMainAppBarProvider.notifier).state = false;
            ref.read(isMemberPageProvider.notifier).state = !isMemberPage;
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          child:
              Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
    );
  }
}
