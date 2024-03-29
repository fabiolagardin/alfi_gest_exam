import 'package:alfi_gest/helpers/string_helper.dart';
import 'package:alfi_gest/pages/members/members_page.dart';
import 'package:alfi_gest/providers/auth/user_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class UserDetails extends ConsumerWidget {
  const UserDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userDataProvider);
    final club = ref.watch(clubSelected);
    var isExpiredCard = userData!.expirationDate.isBefore(DateTime.now());
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            color: isExpiredCard || userData.isSuspended == true
                ? userData.isSuspended == true
                    ? Theme.of(context).colorScheme.onSurfaceVariant
                    : Theme.of(context).colorScheme.errorContainer
                : Theme.of(context).colorScheme.primary,
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 23, vertical: 20),
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userData.numberCard.isNotEmpty
                                ? "N° ${userData.numberCard}"
                                : "Senza tessera",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onTertiary,
                                  fontFamily: "Roboto",
                                ),
                          ),
                          Text(
                            isExpiredCard || userData.isSuspended == true
                                ? userData.isSuspended == true
                                    ? 'Socia* Sospesa'
                                    : 'Tessera scaduta'
                                : 'Tessera valida',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onTertiary,
                                ),
                          ),
                        ],
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 13,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Data di scadenza',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          Text(
                            DateFormat('dd/MM/yyyy')
                                .format(userData.expirationDate),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                      Divider(
                          color: Theme.of(context).colorScheme.outlineVariant),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Social dal',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          Text(
                            DateFormat('dd/MM/yyyy')
                                .format(userData.memberSince),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                      Divider(
                          color: Theme.of(context).colorScheme.outlineVariant),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Circolo di appartenenza',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          Text(
                            club.nameClub.isNotEmpty
                                ? club.nameClub
                                : "Nessun circolo",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
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
                          color: Theme.of(context).colorScheme.primary,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Data di nascita',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          Text(
                            DateFormat('dd/MM/yyyy').format(userData.birthDate),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                      Divider(
                          color: Theme.of(context).colorScheme.outlineVariant),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Email',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          Text(
                            userData.email.isNotEmpty
                                ? userData.email
                                : "Nessuna email",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                      Divider(
                          color: Theme.of(context).colorScheme.outlineVariant),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Telefono',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          Text(
                            userData.telephone.isNotEmpty
                                ? userData.telephone
                                : "Nessun telefono",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                      Divider(
                          color: Theme.of(context).colorScheme.outlineVariant),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Indirizzo',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              userData.address.isNotEmpty
                                  ? userData.address
                                  : "Nessun indirizzo",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                      Divider(
                          color: Theme.of(context).colorScheme.outlineVariant),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Codice Fiscale',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          Text(
                            userData.taxIdCode.isNotEmpty
                                ? userData.taxIdCode
                                : "Nessun codice fiscale",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                      Divider(
                          color: Theme.of(context).colorScheme.outlineVariant),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            userData.documentType.name.isNotEmpty
                                ? displayStringForTypeDocument(
                                    userData.documentType)
                                : "Nessun documento",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          Text(
                            userData.documentNumber.isNotEmpty
                                ? userData.documentNumber
                                : "Nessun numero documento",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
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
    );
  }
}
