import 'package:alfi_gest/core/pair.dart';
import 'package:alfi_gest/models/club.dart';
import 'package:alfi_gest/models/enums.dart';
import 'package:alfi_gest/pages/clubs/club_details_page.dart';
import 'package:alfi_gest/pages/clubs/clubs_helpers.dart';
import 'package:alfi_gest/providers/auth/user_data_provider.dart';
import 'package:alfi_gest/providers/clubs/club_data_provider.dart';
import 'package:alfi_gest/providers/clubs/clubs_provider.dart';
import 'package:alfi_gest/providers/clubs/create_club_provider.dart';
import 'package:alfi_gest/providers/member/member_role_provider.dart';
import 'package:alfi_gest/screens/main_screen.dart';
import 'package:alfi_gest/services/club_service.dart';
import 'package:alfi_gest/widgets/list_views_items.dart';
import 'package:alfi_gest/widgets/search_bar_custom.dart';
import 'package:alfi_gest/widgets/utility_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final clubVoidField = Club.empty();
final clubSelected = StateProvider<Club>((ref) => clubVoidField);

/// A page widget that displays a list of clubs.
///
/// This widget is a consumer widget, which means it rebuilds when the specified
/// dependencies change. It is used to display the clubs page in the application.
class ClubsPage extends ConsumerWidget {
  const ClubsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredClubs = ref.watch(filteredClubsProvider);
    final formState = ref.read(createClubFormProvider);
    final isClubPage = ref.watch(isClubPageProvider);
    final user = ref.watch(userProvider);
    final userRole = ref.watch(roleProvider);
    final orderSelected = ref.watch(orderClubsTypeProvider.notifier);
    final filteredSelected = ref.watch(filteredClubsSelectedProvider.notifier);
    if (userRole == Role.responsabileCircolo) {
      Future(() {
        ref.read(clubSelected.notifier).state = filteredClubs
            .where((c) => c.idMemberManager == user.value!.uid)
            .first;
      });
      // ref.read(isMainAppBarProvider.notifier).state = false;
      // ref.read(isClubDetailsPageProvider.notifier).state = true;
    }
    ClubsPageHelpers helpers = ClubsPageHelpers();

    return userRole == Role.responsabileCircolo
        ? const ClubDetailsPage()
        : Scaffold(
            body: RefreshIndicator(
              onRefresh: () async {
                ref
                    .read(filteredClubsProvider.notifier)
                    .filterClubs(filterSelected: filteredSelected.state);
              },
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsetsDirectional.only(top: 25),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        SearchBarCustom(
                          hintText: "Cerca circolo",
                          onQueryChanged: (query) {
                            // Aggiorna la query di ricerca
                            ref.read(searchQueryClubProvider.notifier).state =
                                query;

                            // Filtra i membri in base alla query
                            ref
                                .read(filteredClubsProvider.notifier)
                                .searchClub(query);
                          },
                        ),
                        const SizedBox(height: 16),
                        ListViewItem(
                          itemCount: filteredClubs.length,
                          items: filteredClubs,
                          callServiceItem: (identifiable) =>
                              ClubService().deleteClub(identifiable.id),
                          onTapListTile: (identifiable) {
                            ref.read(isMainAppBarProvider.notifier).state =
                                false;
                            // Naviga alla pagina del circolo
                            ref.read(clubSelected.notifier).state =
                                identifiable as Club;
                            ref.read(isClubDetailsPageProvider.notifier).state =
                                true;
                            ref.read(isClubPageProvider.notifier).state = false;
                          },
                          nameOfItemForMessage: "circolo",
                          statusDataSecond: Pair(
                              'Chiuso', Theme.of(context).colorScheme.tertiary),
                          statusDataFirst: Pair('Sospeso',
                              Theme.of(context).colorScheme.onSurfaceVariant),
                          statusColorFirst:
                              Theme.of(context).colorScheme.surfaceVariant,
                          statusColorSecond:
                              Theme.of(context).colorScheme.surfaceVariant,
                          titleConditionColors: Pair(
                            Theme.of(context).colorScheme.secondary,
                            Theme.of(context).colorScheme.secondary,
                          ),
                          subtitleConditionColors: Pair(
                            Theme.of(context).colorScheme.secondary,
                            Theme.of(context).colorScheme.secondary,
                          ),
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
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  size: 22,
                                ),
                                onPressed: () => helpers.showFilterOptions(
                                    context,
                                    ref,
                                    filteredSelected,
                                    orderSelected),
                                isSelected: filteredSelected.state !=
                                    FilterdClubSelected.notSelected,
                              ),
                              const SizedBox(width: 4),
                              UtilityButton(
                                icon: Icon(
                                  Icons.swap_vert,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  size: 22,
                                ),
                                onPressed: () => helpers.showSortingOptions(
                                    context, ref, orderSelected),
                                isSelected: orderSelected.state !=
                                    OrderClubsType.notSelected,
                              ),
                              const SizedBox(width: 4),
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
                  ref.read(isClubDetailsPageProvider.notifier).state = false;
                  ref.read(isMainAppBarProvider.notifier).state = false;
                  ref.read(isClubPageProvider.notifier).state = !isClubPage;
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Icon(Icons.add,
                    color: Theme.of(context).colorScheme.onPrimary),
              ),
            ),
          );
  }
}
