import 'package:alfi_gest/models/club.dart';
import 'package:alfi_gest/providers/members_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MembersPageHelpers {
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
                        selected: orderSelected.state == OrderType.notSelected
                            ? true
                            : false,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 0),
                        title: Row(
                          children: [
                            Text(
                              'Nessuna',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const Spacer(),
                            if (orderSelected.state == OrderType.notSelected)
                              Icon(
                                Icons.check,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                          ],
                        ),
                        onTap: () {
                          ref.read(orderTypeProvider.notifier).state =
                              OrderType.notSelected;
                          ref
                              .read(filteredMembersProvider.notifier)
                              .orderByLastName(
                                  orderType: OrderType.notSelected);
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
                        selected: orderSelected.state == OrderType.ascending
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
                            if (orderSelected.state == OrderType.ascending)
                              Icon(
                                Icons.check,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                          ],
                        ),
                        onTap: () {
                          ref.read(orderTypeProvider.notifier).state =
                              OrderType.ascending;
                          ref
                              .read(filteredMembersProvider.notifier)
                              .orderByLastName(orderType: OrderType.ascending);
                          Navigator.pop(context); // Chiude la bottom modal
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      child: ListTile(
                        selected: orderSelected.state == OrderType.descending
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
                            if (orderSelected.state == OrderType.descending)
                              Icon(
                                Icons.check,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                          ],
                        ),
                        onTap: () {
                          ref.read(orderTypeProvider.notifier).state =
                              OrderType.descending;
                          ref
                              .read(filteredMembersProvider.notifier)
                              .orderByLastName(orderType: OrderType.descending);
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
      StateController cardStateSelected,
      StateController clubIdSelected,
      List<Club> clubs) {
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
                                FilterdSelected.notSelected)
                              Icon(
                                Icons.check,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                          ],
                        ),
                        onTap: () {
                          ref.read(filteredSelectedProvider.notifier).state =
                              FilterdSelected.notSelected;
                          ref.read(cardStateProvider.notifier).state =
                              CardState.notSelected;
                          ref.read(clubIdSelectedProvider.notifier).state = "";
                          ref
                              .read(filteredMembersProvider.notifier)
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
                              'Scadenza',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const Spacer(),
                            Icon(
                              Icons.chevron_right,
                              color:
                                  Theme.of(context).colorScheme.outlineVariant,
                              size: 24,
                            ),
                          ],
                        ),
                        onTap: () {
                          ref.read(filteredSelectedProvider.notifier).state =
                              FilterdSelected.expiration;
                          Navigator.pop(context);

                          showModalBottomSheet(
                            context: context,
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 28),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 0),
                                          child: Row(
                                            children: [
                                              TextButton(
                                                child: Row(
                                                  children: [
                                                    Icon(Icons
                                                        .chevron_left), // Add the icon as a prefix
                                                    Text(
                                                      'Scadenza',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleMedium!
                                                          .copyWith(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .secondary,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  showFilterOptions(
                                                      context,
                                                      ref,
                                                      filteredSelected,
                                                      orderSelected,
                                                      cardStateSelected,
                                                      clubIdSelected,
                                                      clubs);
                                                },
                                              ),
                                              const Spacer(),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                  width: 1.0,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .outlineVariant,
                                                ),
                                              ),
                                            ),
                                            child: ListTile(
                                              selected: orderSelected.state ==
                                                      OrderType.notSelected
                                                  ? true
                                                  : false,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 0),
                                              title: Row(
                                                children: [
                                                  Text(
                                                    'Scaduta',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge,
                                                  ),
                                                  const Spacer(),
                                                  if (cardStateSelected.state ==
                                                      CardState.expiried)
                                                    Icon(
                                                      Icons.check,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                    ),
                                                ],
                                              ),
                                              onTap: () {
                                                ref
                                                    .read(cardStateProvider
                                                        .notifier)
                                                    .state = CardState.expiried;
                                                ref
                                                    .read(
                                                        filteredMembersProvider
                                                            .notifier)
                                                    .filterMembers(
                                                        clubId: clubIdSelected
                                                            .state,
                                                        cardState:
                                                            cardStateSelected
                                                                .state);
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                    width: 1.0,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .outlineVariant),
                                              ),
                                            ),
                                            child: ListTile(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 0),
                                              title: Row(
                                                children: [
                                                  Text(
                                                    'Sospesa',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge,
                                                  ),
                                                  const Spacer(),
                                                  if (cardStateSelected.state ==
                                                      CardState.suspend)
                                                    Icon(
                                                      Icons.check,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                    ),
                                                ],
                                              ),
                                              onTap: () {
                                                ref
                                                    .read(cardStateProvider
                                                        .notifier)
                                                    .state = CardState.suspend;
                                                ref
                                                    .read(
                                                        filteredMembersProvider
                                                            .notifier)
                                                    .filterMembers(
                                                        clubId: clubIdSelected
                                                            .state,
                                                        cardState:
                                                            cardStateSelected
                                                                .state);
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          child: Container(
                                            child: ListTile(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 0),
                                              selectedColor: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              title: Row(
                                                children: [
                                                  Text(
                                                    'Attiva',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge,
                                                  ),
                                                  const Spacer(),
                                                  if (cardStateSelected.state ==
                                                      CardState.active)
                                                    Icon(
                                                      Icons.check,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                    ),
                                                ],
                                              ),
                                              onTap: () {
                                                ref
                                                    .read(cardStateProvider
                                                        .notifier)
                                                    .state = CardState.active;
                                                ref
                                                    .read(
                                                        filteredMembersProvider
                                                            .notifier)
                                                    .filterMembers(
                                                        clubId: clubIdSelected
                                                            .state,
                                                        cardState:
                                                            cardStateSelected
                                                                .state);
                                                Navigator.pop(context);
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
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListTile(
                      selected: filteredSelected.state == FilterdSelected.club
                          ? true
                          : false,
                      selectedColor: Theme.of(context).colorScheme.primary,
                      title: Row(
                        children: [
                          Text(
                            'Circolo',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const Spacer(),
                          Icon(
                            Icons.chevron_right,
                            color: Theme.of(context).colorScheme.outlineVariant,
                            size: 24,
                          ),
                        ],
                      ),
                      onTap: () {
                        ref.read(filteredSelectedProvider.notifier).state =
                            FilterdSelected.club;
                        Navigator.pop(context);

                        showModalBottomSheet(
                          context: context,
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 28),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 0),
                                        child: Row(
                                          children: [
                                            TextButton(
                                              child: Row(
                                                children: [
                                                  Icon(Icons.chevron_left),
                                                  Text(
                                                    'Circolo',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium!
                                                        .copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .secondary,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                showFilterOptions(
                                                    context,
                                                    ref,
                                                    filteredSelected,
                                                    orderSelected,
                                                    cardStateSelected,
                                                    clubIdSelected,
                                                    clubs);
                                              },
                                            ),
                                            const Spacer(),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                width: 1.0,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .outlineVariant,
                                              ),
                                            ),
                                          ),
                                          child: ListTile(
                                            selected: orderSelected.state ==
                                                    OrderType.notSelected
                                                ? true
                                                : false,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 0),
                                            title: Row(
                                              children: [
                                                Text(
                                                  clubs.first.nameClub,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge,
                                                ),
                                                const Spacer(),
                                                if (clubIdSelected.state ==
                                                    clubs.first.idClub)
                                                  Icon(
                                                    Icons.check,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                  ),
                                              ],
                                            ),
                                            onTap: () {
                                              ref
                                                  .read(clubIdSelectedProvider
                                                      .notifier)
                                                  .state = clubs.first.idClub;
                                              ref
                                                  .read(filteredMembersProvider
                                                      .notifier)
                                                  .filterMembers(
                                                      clubId:
                                                          clubs.first.idClub,
                                                      cardState:
                                                          cardStateSelected
                                                              .state);

                                              Navigator.pop(context);
                                            },
                                          ),
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          for (int i = 1;
                                              i < clubs.length - 1;
                                              i++) ...[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                      width: 1.0,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .outlineVariant,
                                                    ),
                                                  ),
                                                ),
                                                child: ListTile(
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 20,
                                                          vertical: 0),
                                                  title: Row(
                                                    children: [
                                                      Text(
                                                        clubs[i].nameClub,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge,
                                                      ),
                                                      const Spacer(),
                                                      if (clubIdSelected
                                                              .state ==
                                                          clubs[i].idClub)
                                                        Icon(
                                                          Icons.check,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                        ),
                                                    ],
                                                  ),
                                                  onTap: () {
                                                    ref
                                                        .read(
                                                            clubIdSelectedProvider
                                                                .notifier)
                                                        .state = clubs[
                                                            i]
                                                        .idClub;
                                                    ref
                                                        .read(
                                                            filteredMembersProvider
                                                                .notifier)
                                                        .filterMembers(
                                                            clubId:
                                                                clubs[i].idClub,
                                                            cardState:
                                                                cardStateSelected
                                                                    .state);
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: Container(
                                          child: ListTile(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 0),
                                            selectedColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            title: Row(
                                              children: [
                                                Text(
                                                  clubs.last.nameClub,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge,
                                                ),
                                                const Spacer(),
                                                if (clubIdSelected.state ==
                                                    clubs.last.idClub)
                                                  Icon(
                                                    Icons.check,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                  ),
                                              ],
                                            ),
                                            onTap: () {
                                              ref
                                                  .read(clubIdSelectedProvider
                                                      .notifier)
                                                  .state = clubs.last.idClub;
                                              ref
                                                  .read(filteredMembersProvider
                                                      .notifier)
                                                  .filterMembers(
                                                      clubId: clubs.last.idClub,
                                                      cardState:
                                                          cardStateSelected
                                                              .state);
                                              Navigator.pop(context);
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
                      },
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
