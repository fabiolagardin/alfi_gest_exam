import 'package:alfi_gest/helpers/date_time.dart';
import 'package:alfi_gest/models/enums.dart';
import 'package:alfi_gest/pages/auth/role_managment_page.dart';
import 'package:alfi_gest/pages/books/books_details.dart';
import 'package:alfi_gest/pages/clubs/club_details_page.dart';
import 'package:alfi_gest/pages/clubs/clubs_page.dart';
import 'package:alfi_gest/pages/clubs/create_club_page.dart';
import 'package:alfi_gest/pages/members/create_member_page.dart';
import 'package:alfi_gest/pages/dashboard_page.dart';
import 'package:alfi_gest/pages/books/books_page.dart';
import 'package:alfi_gest/pages/members/member_details_page.dart';
import 'package:alfi_gest/pages/notifiche_page.dart';
import 'package:alfi_gest/pages/members/members_page.dart';
import 'package:alfi_gest/providers/auth/user_data_provider.dart';
import 'package:alfi_gest/providers/member/create_member_provider.dart';
import 'package:alfi_gest/providers/member/member_role_provider.dart';
import 'package:alfi_gest/screens/profile_screen.dart';
import 'package:alfi_gest/widgets/custom_bottom_navigation_bar.dart';
import 'package:alfi_gest/widgets/standard_button.dart';
import 'package:alfi_gest/widgets/user/user_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentIndexProvider = StateProvider<int>((ref) => 0);
final isMemberPageProvider = StateProvider<bool>((ref) => true);
final isMainAppBarProvider = StateProvider<bool>((ref) => true);
final isMemberDetailsPageProvider = StateProvider<bool>((ref) => false);
final isMemberDetailsUpdatePageProvider = StateProvider<bool>((ref) => false);
final isMemberReplaceCardProvider = StateProvider<bool>((ref) => false);

final isClubPageProvider = StateProvider<bool>((ref) => true);
final isClubDetailsPageProvider = StateProvider<bool>((ref) => false);
final isClubDetailsUpdatePageProvider = StateProvider<bool>((ref) => false);

final isProfilePageProvider = StateProvider<bool>((ref) => false);

final isManageRolesPageProvider = StateProvider<bool>((ref) => false);
final isMemberReadyFor = StateProvider<bool>((ref) => false);
final isClubReadyFor = StateProvider<bool>((ref) => false);

final isBookPageProvider = StateProvider<bool>((ref) => true);
final isBookDetailsPageProvider = StateProvider<bool>((ref) => false);

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentIndexProvider);
    final isMemberPage = ref.watch(isMemberPageProvider);
    final isMemberDetailsPage = ref.watch(isMemberDetailsPageProvider);
    final isClubPage = ref.watch(isClubPageProvider);
    final isClubDetailsPage = ref.watch(isClubDetailsPageProvider);
    final isProfilePage = ref.watch(isProfilePageProvider);
    final isManageRolePage = ref.watch(isManageRolesPageProvider);
    final userData = ref.watch(userDataProvider);
    final userRole = ref.watch(roleProvider);
    final isLoading = ref.watch(isLoadingProvider);
    final isMainAppBar = ref.watch(isMainAppBarProvider);
    final isBookPage = ref.watch(isBookPageProvider);
    List<Widget> pages = [
      const DashboardPage(),
      isMemberPage
          ? const MembersPage()
          : isMemberDetailsPage
              ? const MemberDetailsPage()
              : const CreateMemberPage(),
      isClubPage
          ? const ClubsPage()
          : isClubDetailsPage
              ? const ClubDetailsPage()
              : const CreateClubPage(),
      isBookPage ? const BooksClubPage() : const BookDetailsPage(),
      const NotifichePage(),
    ];

    List<Widget> pagesSocia = [
      const DashboardPage(),
      const NotifichePage(),
    ];

    List<Widget> selectedPages = userRole == Role.socia ? pagesSocia : pages;

    return isProfilePage
        ? isManageRolePage
            ? RoleManagementPage()
            : ProfileScreen()
        : Scaffold(
            appBar: isMainAppBar
                ? AppBar(
                    title: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image:
                              Theme.of(context).brightness == Brightness.light
                                  ? const AssetImage(
                                      'assets/images/logo-light-small.png')
                                  : const AssetImage(
                                      'assets/images/logo-dark-small.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    actions: [
                      IconButton(
                        icon: userData != null
                            ? UserImageProfile(
                                memeberId: userData.memberId,
                                initials: userData.initials,
                                radius: 20)
                            : const Icon(Icons.person),
                        onPressed: () {
                          ref.read(isProfilePageProvider.notifier).state = true;
                        },
                      ),
                    ],
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceVariant,
                    toolbarHeight: 70)
                : null,
            body: userData == null
                ? Center(
                    child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ))
                : IndexedStack(
                    index: currentIndex,
                    children: selectedPages,
                  ),
            bottomNavigationBar: isLoading
                ? null
                : CustomBottomNavigationBar(
                    currentIndex: currentIndex,
                    onTap: (index) {
                      ref.read(isMainAppBarProvider.notifier).state = true;
                      if (currentIndex != index) {
                        ref.read(currentIndexProvider.notifier).state = index;
                        if (index == 0) {
                          ref.read(isMainAppBarProvider.notifier).state = true;
                        }
                        if (index != 1) {
                          ref.read(isMemberPageProvider.notifier).state = true;
                        }
                        if (index == 2 &&
                            userRole == Role.responsabileCircolo) {
                          ref.read(isMainAppBarProvider.notifier).state = false;
                        }
                        if (index != 2 &&
                            userRole == Role.responsabileCircolo) {
                          ref.read(isMainAppBarProvider.notifier).state = true;
                        }

                        if (index != 3) {
                          ref.read(isBookPageProvider.notifier).state = true;
                          ref.read(isBookDetailsPageProvider.notifier).state =
                              false;
                        }
                      }
                    },
                    userRole: userRole ?? Role.nonAssegnato,
                  ),
            floatingActionButton: userData != null &&
                    userData.expirationDate
                        .isBefore(DateHelper.calculateExpirationDate())
                ? StandardButton(
                    onPressed: () {},
                    paddingHorizontal: 29.5,
                    paddingVertical: 10,
                    child: Text(
                      "Rinnova",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                    ),
                  )
                : SizedBox.shrink(),
          );
  }
}
