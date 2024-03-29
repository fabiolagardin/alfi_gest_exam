import 'package:alfi_gest/models/enums.dart';
import 'package:alfi_gest/models/member.dart';
import 'package:alfi_gest/pages/members/members_page.dart';
import 'package:alfi_gest/pages/profile/member_pending_details_page.dart';
import 'package:alfi_gest/pages/profile/members_refus_page.dart';
import 'package:alfi_gest/pages/profile/user_details_page.dart';
import 'package:alfi_gest/providers/member/create_member_provider.dart';
import 'package:alfi_gest/providers/member/member_data_provider.dart';
import 'package:alfi_gest/providers/member/member_role_provider.dart';
import 'package:alfi_gest/providers/auth/user_data_provider.dart';
import 'package:alfi_gest/screens/main_screen.dart';
import 'package:alfi_gest/pages/profile/management__new_members.dart';
import 'package:alfi_gest/widgets/user/user_image.dart';
import 'package:flutter/material.dart';
import 'package:alfi_gest/providers/auth/auth_provider.dart';
import 'package:alfi_gest/providers/member/members_data_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_settings/app_settings.dart';

final isNotifyDisabledProvider = StateProvider<bool>((ref) => false);
final isManagementNewMemebersPageProvider = StateProvider<bool>((ref) => false);
final isMemberPendingDetailsPageProvider = StateProvider<bool>((ref) => false);
final isMembersRejectedPageProvider = StateProvider<bool>((ref) => false);
final isMembersRejectedDetailsPageProvider =
    StateProvider<bool>((ref) => false);
final isUserDetailsPageProvider = StateProvider<bool>((ref) => false);
final isProfileReadyForProvider = StateProvider<bool>((ref) => false);
final idClubSelectedProvider = StateProvider<String?>((ref) => null);

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userDataProvider);
    final userData = ref.watch(memberProvider);
    final isNotifyDisabled = ref.watch(isNotifyDisabledProvider);
    final userRole = ref.watch(roleProvider);
    final isMemberPendingDetails =
        ref.watch(isMemberPendingDetailsPageProvider);
    final isManagementNewMemebersPage =
        ref.watch(isManagementNewMemebersPageProvider);
    final isMembersRejectedPage = ref.watch(isMembersRejectedPageProvider);
    final numberOfMamebrsInPending =
        ref.watch(suspendedMembersCountProvider(null));
    final isUserDetailsPage = ref.watch(isUserDetailsPageProvider);
    if (userRole == Role.responsabileCircolo) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(idClubSelectedProvider.notifier).state = userData?.idClub;
      });
    }
    return isUserDetailsPage
        ? UserDetailsPage()
        : isManagementNewMemebersPage ||
                isMemberPendingDetails ||
                isMembersRejectedPage
            ? isMemberPendingDetails || isMembersRejectedPage
                ? isMembersRejectedPage
                    ? MembersRefusePage()
                    : const MemberPendingDetailsPage()
                : const ManagmentNewMembersScreen()
            : Scaffold(
                appBar: AppBar(
                  toolbarHeight: 70,
                  leading: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 18, 0, 0),
                    child: IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () {
                        ref.read(isProfilePageProvider.notifier).state = false;
                        ref.read(isMainAppBarProvider.notifier).state = true;
                      },
                    ),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                  actions: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 18, 14, 0),
                      child: Text(
                        "Account",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                    ),
                  ],
                ),
                body: user == null
                    ? Center(child: CircularProgressIndicator())
                    : Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Card(
                              color:
                                  Theme.of(context).colorScheme.surfaceVariant,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: ListTile(
                                onTap: () {
                                  ref
                                      .read(isUserDetailsPageProvider.notifier)
                                      .state = true;
                                  ref.read(memberSelected.notifier).state =
                                      userData ?? Member.empty();
                                  ref
                                      .read(createMemberFormProvider.notifier)
                                      .updatePronoun(ref
                                          .watch(memberSelected.notifier)
                                          .state
                                          .pronoun);
                                },
                                title: Text(
                                  user.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                subtitle: Text(
                                  user.email,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                ),
                                leading: userData != null
                                    ? UserImageProfile(
                                        memeberId: userData.memberId,
                                        initials: userData.initials,
                                        radius: 20)
                                    : const Icon(Icons.person),
                                trailing: Icon(Icons.chevron_right),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8.0, 16, 8, 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Notifiche",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const Spacer()
                                ],
                              ),
                            ),
                            Card(
                              color:
                                  Theme.of(context).colorScheme.surfaceVariant,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      ref
                                          .read(
                                              isNotifyDisabledProvider.notifier)
                                          .state = !isNotifyDisabled;
                                      AppSettings.openAppSettings();
                                    },
                                    child: ListTile(
                                      title: Text(
                                        "Non disturbare",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      subtitle: Text(
                                        isNotifyDisabled
                                            ? "Attivato"
                                            : "Disattivato",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            ),
                                      ),
                                      leading: Icon(
                                        isNotifyDisabled
                                            ? Icons.notifications_off_outlined
                                            : Icons
                                                .notifications_active_outlined,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                      trailing: Icon(Icons.chevron_right),
                                    ),
                                  ),
                                  Divider(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary
                                        .withOpacity(0.2),
                                    height: 1,
                                    endIndent: 14,
                                    indent: 14,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      AppSettings.openAppSettings(
                                        type: AppSettingsType.notification,
                                        asAnotherTask: true,
                                      );
                                    },
                                    child: ListTile(
                                      title: Text(
                                        "Notifiche push",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      subtitle: Text(
                                        "Gestisci",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            ),
                                      ),
                                      leading: Icon(Icons.announcement,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                      trailing: Icon(Icons.chevron_right),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (userRole == Role.amministratore ||
                                userRole == Role.responsabileCircolo ||
                                userRole == Role.segretariaNazionale)
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(8.0, 16, 8, 4),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Gestione socie*",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const Spacer()
                                  ],
                                ),
                              ),
                            if (userRole == Role.amministratore ||
                                userRole == Role.responsabileCircolo ||
                                userRole == Role.segretariaNazionale)
                              Card(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceVariant,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: ListTile(
                                  onTap: () => ref
                                      .read(isManagementNewMemebersPageProvider
                                          .notifier)
                                      .state = true,
                                  title: Text(
                                    "In sospeso",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  subtitle: Text(
                                    userRole == Role.responsabileCircolo
                                        ? ref.watch(
                                            suspendedMembersCountProvider(
                                                userData!.idClub))
                                        : numberOfMamebrsInPending,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                  ),
                                  leading: Icon(Icons.hourglass_empty,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                  trailing: Icon(Icons.chevron_right),
                                ),
                              ),
                            if (userRole == Role.amministratore)
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(8.0, 16, 8, 4),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Gestione ruoli e permessi",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const Spacer()
                                  ],
                                ),
                              ),
                            if (userRole == Role.amministratore)
                              Card(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceVariant,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: ListTile(
                                  onTap: () => ref
                                      .read(isManageRolesPageProvider.notifier)
                                      .state = true,
                                  title: Text(
                                    "Ruoli e permessi",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  subtitle: Text(
                                    ref.watch(filteredMembersCountProvider),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                  ),
                                  leading: Icon(Icons.list_alt_outlined,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                  trailing: Icon(Icons.chevron_right),
                                ),
                              ),
                            const SizedBox(height: 20),
                            Container(
                              width: double.infinity,
                              height: 65,
                              child: ElevatedButton(
                                onPressed: () {
                                  ref
                                      .read(isProfilePageProvider.notifier)
                                      .state = false;
                                  ref
                                      .read(currentIndexProvider.notifier)
                                      .state = 0;
                                  ref.read(authProvider.notifier).logout();
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  shadowColor: Colors.transparent,
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .surfaceVariant,
                                ),
                                child: Text(
                                  "Esci",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              );
  }
}
