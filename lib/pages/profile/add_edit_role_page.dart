import 'package:alfi_gest/helpers/string_helper.dart';
import 'package:alfi_gest/models/enums.dart';
import 'package:alfi_gest/models/user_role.dart';
import 'package:alfi_gest/pages/auth/role_managment_page.dart';
import 'package:alfi_gest/pages/members/members_page.dart';
import 'package:alfi_gest/providers/auth/user_data_provider.dart';
import 'package:alfi_gest/providers/member/create_member_provider.dart';
import 'package:alfi_gest/providers/member/member_role_provider.dart';
import 'package:alfi_gest/providers/member/members_data_provider.dart';
import 'package:alfi_gest/screens/main_screen.dart';
import 'package:alfi_gest/services/club_service.dart';
import 'package:alfi_gest/services/member_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddEditRolePage extends ConsumerStatefulWidget {
  const AddEditRolePage({super.key});
  @override
  _AddEditRolePageState createState() => _AddEditRolePageState();
}

class _AddEditRolePageState extends ConsumerState<AddEditRolePage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController memberController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final isAddRole = ref.watch(isAddRoleProvider);
    final userRoleSelected = ref.watch(userRoleProvider);
    final isLoading = ref.watch(isLoadingProvider);
    final isReadyFor = ref.watch(isClubReadyFor);
    final member = ref.watch(memberSelected);
    final user = ref.watch(userProvider);

    roleController.text = formatRole(userRoleSelected.role);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0, 18, 0, 0),
          child: Text(
            isAddRole ? "Nuovo ruolo" : "Modifica Ruolo",
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w400,
                  fontSize: 22,
                  fontFamily: "Roboto",
                ),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(0, 28, 0, 0),
          child: isLoading
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(22, 14, 0, 0),
                  child: Text(
                    "Annulla",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.5),
                        ),
                  ),
                )
              : TextButton(
                  onPressed: () {
                    ref.read(isAddEditRolePageProvider.notifier).state = false;
                    ref.read(isMainAppBarProvider.notifier).state = false;
                    // formState.reset();
                  },
                  child: Text(
                    "Annulla",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                ),
        ),
        leadingWidth: 100,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 28, 0, 0),
            child: isLoadingProvider == true
                ? const CircularProgressIndicator()
                : isReadyFor && !isLoading
                    ? TextButton(
                        onPressed: () async {
                          //Scafolod
                          var sm = ScaffoldMessenger.of(context);

                          // Imposta isLoading su true
                          ref.read(isLoadingProvider.notifier).state = true;

                          var userRole = new UserRole(
                              idUserRole: member.memberId,
                              role: userRoleSelected.role,
                              creationDate: DateTime.now(),
                              updateDate: DateTime.now(),
                              updateUser: user.value!.uid,
                              userCreation: user.value!.uid);

                          var result = await MemberService()
                              .setRoleMember(member.memberId, userRole);
                          if (userRoleSelected.role == Role.socia) {
                            var result = await ClubService().updateClubManager(
                                member.idClub, member.memberId);
                            if (!result.valid) {
                              final snackBar = SnackBar(
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .errorContainer,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  content: Text(
                                    "${result.error}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onTertiary),
                                  ),
                                  behavior: SnackBarBehavior.floating);
                              sm.showSnackBar(snackBar);
                            }
                            return;
                          }
                          if (result.valid) {
                            ref.read(isLoadingProvider.notifier).state = false;
                            ref.read(isMainAppBarProvider.notifier).state =
                                true;
                            ref.read(isAddEditRolePageProvider.notifier).state =
                                false;
                            ref.read(isMemberPageProvider.notifier).state =
                                true;
                            final snackBar = SnackBar(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              content: Text(
                                "Salvataggio avvenuto con successo",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary),
                              ),
                              behavior: SnackBarBehavior.floating,
                            );
                            ref.read(memberWithRoleProvider.notifier).refresh();
                            sm.showSnackBar(snackBar);
                          } else {
                            // Errore: mostra un messaggio di errore
                            final snackBar = SnackBar(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .errorContainer,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                content: Text(
                                  "${result.error}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onTertiary),
                                ),
                                behavior: SnackBarBehavior.floating);
                            sm.showSnackBar(snackBar);
                            ref.read(isLoadingProvider.notifier).state = false;
                            ref.read(isMainAppBarProvider.notifier).state =
                                true;
                          }
                        },
                        child: Text(
                          "Salva",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Text(
                          "Salva",
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary
                                        .withOpacity(0.5),
                                  ),
                        ),
                      ),
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text(
                        member.title,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            barrierLabel: "Seleziona il ruolo",
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            builder: (BuildContext context) {
                              return SingleChildScrollView(
                                child: Container(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.horizontal_rule,
                                            size: 40,
                                          ),
                                        ],
                                      ),
                                      ListTile(
                                        contentPadding: EdgeInsets.only(
                                            left: 10, right: 10),
                                        title: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right:
                                                    48.0), // Consider the leading space
                                            child: Text(
                                              "Seleziona il ruolo",
                                            ),
                                          ),
                                        ),
                                        leading: IconButton(
                                          icon: Icon(Icons.close),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                      for (Role value in Role.values)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                              width: 1.0,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .outlineVariant,
                                            ))),
                                            child: ListTile(
                                              title: Row(
                                                children: [
                                                  Text(
                                                    formatRole(value) != ''
                                                        ? formatRole(value)
                                                        : '----',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge,
                                                  ),
                                                  const Spacer(),
                                                  Icon(
                                                    userRoleSelected.role ==
                                                            value
                                                        ? Icons
                                                            .radio_button_checked
                                                        : Icons
                                                            .radio_button_unchecked,
                                                    color:
                                                        userRoleSelected.role ==
                                                                value
                                                            ? Theme.of(context)
                                                                .colorScheme
                                                                .primary
                                                            : Theme.of(context)
                                                                .colorScheme
                                                                .secondary,
                                                  ),
                                                ],
                                              ),
                                              onTap: () {
                                                ref
                                                    .read(userRoleProvider
                                                        .notifier)
                                                    .updateRole(value);
                                                ref
                                                    .read(
                                                        isClubReadyFor.notifier)
                                                    .state = true;
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: TextFormField(
                          controller: roleController,
                          decoration: InputDecoration(
                            labelText: 'Ruolo',
                            filled: true,
                            border: InputBorder.none,
                            suffixIcon: Icon(
                              Icons.arrow_drop_down,
                              color: Theme.of(context)
                                  .iconTheme
                                  .color
                                  ?.withOpacity(1.0),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.error),
                            ),
                            labelStyle: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(1.0),
                            ),
                            fillColor: Theme.of(context)
                                .colorScheme
                                .surfaceVariant
                                .withOpacity(1.0),
                          ),
                          enabled: false,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
