import 'package:alfi_gest/pages/clubs/clubs_page.dart';
import 'package:alfi_gest/pages/create_member_page.dart';
import 'package:alfi_gest/pages/dashboard_page.dart';
import 'package:alfi_gest/pages/clubs/books_club_page.dart';
import 'package:alfi_gest/pages/members/member_details_page.dart';
import 'package:alfi_gest/pages/notifiche_page.dart';
import 'package:alfi_gest/pages/members/members_page.dart';
//import 'package:alfi_gest/providers/auth_provider.dart';
//import 'package:alfi_gest/providers/members_data_provider.dart';
import 'package:alfi_gest/providers/user_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentIndexProvider = StateProvider<int>((ref) => 0);
final isMemberPageProvider = StateProvider<bool>((ref) => true);
final isMemberDetailsPageProvider = StateProvider<bool>((ref) => false);
final isMemberDetailsUpdatePageProvider = StateProvider<bool>((ref) => false);
final isMemberReplaceCardProvider = StateProvider<bool>((ref) => false);
final isMemberReadyFor = StateProvider<bool>((ref) => false);

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  Widget _buildIconBackground(
      BuildContext context, IconData icon, int index, int currentIndex) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 20, vertical: 4), // Aggiungi padding se necessario
      decoration: BoxDecoration(
        color: currentIndex == index
            ? Theme.of(context).colorScheme.inversePrimary
            : Colors.transparent,
        borderRadius:
            BorderRadius.circular(15), // Raggio di curvatura dei bordi
      ),
      child: Icon(icon),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentIndexProvider);
    final isMemberPage = ref.watch(isMemberPageProvider);
    final isMemberDetailsPage = ref.watch(isMemberDetailsPageProvider);
    // String memberName = "";
    final userData = ref.watch(userDataProvider);

    // final memberRole = ref.watch(roleProvider);
    // if (userData == null) {
    //   // Gestisci il caso in cui _userData è null
    // } else if (userData.givenName.isEmpty) {
    //   memberName = userData.legalName;
    // } else {
    //   memberName = userData.givenName;
    // }

    return Scaffold(
      appBar: isMemberPage
          ? AppBar(
              title: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: Theme.of(context).brightness == Brightness.light
                        ? const AssetImage('assets/images/logo-light-small.png')
                        : const AssetImage('assets/images/logo-dark-small.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: userData != null
                        ? Text(
                            '${userData.legalName[0]}${userData.lastName[0]}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : Container(),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                ),
              ],
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            )
          : null,
      body: userData == null
          ? Center(
              child: CircularProgressIndicator(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ))
          : IndexedStack(
              index: currentIndex,
              children: [
                // Your different pages/widgets go here
                const DashboardPage(),
                isMemberPage
                    ? const MembersPage()
                    : isMemberDetailsPage
                        ? const MemberDetailsPage()
                        : const CreateMemberPage(),
                const ClubsPage(),
                const BooksClubPage(),
                const NotifichePage(),
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          if (currentIndex != index) {
            ref.read(currentIndexProvider.notifier).state = index;
            if (index != 1) {
              ref.read(isMemberPageProvider.notifier).state = true;
            }
          }
        },
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        selectedItemColor:
            Theme.of(context).colorScheme.secondary, // Colore dell'icona
        unselectedItemColor: Theme.of(context).colorScheme.secondary,
        // Colore dell'icona non selezionata
        items: [
          BottomNavigationBarItem(
            icon: _buildIconBackground(
                context, Icons.home_outlined, 0, currentIndex),
            label: '',
            tooltip: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: _buildIconBackground(
                context, Icons.people_alt_outlined, 1, currentIndex),
            label: '',
            tooltip: 'Soci',
          ),
          BottomNavigationBarItem(
            icon: _buildIconBackground(
                context, Icons.place_outlined, 2, currentIndex),
            label: '',
            tooltip: 'Circoli',
          ),
          BottomNavigationBarItem(
            icon: _buildIconBackground(
                context, Icons.bookmarks_outlined, 3, currentIndex),
            label: '',
            tooltip: 'Libri Circolo',
          ),
          BottomNavigationBarItem(
            icon: _buildIconBackground(
                context, Icons.notifications_outlined, 4, currentIndex),
            label: '',
            tooltip: 'Notifiche',
          ),
        ],
      ),
    );
  }
}
