import 'dart:async';
import 'package:alfi_gest/core/pair.dart';
import 'package:alfi_gest/core/result.dart';
import 'package:alfi_gest/helpers/string_helper.dart';
import 'package:alfi_gest/models/enums.dart';
import 'package:alfi_gest/models/identifiable.dart';
import 'package:alfi_gest/providers/member/create_member_provider.dart';
import 'package:alfi_gest/services/member_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListViewItem<T> extends ConsumerStatefulWidget {
  final int itemCount;
  final List<Identifiable> items;
  final Function(Identifiable) onTapListTile;
  final Future<Result<Identifiable>> Function(Identifiable) callServiceItem;
  final String nameOfItemForMessage;
  final Pair<String, Color> statusDataFirst;
  final Pair<String, Color> statusDataSecond;
  final Color statusColorFirst;
  final Color statusColorSecond;
  final Pair<Color, Color> titleConditionColors;
  final Pair<Color, Color> subtitleConditionColors;
  final List<Identifiable>? itemsAdditional;
  final Role? userRole;
  final bool isDeleteItemPermesse;
  final bool showIconRoles;

  ListViewItem({
    required this.itemCount,
    required this.items,
    required this.callServiceItem,
    required this.onTapListTile,
    required this.nameOfItemForMessage,
    required this.statusColorFirst,
    required this.statusColorSecond,
    required this.statusDataFirst,
    required this.statusDataSecond,
    required this.titleConditionColors,
    required this.subtitleConditionColors,
    required this.isDeleteItemPermesse,
    required this.showIconRoles,
    this.itemsAdditional,
    this.userRole,
  });

  @override
  _ListViewItemState createState() => _ListViewItemState();
}

class _ListViewItemState extends ConsumerState<ListViewItem> {
  @override
  Widget build(BuildContext context) {
    final itemsCopy = List<Identifiable>.from(widget.items);
    final itemsAdditionalCopy = widget.itemsAdditional == null
        ? null
        : List<Identifiable>.from(widget.itemsAdditional!);
    return Expanded(
      child: ListView.separated(
        itemCount: itemsCopy.length + 1,
        itemBuilder: (context, index) {
          if (index < itemsCopy.length) {
            final item = itemsCopy[index];
            final itemId = Key(item.id);

            var additionalName = itemsAdditionalCopy != null
                ? itemsAdditionalCopy
                    .where((element) => element.id == item.foreignKey)
                    .firstOrNull
                    ?.title
                : '';

            return FutureBuilder(
              future: MemberService().getMemberRole(item.id),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: LinearProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text(
                      'Error: ${snapshot.error}'); // Show error message if any error occurred
                } else {
                  return widget.isDeleteItemPermesse
                      ? _buildDismissble(
                          context,
                          _buildListTile(
                              context,
                              item,
                              additionalName,
                              snapshot
                                  .data), // Use snapshot.data to get the member role
                          item,
                          itemId,
                          ref)
                      : _buildListTile(
                          context, item, additionalName, snapshot.data);
                }
              },
            );
          }
          return const SizedBox(height: 80);
        },
        separatorBuilder: (context, index) => Divider(),
      ),
    );
  }

  ListTile _buildListTile(BuildContext context, Identifiable item,
      String? additionalName, Result<Role> memberRole) {
    return ListTile(
      tileColor: getStatusColor(
        statusColors: {
          item.isSuspend: widget.statusColorFirst,
          item.isRemoved: widget.statusColorSecond,
        },
        context: context,
      ),
      title: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: getGenericText(
          text: item.title,
          conditionColors: {
            item.isRemoved: widget.titleConditionColors,
          },
          style: Theme.of(context).textTheme.bodyLarge!,
          context: context,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: getGenericText(
          text: widget.userRole == null
              ? item.subTitle
              : "$additionalName - N° ${item.subTitle}",
          conditionColors: {
            item.isRemoved: widget.subtitleConditionColors,
          },
          style: Theme.of(context).textTheme.bodyMedium!,
          context: context,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      trailing: widget.showIconRoles
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      right: 10), // Aggiungi spazio a destra
                  child: Row(
                    // 1 icona se responsabile di circolo 2 se responsabile nazionale
                    children: [
                      if (memberRole.data == Role.amministratore ||
                          memberRole.data == Role.segretariaNazionale)
                        Icon(
                          Icons.military_tech,
                          color: Theme.of(context).primaryColor,
                        ),
                      if (memberRole.data == Role.amministratore ||
                          memberRole.data == Role.responsabileCircolo ||
                          memberRole.data == Role.segretariaNazionale)
                        Icon(
                          Icons.military_tech,
                          color: Theme.of(context).primaryColor,
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: statusIndicator(
                    statusData: {
                      item.isSuspend: widget.statusDataFirst,
                      item.isRemoved: widget.statusDataSecond,
                    },
                    context: context,
                  ),
                ),
              ],
            )
          : null,
      onTap: () =>
          widget.isDeleteItemPermesse ? widget.onTapListTile(item) : () {},
    );
  }

  Widget _buildDismissble(BuildContext context, ListTile listTile,
      Identifiable item, Key itemId, WidgetRef ref) {
    return Dismissible(
      key: itemId,
      background: Container(
        color: Theme.of(context).colorScheme.errorContainer, // Change as needed
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
        color: Theme.of(context).colorScheme.errorContainer,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Icon(Icons.delete,
                color: Theme.of(context).colorScheme.onTertiary),
          ),
        ),
      ),
      confirmDismiss: (direction) async {
        final removedMember = item;
        final removedMemberIndex = widget.items.indexOf(item);
        setState(() {
          widget.items.removeAt(removedMemberIndex);
        });
        final countdownController = StreamController<int>();
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
            backgroundColor: Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 3),
            content: StreamBuilder<int>(
              stream: countdownController.stream,
              builder: (context, snapshot) {
                return Text(
                    '${StringHelper.splitOnCaps(widget.nameOfItemForMessage)} si cancella in ${snapshot.data ?? 3}',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary));
              },
            ),
            action: SnackBarAction(
              label: 'Annulla',
              onPressed: () {
                shouldDismiss = false;
                setState(() {
                  widget.items.insert(removedMemberIndex, removedMember);
                  // isDismissed = false;
                });
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );

        await Future.delayed(Duration(seconds: 3)); // Wait for 3 seconds
        ref.read(isLoadingProvider.notifier).state = true;
        var result = await widget.callServiceItem(item);

        ref.read(isLoadingProvider.notifier).state = false;
        if (!result.valid) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              content: Text(
                  result.error ??
                      "Errore nella cancellazione del ${widget.nameOfItemForMessage}",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onTertiary)),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        return shouldDismiss; // Return the value of shouldDismiss
      },
      child: listTile,
    );
  }

  Widget? statusIndicator({
    required Map<bool, Pair<String, Color>> statusData,
    required BuildContext context,
  }) {
    // If all values are false, return null
    if (statusData.keys.every((k) => k == false)) {
      return null;
    }

    // Return the widget associated with the first true value
    for (var entry in statusData.entries) {
      if (entry.key) {
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
            color: entry.value.second, // Use the color from the pair
          ),
          child: Text(
            entry.value.first, // Use the text from the pair
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onTertiary,
                ),
          ),
        );
      }
    }

    // Return null if none of the conditions are met
    // This point in the code should never be reached thanks to the previous checks
    return null;
  }

  Color getStatusColor({
    required Map<bool, Color> statusColors,
    required BuildContext context,
  }) {
    // If all values are false, return transparent
    if (statusColors.keys.every((k) => k == false)) {
      return Colors.transparent;
    }

    // Return the color associated with the first true value
    for (var entry in statusColors.entries) {
      if (entry.key) {
        return entry.value;
      }
    }

    // Default to surface if none of the conditions are met
    // This point in the code should never be reached thanks to the previous checks
    return Theme.of(context).colorScheme.surface;
  }

  Text getGenericText({
    required String text,
    required Map<bool, Pair<Color, Color>> conditionColors,
    required TextStyle style,
    required BuildContext context,
  }) {
    // If all conditions are false, return the text with the default color
    if (conditionColors.keys.every((k) => k == false)) {
      return Text(
        text,
        style: style.copyWith(
          color: Theme.of(context).colorScheme.secondary, // Default color
        ),
      );
    }

    // Return the text with the color associated with the first true condition
    for (var entry in conditionColors.entries) {
      if (entry.key) {
        return Text(
          text,
          style: style.copyWith(
            color: entry.value.first, // Use the first color from the pair
          ),
        );
      }
    }

    // Return the text with the default color if none of the conditions are met
    // This point in the code should never be reached thanks to the previous checks
    return Text(
      text,
      style: style.copyWith(
        color: Theme.of(context).colorScheme.secondary, // Default color
      ),
    );
  }
}
