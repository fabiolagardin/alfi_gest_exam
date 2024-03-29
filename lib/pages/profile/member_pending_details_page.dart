import 'dart:async';

import 'package:alfi_gest/helpers/date_time.dart';
import 'package:alfi_gest/helpers/string_helper.dart';
import 'package:alfi_gest/models/enums.dart';
import 'package:alfi_gest/pages/members/members_page.dart';
import 'package:alfi_gest/providers/clubs/clubs_provider.dart';
import 'package:alfi_gest/providers/member/create_member_provider.dart';
import 'package:alfi_gest/providers/member/members_data_provider.dart';
import 'package:alfi_gest/screens/profile_screen.dart';
import 'package:alfi_gest/services/member_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class MemberPendingDetailsPage extends ConsumerStatefulWidget {
  const MemberPendingDetailsPage({super.key});
  @override
  MemberPendingDetailsPageState createState() =>
      MemberPendingDetailsPageState();
}

class MemberPendingDetailsPageState
    extends ConsumerState<MemberPendingDetailsPage> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final member = ref.watch(memberSelected);
    final clubs = ref.watch(filteredClubsProvider);
    final isLoading = ref.watch(isLoadingProvider);
    final isMembersRejectedDetailsPage =
        ref.watch(isMembersRejectedDetailsPageProvider);
    return Scaffold(
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
                if (isMembersRejectedDetailsPage) {
                  ref.read(isMemberPendingDetailsPageProvider.notifier).state =
                      false;
                  ref.read(isMembersRejectedPageProvider.notifier).state = true;
                } else {
                  ref.read(isMemberPendingDetailsPageProvider.notifier).state =
                      false;
                }

                ref.read(isMembersRejectedDetailsPageProvider.notifier).state =
                    false;
              }),
        ),
      ),
      body: isLoading
          ? Center(child: const CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 25, 4, 0),
                      child: Text(
                        '${member.lastName} ${member.givenName.isEmpty ? member.legalName : member.givenName}',
                        textAlign: TextAlign.left,
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge!
                            .copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 4),
                      child: Text(
                        getClubName(member, clubs),
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                    ),

                    const SizedBox(height: 15),
                    // Dettagli anagrafici
                    Card(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                            child: Row(
                              children: [
                                Text(
                                  'Anagrafica',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Divider(color: Theme.of(context).colorScheme.primary),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 13,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0),
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Data di nascita',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                    ),
                                    Text(
                                      DateFormat('dd/MM/yyyy')
                                          .format(member.birthDate),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                    ),
                                  ],
                                ),
                                Divider(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .outlineVariant),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Email',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                    ),
                                    Text(
                                      member.email.isNotEmpty
                                          ? member.email
                                          : "Nessuna email",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                    ),
                                  ],
                                ),
                                Divider(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .outlineVariant),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Telefono',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                    ),
                                    Text(
                                      member.telephone.isNotEmpty
                                          ? member.telephone
                                          : "Nessun telefono",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                    ),
                                  ],
                                ),
                                Divider(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .outlineVariant),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Indirizzo',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                    ),
                                    Text(
                                      member.address.isNotEmpty
                                          ? member.address
                                          : "Nessun indirizzo",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                    ),
                                  ],
                                ),
                                Divider(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .outlineVariant),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Codice Fiscale',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                    ),
                                    Text(
                                      member.taxIdCode.isNotEmpty
                                          ? member.taxIdCode
                                          : "Nessun codice fiscale",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                    ),
                                  ],
                                ),
                                Divider(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .outlineVariant),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      member.documentType.name.isNotEmpty
                                          ? displayStringForTypeDocument(
                                              member.documentType)
                                          : "Nessun documento",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                    ),
                                    Text(
                                      member.documentNumber.isNotEmpty
                                          ? member.documentNumber
                                          : "Nessun numero documento",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Card(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                            child: Row(
                              children: [
                                Text(
                                  'Consensi',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Divider(color: Theme.of(context).colorScheme.primary),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 13,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0),
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Newsletter',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                    ),
                                    Text(
                                      member.consentNewsletter ? "Sì" : "No",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                    ),
                                  ],
                                ),
                                Divider(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .outlineVariant),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'WhatsApp',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                    ),
                                    Text(
                                      member.consentWhatsApp ? "Sì" : "No",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: FloatingActionButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: TextField(
                          decoration: InputDecoration(
                            labelText: 'Assegna numero di tessera',
                            fillColor:
                                Theme.of(context).colorScheme.surfaceVariant,
                            filled: true,
                            border: InputBorder.none,
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.error),
                            ),
                            focusedErrorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.error),
                            ),
                            labelStyle: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                          keyboardType: TextInputType.number,
                          autocorrect: false,
                          controller: _controller,
                          onChanged: (value) => _controller.text = value),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            ref.read(isLoadingProvider.notifier).state = true;
                            var result = await MemberService()
                                .replaceMemberCard(member.id, _controller.text,
                                    ReplaceCardMotivation.nuovaEmissione.index);
                            if (result.hasData) {
                              var aceptedMember = await MemberService()
                                  .renewOrSuspendMember(
                                      member.memberId,
                                      false,
                                      DateHelper.calculateExpirationDate()
                                          .toString());

                              if (aceptedMember.hasData) {
                                ref.read(isLoadingProvider.notifier).state =
                                    false;
                                ref
                                    .read(isMemberPendingDetailsPageProvider
                                        .notifier)
                                    .state = false;
                                ref
                                    .read(filteredMembersProvider.notifier)
                                    .getMembersSuspended();
                                ref.read(isLoadingProvider.notifier).state =
                                    false;
                                Navigator.of(context);
                              }
                            }
                            ref.read(isLoadingProvider.notifier).state = false;
                            Navigator.of(context).pop();
                          },
                          child: Text("Conferma"),
                        )
                      ],
                    );
                  },
                );
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Icon(Icons.check,
                  color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
          SizedBox(width: 10),
          isMembersRejectedDetailsPage
              ? SizedBox.shrink()
              : SizedBox(
                  width: 50,
                  height: 50,
                  child: FloatingActionButton(
                    onPressed: () async {
                      var sm = ScaffoldMessenger.of(context);
                      final countdownController = StreamController<int>();
                      var isCancelled = false;
                      int countdownValue = 5;

                      Timer.periodic(Duration(seconds: 1), (timer) {
                        countdownController.add(countdownValue);
                        if (countdownValue == 0) {
                          timer.cancel();
                          countdownController.close();
                        } else {
                          countdownValue--;
                        }
                      });

                      sm.showSnackBar(
                        SnackBar(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(seconds: 5),
                          content: StreamBuilder<int>(
                            stream: countdownController.stream,
                            builder: (context, snapshot) {
                              return Text(
                                'Socia* rifiutata tra ${snapshot.data ?? 5}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary),
                              );
                            },
                          ),
                          action: SnackBarAction(
                            label: 'Annulla ',
                            onPressed: () {
                              isCancelled = true;
                              ref.read(isLoadingProvider.notifier).state =
                                  false;

                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                            },
                          ),
                        ),
                      );
                      ref.read(isLoadingProvider.notifier).state = true;
                      await Future.delayed(Duration(seconds: 5));

                      if (!isCancelled) {
                        Navigator.of(context).pop();

                        var result = await MemberService()
                            .refuseMember(member.memberId, true);

                        if (result.hasData) {
                          ref.read(isLoadingProvider.notifier).state = false;
                          ref
                              .read(filteredMembersProvider.notifier)
                              .getMembersSuspended();
                          ref.read(isLoadingProvider.notifier).state = false;
                          ref
                              .read(isMemberPendingDetailsPageProvider.notifier)
                              .state = false;
                        }
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Icon(Icons.close,
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
        ],
      ),
    );
  }
}
