import 'package:alfi_gest/core/pair.dart';
import 'package:alfi_gest/helpers/string_helper.dart';
import 'package:alfi_gest/models/enums.dart';
import 'package:alfi_gest/models/member.dart';
import 'package:alfi_gest/pages/members/members_helpers.dart';
import 'package:alfi_gest/pages/members/members_page.dart';
import 'package:alfi_gest/providers/clubs/clubs_provider.dart';
import 'package:alfi_gest/providers/member/member_data_provider.dart';
import 'package:alfi_gest/providers/member/member_role_provider.dart';
import 'package:alfi_gest/providers/member/members_data_provider.dart';
import 'package:alfi_gest/services/member_service.dart';
import 'package:alfi_gest/widgets/list_views_items.dart';
import 'package:alfi_gest/widgets/utility_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alfi_gest/screens/main_screen.dart';

import 'package:alfi_gest/pages/books/books_page.dart';

class BookDetailsPage extends ConsumerStatefulWidget {
  const BookDetailsPage({Key? key}) : super(key: key);

  @override
  BookDetailsPageState createState() => BookDetailsPageState();
}

class BookDetailsPageState extends ConsumerState<BookDetailsPage> {
  BookDetailsPageState();

  @override
  Widget build(BuildContext context) {
    final bookSelected = ref.watch(bookSelectedProvider);
    final clubs = ref.watch(clubsProvider);
    final userRole = ref.watch(roleProvider);
    final orderSelected = ref.watch(orderTypeProvider.notifier);
    final userData = ref.watch(memberProvider);
    MembersPageHelpers helpers = MembersPageHelpers();

    List<Member> getBookMembersByType(BookType bookType) {
      final bookMembers =
          userRole == Role.responsabileCircolo && userData != null
              ? ref
                  .watch(filteredMembersProvider)
                  .where((m) =>
                      !m.isSuspend &&
                      m.idClub == userData.idClub &&
                      DateTime.now().isBefore(m.expirationDate) &&
                      (bookType == BookType.libroSocie ||
                          ((bookType == BookType.libroSocieVolontarie &&
                                  m.volunteerMember) ||
                              (bookType == BookType.libroSocieLavoratrici &&
                                  m.workingPartner))))
                  .toList()
              : ref
                  .watch(filteredMembersProvider)
                  .where((m) =>
                      !m.isSuspend &&
                      DateTime.now().isBefore(m.expirationDate) &&
                      (bookType == BookType.libroSocie ||
                          ((bookType == BookType.libroSocieVolontarie &&
                                  m.volunteerMember) ||
                              (bookType == BookType.libroSocieLavoratrici &&
                                  m.workingPartner))))
                  .toList();

      return bookMembers;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        toolbarHeight: 70,
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          color: Theme.of(context).colorScheme.secondary,
          onPressed: () {
            ref.read(isBookPageProvider.notifier).state = true;
            ref.read(isMainAppBarProvider.notifier).state = true;
            ref.read(isBookDetailsPageProvider.notifier).state = false;
          },
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 20.0),
            child: Text(
              displayStringForBookType(bookSelected),
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
          ),
        ],
      ),
      body: getBookMembersByType(bookSelected).length <= 0
          ? Center(
              heightFactor: 2.5,
              child: Text(
                "Nessun risultato",
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
              ))
          : Stack(
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Column(
                      children: [
                        ListViewItem(
                          itemCount: getBookMembersByType(bookSelected).length,
                          items: getBookMembersByType(bookSelected),
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
                          isDeleteItemPermesse: false,
                          showIconRoles: false,
                        ),
                      ],
                    ),
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
    );
  }
}
