import 'package:alfi_gest/providers/clubs/club_data_provider.dart';
import 'package:alfi_gest/providers/clubs/clubs_provider.dart';
import 'package:alfi_gest/providers/member/members_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClubsPageHelpers {
  void showSortingOptions(
      BuildContext context, WidgetRef ref, StateController orderSelected) {
    showModalBottomSheet(
      context: context,
      barrierLabel: "Ordina",
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Text('Ordina',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                )),
                        const Spacer(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1.0,
                            color: Theme.of(context).colorScheme.outlineVariant,
                          ),
                        ),
                      ),
                      child: ListTile(
                        selected:
                            orderSelected.state == OrderClubsType.notSelected
                                ? true
                                : false,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 0),
                        title: Row(
                          children: [
                            Text(
                              'Nessuno',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const Spacer(),
                            if (orderSelected.state ==
                                OrderClubsType.notSelected)
                              Icon(
                                Icons.check,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                          ],
                        ),
                        onTap: () {
                          ref.read(orderClubsTypeProvider.notifier).state =
                              OrderClubsType.notSelected;
                          ref
                              .read(filteredClubsProvider.notifier)
                              .orderByLastName(
                                  orderType: OrderClubsType.notSelected);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1.0,
                            color: Theme.of(context).colorScheme.outlineVariant,
                          ),
                        ),
                      ),
                      child: ListTile(
                        selected:
                            orderSelected.state == OrderClubsType.ascending
                                ? true
                                : false,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 0),
                        title: Row(
                          children: [
                            Text(
                              'A-Z',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const Spacer(),
                            if (orderSelected.state == OrderClubsType.ascending)
                              Icon(
                                Icons.check,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                          ],
                        ),
                        onTap: () {
                          var oredrType =
                              ref.read(orderClubsTypeProvider.notifier).state;
                          var result = oredrType != OrderClubsType.ascending
                              ? OrderClubsType.ascending
                              : OrderClubsType.notSelected;
                          ref.read(orderClubsTypeProvider.notifier).state =
                              result;
                          ref
                              .read(filteredClubsProvider.notifier)
                              .orderByLastName(orderType: result);
                          Navigator.pop(context); // Chiude la bottom modal
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      child: ListTile(
                        selected:
                            orderSelected.state == OrderClubsType.descending
                                ? true
                                : false,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 0),
                        selectedColor: Theme.of(context).colorScheme.primary,
                        title: Row(
                          children: [
                            Text(
                              'Z-A',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const Spacer(),
                            if (orderSelected.state ==
                                OrderClubsType.descending)
                              Icon(
                                Icons.check,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                          ],
                        ),
                        onTap: () {
                          var oredrType =
                              ref.read(orderClubsTypeProvider.notifier).state;
                          var result = oredrType != OrderClubsType.descending
                              ? OrderClubsType.descending
                              : OrderClubsType.notSelected;
                          ref.read(orderClubsTypeProvider.notifier).state =
                              result;
                          ref
                              .read(filteredClubsProvider.notifier)
                              .orderByLastName(orderType: result);
                          Navigator.pop(context); // Chiude la bottom modal
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showFilterOptions(
    BuildContext context,
    WidgetRef ref,
    StateController filteredSelected,
    StateController orderSelected,
  ) {
    showModalBottomSheet(
      context: context,
      barrierLabel: "Filtri",
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Text('Filtri',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                )),
                        const Spacer(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1.0,
                            color: Theme.of(context).colorScheme.outlineVariant,
                          ),
                        ),
                      ),
                      child: ListTile(
                        title: Row(
                          children: [
                            Text(
                              'Nessuno',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const Spacer(),
                            if (filteredSelected.state ==
                                FilterdClubSelected.notSelected)
                              Icon(
                                Icons.check,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                          ],
                        ),
                        onTap: () {
                          ref
                              .read(filteredClubsSelectedProvider.notifier)
                              .state = FilterdClubSelected.notSelected;

                          ref.read(clubIdSelectedProvider.notifier).state = "";
                          ref
                              .read(filteredClubsProvider.notifier)
                              .resetFilters();
                          Navigator.pop(context); // Chiude la bottom modal
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1.0,
                            color: Theme.of(context).colorScheme.outlineVariant,
                          ),
                        ),
                      ),
                      child: ListTile(
                          title: Row(
                            children: [
                              Text(
                                'Mostra Sospeso',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const Spacer(),
                              if (filteredSelected.state ==
                                  FilterdClubSelected.supended)
                                Icon(
                                  Icons.check,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                            ],
                          ),
                          onTap: () {
                            ref
                                .read(filteredClubsSelectedProvider.notifier)
                                .state = FilterdClubSelected.supended;
                            ref
                                .read(filteredClubsProvider.notifier)
                                .filterClubs(
                                    filterSelected:
                                        FilterdClubSelected.supended);
                            Navigator.pop(context);
                          }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1.0,
                            color: Theme.of(context).colorScheme.outlineVariant,
                          ),
                        ),
                      ),
                      child: ListTile(
                          title: Row(
                            children: [
                              Text(
                                'Mostra Chiuso',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const Spacer(),
                              if (filteredSelected.state ==
                                  FilterdClubSelected.closed)
                                Icon(
                                  Icons.check,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                            ],
                          ),
                          onTap: () {
                            ref
                                .read(filteredClubsSelectedProvider.notifier)
                                .state = FilterdClubSelected.closed;
                            ref
                                .read(filteredClubsProvider.notifier)
                                .filterClubs(
                                    filterSelected: FilterdClubSelected.closed);
                            Navigator.pop(context);
                          }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
