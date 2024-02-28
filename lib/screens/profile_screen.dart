import 'package:alfi_gest/models/enums.dart';
import 'package:alfi_gest/providers/member/member_role_provider.dart';
import 'package:alfi_gest/providers/auth/user_data_provider.dart';
import 'package:alfi_gest/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:alfi_gest/providers/auth/auth_provider.dart';
import 'package:alfi_gest/providers/member/members_data_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_settings/app_settings.dart';

final isNotifyDisabledProvider = StateProvider<bool>((ref) => false);

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userDataProvider);
    final isNotifyDisabled = ref.watch(isNotifyDisabledProvider);
    final userRole = ref.watch(roleProvider);

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(0, 18, 0, 0),
          child: IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              ref.read(isProfilePageProvider.notifier).state = false;
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
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      title: Text(
                        "${user.lastName} ${user.givenName.isEmpty ? user.legalName : user.givenName}",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      subtitle: Text(
                        user.email,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Text(
                          "${user.lastName[0]} ${user.givenName.isEmpty ? user.legalName[0] : user.givenName[0]}",
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceVariant,
                                  ),
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.chevron_right),
                        onPressed: () {},
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 16, 8, 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Notifiche",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const Spacer()
                      ],
                    ),
                  ),
                  Card(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            "Non disturbare",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          subtitle: Text(
                            isNotifyDisabled ? "Attivato" : "Disattivato",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                          ),
                          leading: Icon(
                            isNotifyDisabled
                                ? Icons.notifications_off_outlined
                                : Icons.notifications_active_outlined,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.chevron_right),
                            onPressed: () {
                              ref
                                  .read(isNotifyDisabledProvider.notifier)
                                  .state = !isNotifyDisabled;
                              AppSettings.openAppSettings();
                            },
                          ),
                        ),
                        Divider(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          height: 1,
                          endIndent: 14,
                          indent: 14,
                        ),
                        ListTile(
                          title: Text(
                            "Notifiche push",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          subtitle: Text(
                            "Gestisci",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                          ),
                          leading: Icon(Icons.announcement,
                              color: Theme.of(context).colorScheme.secondary),
                          trailing: IconButton(
                            icon: Icon(Icons.chevron_right),
                            onPressed: () {
                              AppSettings.openAppSettings(
                                  type: AppSettingsType.notification,
                                  asAnotherTask: true);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (userRole == Role.amministratore.name)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 16, 8, 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Gestione socie*",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const Spacer()
                        ],
                      ),
                    ),
                  if (userRole == Role.amministratore.name)
                    Card(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        title: Text(
                          "In sospeso",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        subtitle: Text(
                          "10 richieste",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                        leading: Icon(Icons.hourglass_empty,
                            color: Theme.of(context).colorScheme.secondary),
                        trailing: IconButton(
                          icon: Icon(Icons.chevron_right),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  if (userRole == Role.amministratore.name)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 16, 8, 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Gestione ruoli e permessi",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const Spacer()
                        ],
                      ),
                    ),
                  if (userRole == Role.amministratore.name)
                    Card(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        title: Text(
                          "Ruoli e permessi",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        subtitle: Text(
                          "persone",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                        leading: Icon(Icons.list_alt_outlined,
                            color: Theme.of(context).colorScheme.secondary),
                        trailing: IconButton(
                          icon: Icon(Icons.chevron_right),
                          onPressed: () {
                            ref.read(isManageRolesPageProvider.notifier).state =
                                true;
                          },
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    height: 65,
                    child: ElevatedButton(
                      onPressed: () {
                        ref
                            .read(membersProvider.notifier)
                            .cancelMembersSubscription();
                        ref.read(isProfilePageProvider.notifier).state = false;
                        ref.read(authProvider.notifier).logout();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        shadowColor: Colors.transparent,
                        backgroundColor:
                            Theme.of(context).colorScheme.surfaceVariant,
                      ),
                      child: Text(
                        "Esci",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).colorScheme.primary,
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
