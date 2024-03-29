import 'package:alfi_gest/models/enums.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final Role userRole;

  CustomBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
    required this.userRole,
  });
  Widget _buildIconBackground(
      BuildContext context, IconData icon, int index, int currentIndex) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        color: currentIndex == index
            ? Theme.of(context).colorScheme.inversePrimary
            : Colors.transparent,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(icon),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: onTap,
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      selectedItemColor: Theme.of(context).colorScheme.secondary,
      unselectedItemColor: Theme.of(context).colorScheme.secondary,
      items: getItems(context, userRole),
    );
  }

  List<BottomNavigationBarItem> getItems(BuildContext context, Role userRole) {
    int idx = userRole == Role.socia
        ? 1
        : userRole == Role.responsabileCircolo
            ? 3
            : 4;
    List<BottomNavigationBarItem> items = [
      BottomNavigationBarItem(
        icon:
            _buildIconBackground(context, Icons.home_outlined, 0, currentIndex),
        label: '',
        tooltip: 'Dashboard',
      ),
      BottomNavigationBarItem(
        icon: _buildIconBackground(
            context,
            userRole == Role.responsabileCircolo
                ? Icons.bookmarks_outlined
                : Icons.notifications_outlined,
            idx,
            currentIndex),
        label: '',
        tooltip: userRole == Role.responsabileCircolo
            ? 'Libri Circolo'
            : 'Notifiche',
      ),
    ];

    if (userRole == Role.amministratore ||
        userRole == Role.segretariaNazionale) {
      items.insert(
          1,
          BottomNavigationBarItem(
            icon: _buildIconBackground(
                context, Icons.people_alt_outlined, 1, currentIndex),
            label: '',
            tooltip: 'Soci',
          ));
      items.insert(
          2,
          BottomNavigationBarItem(
            icon: _buildIconBackground(
                context, Icons.place_outlined, 2, currentIndex),
            label: '',
            tooltip: 'Circoli',
          ));
      items.insert(
          3,
          BottomNavigationBarItem(
            icon: _buildIconBackground(
                context, Icons.bookmarks_outlined, 3, currentIndex),
            label: '',
            tooltip: 'Libri Circolo',
          ));
    }
    if (userRole == Role.responsabileCircolo) {
      items.insert(
          1,
          BottomNavigationBarItem(
            icon: _buildIconBackground(
                context, Icons.people_alt_outlined, 1, currentIndex),
            label: '',
            tooltip: 'Soci',
          ));

      items.insert(
          2,
          BottomNavigationBarItem(
            icon: _buildIconBackground(
                context, Icons.place_outlined, 2, currentIndex),
            label: '',
            tooltip: 'Circoli',
          ));
    }

    return items;
  }
}
