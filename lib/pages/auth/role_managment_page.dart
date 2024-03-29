import 'package:alfi_gest/helpers/string_helper.dart';
import 'package:alfi_gest/models/enums.dart';
import 'package:alfi_gest/pages/members/members_page.dart';
import 'package:alfi_gest/pages/profile/add_edit_role_page.dart';
import 'package:alfi_gest/providers/member/create_member_provider.dart';
import 'package:alfi_gest/providers/member/member_role_provider.dart';
import 'package:alfi_gest/providers/member/members_data_provider.dart';
import 'package:alfi_gest/providers/auth/user_data_provider.dart';
import 'package:alfi_gest/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isAddEditRolePageProvider = StateProvider<bool>((ref) => false);
final isAddRoleProvider = StateProvider<bool>((ref) => false);

class RoleManagementPage extends ConsumerWidget {
  const RoleManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userDataProvider);
    final isLoading = ref.watch(isLoadingProvider);
    final filteredMembers = ref.watch(filteredMembersProvider);
    final membersWithRole = ref.watch(memberWithRoleProvider);
    final isAddEditRole = ref.watch(isAddEditRolePageProvider);

    filteredMembers.length > 0
        ? filteredMembers.sort((a, b) {
            if (a.givenName.isEmpty || b.givenName.isEmpty) {
              return a.title.compareTo(b.title);
            }
            return a.title.compareTo(b.title);
          })
        : filteredMembers;

    return isAddEditRole
        ? const AddEditRolePage()
        : Scaffold(
            appBar: AppBar(
              toolbarHeight: 70,
              leading: Padding(
                padding: const EdgeInsets.fromLTRB(0, 18, 0, 0),
                child: IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    ref.read(isManageRolesPageProvider.notifier).state = false;
                  },
                ),
              ),
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
              actions: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 18, 14, 0),
                  child: Text(
                    "Gestione ruoli",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                ),
              ],
            ),
            body: user == null || membersWithRole.isEmpty
                ? Center(child: CircularProgressIndicator())
                : Stack(
                    children: [
                      Container(
                        margin: const EdgeInsetsDirectional.only(top: 16),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Consumer(
                              builder: (context, ref, child) {
                                return TextField(
                                  decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(left: 24),
                                    hintText: "Cerca socie*",
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant
                                              .withOpacity(0.5),
                                        ),
                                    suffixIcon: const Icon(
                                      Icons.search,
                                    ),
                                    suffixIconColor: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                    filled: true,
                                    fillColor: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(28),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  onChanged: (query) {
                                    // Aggiorna la query di ricerca
                                    ref
                                        .read(searchQueryProvider.notifier)
                                        .state = query;

                                    // Filtra i membri in base alla query
                                    ref
                                        .read(filteredMembersProvider.notifier)
                                        .searchMember(query);
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 14),
                            Expanded(
                              child: isLoading
                                  ? Center(
                                      child: const CircularProgressIndicator())
                                  : ListView.builder(
                                      itemCount: filteredMembers.length,
                                      itemBuilder: (context, index) {
                                        final member = filteredMembers[index];
                                        final memberWithRole =
                                            membersWithRole.firstWhere(
                                          (m) => m.member.id == member.id,
                                          orElse: () => MemberWithRole(
                                              member: member,
                                              role: Role.socia.toString()),
                                        );

                                        final isEditableRole =
                                            memberWithRole.role ==
                                                    "Amministratore" ||
                                                memberWithRole.role ==
                                                    "Segretaria Nazionale" ||
                                                memberWithRole.role ==
                                                    "Responsabile Circolo";
                                        final memberRole = membersWithRole
                                            .where(
                                                (m) => m.member.id == member.id)
                                            .first;
                                        final role = parseRole(memberRole.role);
                                        return Container(
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                  width: 1.0,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary),
                                            ),
                                          ),
                                          child: ListTile(
                                            title: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8),
                                              child: Text(
                                                member.title,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                    ),
                                              ),
                                            ),
                                            subtitle: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8),
                                              child: Text(
                                                  membersWithRole.isNotEmpty &&
                                                          membersWithRole
                                                                  .where((m) =>
                                                                      m.member
                                                                          .id ==
                                                                      member.id)
                                                                  .first
                                                                  .role !=
                                                              "Socia"
                                                      ? membersWithRole
                                                          .where((m) =>
                                                              m.member.id ==
                                                              member.id)
                                                          .first
                                                          .role
                                                      : "",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .copyWith(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .secondary,
                                                      )),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 0),
                                            trailing: IconButton(
                                              icon: Icon(isEditableRole
                                                  ? Icons.edit_outlined
                                                  : Icons.add_outlined),
                                              onPressed: () {
                                                if (isEditableRole) {
                                                  ref
                                                      .read(
                                                          isAddEditRolePageProvider
                                                              .notifier)
                                                      .state = true;
                                                  ref
                                                      .read(isAddRoleProvider
                                                          .notifier)
                                                      .state = false;
                                                  ref
                                                      .read(memberSelected
                                                          .notifier)
                                                      .state = member;
                                                  ref
                                                      .read(userRoleProvider
                                                          .notifier)
                                                      .updateRole(role);
                                                } else {
                                                  ref
                                                      .read(
                                                          isAddEditRolePageProvider
                                                              .notifier)
                                                      .state = true;
                                                  ref
                                                      .read(memberSelected
                                                          .notifier)
                                                      .state = member;
                                                  ref
                                                      .read(isAddRoleProvider
                                                          .notifier)
                                                      .state = true;
                                                  ref
                                                      .read(memberSelected
                                                          .notifier)
                                                      .state = member;
                                                  ref
                                                      .read(userRoleProvider
                                                          .notifier)
                                                      .updateRole(role);
                                                }
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          );
  }
}
