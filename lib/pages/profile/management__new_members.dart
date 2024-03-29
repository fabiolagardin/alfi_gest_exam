import 'dart:async';

import 'package:alfi_gest/helpers/date_time.dart';
import 'package:alfi_gest/helpers/string_helper.dart';
import 'package:alfi_gest/models/enums.dart';
import 'package:alfi_gest/pages/members/members_page.dart';
import 'package:alfi_gest/providers/clubs/clubs_provider.dart';
import 'package:alfi_gest/providers/member/create_member_provider.dart';
import 'package:alfi_gest/providers/member/members_data_provider.dart';

import 'package:alfi_gest/screens/main_screen.dart';
import 'package:alfi_gest/screens/profile_screen.dart';
import 'package:alfi_gest/services/member_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ManagmentNewMembersScreen extends ConsumerStatefulWidget {
  const ManagmentNewMembersScreen({Key? key}) : super(key: key);

  @override
  _ManagmentNewMembersScreenState createState() =>
      _ManagmentNewMembersScreenState();
}

class _ManagmentNewMembersScreenState
    extends ConsumerState<ManagmentNewMembersScreen> {
  TextEditingController _controller = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final clubs = ref.watch(filteredClubsProvider);
    final isLoading = ref.watch(isLoadingProvider);
    final idClubSelected = ref.watch(idClubSelectedProvider);
    final membersInPending =
        ref.watch(suspendedMembersStreamProvider(idClubSelected));
    final membersrejected =
        ref.watch(rejectedMembersCountProvider(idClubSelected));
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        toolbarHeight: 70,
        leadingWidth: 150,
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 4),
          child: TextButton(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chevron_left,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  Text(
                    "Indietro",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                ],
              ),
              onPressed: () {
                ref.read(isProfilePageProvider.notifier).state = true;
                ref.read(isManagementNewMemebersPageProvider.notifier).state =
                    false;
              }),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 16, 8, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Richieste",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.8),
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
            child: isLoading || membersInPending.value == null
                ? Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      membersInPending.value!.length == 0
                          ? ListTile(
                              title: Text(
                                "Nessuna Socia in attesa di approvazione",
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
                                "0 socie*",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                              ),
                              leading: Icon(Icons.playlist_remove,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            )
                          : ListView.separated(
                              shrinkWrap: true, // Aggiungi questa linea
                              physics:
                                  NeverScrollableScrollPhysics(), // e questa
                              itemCount: membersInPending.value!.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(
                                    formatMemberName(
                                        membersInPending.value![index]),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  subtitle: Text(
                                    getClubName(
                                        membersInPending.value![index], clubs),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.remove_red_eye_outlined,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                        onPressed: () {
                                          ref
                                                  .read(memberSelected.notifier)
                                                  .state =
                                              membersInPending.value![index];
                                          ref
                                              .read(
                                                  isMemberPendingDetailsPageProvider
                                                      .notifier)
                                              .state = true;
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.check,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                        onPressed: () async {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                content: TextField(
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .digitsOnly, // Accetta solo numeri
                                                      LengthLimitingTextInputFormatter(
                                                          6), // Limite di lunghezza per i numeri della tessera
                                                    ],
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          'Assegna numero di tessera',
                                                      fillColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .surfaceVariant,
                                                      filled: true,
                                                      border: InputBorder.none,
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .primary),
                                                      ),
                                                      errorBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .error),
                                                      ),
                                                      focusedErrorBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .error),
                                                      ),
                                                      labelStyle: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .secondary,
                                                      ),
                                                    ),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .secondary,
                                                        ),
                                                    keyboardType:
                                                        TextInputType.number,
                                                    autocorrect: false,
                                                    controller: _controller,
                                                    onChanged: (value) =>
                                                        _controller.text =
                                                            value),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () async {
                                                      var result = await MemberService()
                                                          .replaceMemberCard(
                                                              membersInPending
                                                                  .value![index]
                                                                  .id,
                                                              _controller.text,
                                                              ReplaceCardMotivation
                                                                  .nuovaEmissione
                                                                  .index);
                                                      ref
                                                          .read(
                                                              isLoadingProvider
                                                                  .notifier)
                                                          .state = true;
                                                      if (result.hasData) {
                                                        ref
                                                            .read(
                                                                isLoadingProvider
                                                                    .notifier)
                                                            .state = true;
                                                        var aceptedMember = await MemberService()
                                                            .renewOrSuspendMember(
                                                                membersInPending
                                                                    .value![
                                                                        index]
                                                                    .memberId,
                                                                false,
                                                                DateHelper
                                                                        .calculateExpirationDate()
                                                                    .toString());

                                                        if (aceptedMember
                                                            .hasData) {
                                                          ref
                                                              .read(
                                                                  isLoadingProvider
                                                                      .notifier)
                                                              .state = false;
                                                          ref
                                                              .read(
                                                                  isLoadingProvider
                                                                      .notifier)
                                                              .state = false;

                                                          ref
                                                              .read(
                                                                  filteredMembersProvider
                                                                      .notifier)
                                                              .getMembersSuspended();
                                                          ref
                                                              .read(
                                                                  isLoadingProvider
                                                                      .notifier)
                                                              .state = false;
                                                          Navigator.of(context);
                                                        }
                                                      }
                                                      ref
                                                          .read(
                                                              isLoadingProvider
                                                                  .notifier)
                                                          .state = false;
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text("Conferma"),
                                                  )
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                        onPressed: () async {
                                          var sm =
                                              ScaffoldMessenger.of(context);
                                          final countdownController =
                                              StreamController<int>();
                                          var isCancelled = false;
                                          int countdownValue = 5;

                                          Timer.periodic(Duration(seconds: 1),
                                              (timer) {
                                            countdownController
                                                .add(countdownValue);
                                            if (countdownValue == 0) {
                                              timer.cancel();
                                              countdownController.close();
                                            } else {
                                              countdownValue--;
                                            }
                                          });

                                          sm.showSnackBar(
                                            SnackBar(
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              duration: Duration(seconds: 5),
                                              content: StreamBuilder<int>(
                                                stream:
                                                    countdownController.stream,
                                                builder: (context, snapshot) {
                                                  return Text(
                                                    'Socia* rifiutata tra ${snapshot.data ?? 5}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .onPrimary),
                                                  );
                                                },
                                              ),
                                              action: SnackBarAction(
                                                label: 'Annulla ',
                                                onPressed: () {
                                                  isCancelled = true;
                                                  ref
                                                      .read(isLoadingProvider
                                                          .notifier)
                                                      .state = false;

                                                  ScaffoldMessenger.of(context)
                                                      .hideCurrentSnackBar();
                                                },
                                              ),
                                            ),
                                          );
                                          ref
                                              .read(isLoadingProvider.notifier)
                                              .state = true;
                                          await Future.delayed(
                                              Duration(seconds: 5));

                                          if (!isCancelled) {
                                            Navigator.of(context).pop();

                                            var result = await MemberService()
                                                .refuseMember(
                                                    membersInPending
                                                        .value![index].memberId,
                                                    true);

                                            if (result.hasData) {
                                              ref
                                                  .read(isLoadingProvider
                                                      .notifier)
                                                  .state = false;
                                              ref
                                                  .read(filteredMembersProvider
                                                      .notifier)
                                                  .getMembersSuspended();
                                              ref
                                                  .read(isLoadingProvider
                                                      .notifier)
                                                  .state = false;
                                            }
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .errorContainer,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                  content: Text(
                                                      'Operazione annullata',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .onTertiary)),
                                                  behavior: SnackBarBehavior
                                                      .floating),
                                            );
                                            ref
                                                .read(
                                                    isLoadingProvider.notifier)
                                                .state = false;
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                if (index < membersInPending.value!.length) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Divider(height: 8),
                                  );
                                } else {
                                  return SizedBox.shrink();
                                }
                              },
                            ),
                    ],
                  ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 16, 8, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Socie* rifiutate",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.8),
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
            child: ListTile(
                onTap: () {
                  ref.read(isMembersRejectedPageProvider.notifier).state = true;
                },
                title: Text(
                  "Lista",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                subtitle: Text(
                  membersrejected,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                ),
                leading: Icon(Icons.playlist_remove,
                    color: Theme.of(context).colorScheme.secondary),
                trailing: Icon(Icons.chevron_right)),
          ),
        ]),
      ),
    );
  }
}
