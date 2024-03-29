import 'package:alfi_gest/helpers/date_time.dart';
import 'package:alfi_gest/helpers/string_helper.dart';
import 'package:alfi_gest/pages/members/member_replace_card.dart';
import 'package:alfi_gest/pages/members/members_page.dart';
import 'package:alfi_gest/providers/member/create_member_provider.dart';
import 'package:alfi_gest/screens/main_screen.dart';
import 'package:alfi_gest/services/member_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class MemberDetailsPage extends ConsumerStatefulWidget {
  const MemberDetailsPage({super.key});
  @override
  MemberDetailsPageState createState() => MemberDetailsPageState();
}

class MemberDetailsPageState extends ConsumerState<MemberDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final isMemberReplaceCard = ref.watch(isMemberReplaceCardProvider);
    final member = ref.watch(memberSelected);
    final club = ref.watch(clubSelected);
    final isLoading = ref.watch(isLoadingProvider);
    final formState = ref.read(createMemberFormProvider);
    var isExpiredCard = member.expirationDate.isBefore(DateTime.now());
    return isMemberReplaceCard
        ? MemberReplaceCard()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
              toolbarHeight: 70,
              leading: IconButton(
                  icon: Icon(Icons.chevron_left),
                  color: Theme.of(context).colorScheme.secondary,
                  onPressed: () {
                    ref.read(isMemberPageProvider.notifier).state = true;
                    ref.read(isMainAppBarProvider.notifier).state = true;
                  }),
              actions: [
                TextButton(
                  onPressed: () {
                    ref.read(isMemberDetailsPageProvider.notifier).state =
                        false;
                    ref.read(isMemberDetailsUpdatePageProvider.notifier).state =
                        true;
                    ref.read(isMemberReadyFor.notifier).state = true;

                    formState.memberId = member.memberId;
                    formState.address = member.address;
                    formState.birthDate = member.birthDate;
                    formState.consentNewsletter = member.consentNewsletter;
                    formState.consentWhatsApp = member.consentWhatsApp;
                    formState.creationDate = member.creationDate;
                    formState.pronoun = member.pronoun;
                    formState.birthDate = member.birthDate;
                    formState.documentNumber = member.documentNumber;
                    formState.documentType = member.documentType;
                    formState.email = member.email;
                    formState.expirationDate = member.expirationDate;
                    formState.givenName = member.givenName;
                    formState.haveCardARCI = member.haveCardARCI;
                    formState.idClub = member.idClub;
                    formState.isSuspended = member.isSuspended;
                    formState.lastName = member.lastName;
                    formState.legalName = member.legalName;
                    formState.numberCard = member.numberCard;
                    formState.profileImageString = member.profileImageString;
                    formState.taxIdCode = member.taxIdCode;
                    formState.telephone = member.telephone;
                    formState.updateDate = member.updateDate;
                    formState.updateUser = member.updateUser;
                    formState.userCreation = member.userCreation;
                    formState.volunteerMember = member.volunteerMember;
                    formState.workingPartner = member.workingPartner;
                  },
                  child: Text(
                    "Modifica",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 25),
                      child: Text(
                        '${member.lastName} ${member.givenName.isEmpty ? member.legalName : member.givenName}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ),
                    Card(
                      color: isExpiredCard || member.isSuspended == true
                          ? member.isSuspended == true
                              ? Theme.of(context).colorScheme.onSurfaceVariant
                              : Theme.of(context).colorScheme.errorContainer
                          : Theme.of(context).colorScheme.primary,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 23, vertical: 20),
                            color: Colors.transparent,
                            child: Row(
                              children: [
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      member.numberCard.isNotEmpty
                                          ? member.numberCard
                                          : "Senza tessera",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onTertiary,
                                            fontFamily: "Roboto",
                                          ),
                                    ),
                                    Text(
                                      isExpiredCard ||
                                              member.isSuspended == true
                                          ? member.isSuspended == true
                                              ? 'Socia* Sospesa'
                                              : 'Tessera scaduta'
                                          : 'Tessera valida',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onTertiary,
                                          ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                if (!isExpiredCard &&
                                    member.isSuspended == false)
                                  IconButton(
                                    onPressed: () {
                                      ref
                                          .read(isMemberReplaceCardProvider
                                              .notifier)
                                          .state = true;
                                    },
                                    icon: Icon(Icons.swap_horiz),
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                      Theme.of(context)
                                          .colorScheme
                                          .onPrimary
                                          .withOpacity(0.18),
                                    )),
                                  ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 13,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  Theme.of(context).colorScheme.surfaceVariant,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0),
                              ),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 8.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Data di scadenza',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                    Text(
                                      DateFormat('dd/MM/yyyy')
                                          .format(member.expirationDate),
                                      style: TextStyle(
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
                                      'Social dal',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                    Text(
                                      DateFormat('dd/MM/yyyy')
                                          .format(member.memberSince),
                                      style: TextStyle(
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
                                      'Circolo di appartenenza',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                    Text(
                                      club.nameClub.isNotEmpty
                                          ? club.nameClub
                                          : "Nessun circolo",
                                      style: TextStyle(
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
                                  'Dettagli',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
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
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                    Text(
                                      DateFormat('dd/MM/yyyy')
                                          .format(member.birthDate),
                                      style: TextStyle(
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
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                    Text(
                                      member.email.isNotEmpty
                                          ? member.email
                                          : "Nessuna email",
                                      style: TextStyle(
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
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                    Text(
                                      member.telephone.isNotEmpty
                                          ? member.telephone
                                          : "Nessun telefono",
                                      style: TextStyle(
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
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                    Text(
                                      member.address.isNotEmpty
                                          ? member.address
                                          : "Nessun indirizzo",
                                      style: TextStyle(
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
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                    Text(
                                      member.taxIdCode.isNotEmpty
                                          ? member.taxIdCode
                                          : "Nessun codice fiscale",
                                      style: TextStyle(
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
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                    Text(
                                      member.documentNumber.isNotEmpty
                                          ? member.documentNumber
                                          : "Nessun numero documento",
                                      style: TextStyle(
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
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
            floatingActionButton: Align(
              alignment: isExpiredCard || member.isSuspended == true
                  ? Alignment.bottomRight
                  : Alignment.bottomLeft,
              child: isLoading
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(32, 0, 8, 0),
                      child: const CircularProgressIndicator(),
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(32, 0, 8, 0),
                      child: ElevatedButton(
                        onPressed: () async {
                          ref.read(isLoadingProvider.notifier).state = true;
                          var result = await MemberService()
                              .renewOrSuspendMember(
                                  member.memberId,
                                  isExpiredCard || member.isSuspended == true
                                      ? false
                                      : true,
                                  isExpiredCard || member.isSuspended == true
                                      ? DateHelper.calculateExpirationDate()
                                          .toString()
                                      : member.expirationDate.toString());
                          ref.read(isLoadingProvider.notifier).state = false;
                          if (result.valid) {
                            ref.read(isMemberPageProvider.notifier).state =
                                true;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  content: Text(
                                    isExpiredCard || member.isSuspended == true
                                        ? "Tessera rinnovata con successo!"
                                        : "Socia* sospesa con successo!",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary),
                                  ),
                                  behavior: SnackBarBehavior.floating),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .errorContainer,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  content: Text(
                                    result.error!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onTertiary),
                                  ),
                                  behavior: SnackBarBehavior.floating),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          backgroundColor: isExpiredCard
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: Text(
                            isExpiredCard || member.isSuspended == true
                                ? "Rinnova"
                                : "Sospendi",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                )),
                      ),
                    ),
            ),
          );
  }
}
