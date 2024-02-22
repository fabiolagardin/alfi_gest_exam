import 'package:alfi_gest/helpers/string_helper.dart';
import 'package:alfi_gest/models/enums.dart';
import 'package:alfi_gest/pages/members/members_page.dart';
import 'package:alfi_gest/providers/create_member_provider.dart';
import 'package:alfi_gest/providers/member_data_provider.dart';
import 'package:alfi_gest/screens/main_screen.dart';
import 'package:alfi_gest/services/member_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MemberReplaceCard extends ConsumerStatefulWidget {
  @override
  MemberReplaceCardState createState() => MemberReplaceCardState();
}

class MemberReplaceCardState extends ConsumerState<MemberReplaceCard> {
  final TextEditingController replaceCardController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(createMemberFormProvider);
    final isLoading = ref.watch(isLoadingProvider);
    final member = ref.watch(memberSelected);

    formState.numberCard = member.numberCard;
    formState.memberId = member.memberId;
    // Update the replaceCardController text based on the selected replcaeCardMotivation
    replaceCardController.text =
        displayStringForReplaceCardMotivation(formState.replaceCardMotivation);

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(0, 18, 0, 0),
          child: IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              isLoading
                  ? null
                  : ref.read(isMemberReplaceCardProvider.notifier).state =
                      false;
            },
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 18, 14, 0),
            child: Text(
              "Sostituisci tessera",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Form(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 17.0, vertical: 40),
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: formState.numberCard,
                      decoration: InputDecoration(
                        labelText: 'Numero Tessera *',
                        fillColor: Theme.of(context).colorScheme.surfaceVariant,
                        filled: true,
                        border: InputBorder.none,
                      ),
                      style: Theme.of(context).textTheme.bodyMedium,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) {
                        // Aggiorna lo stato del provider con il nuovo nome
                        ref
                            .read(createMemberFormProvider.notifier)
                            .updateNumberCard(value);
                      },
                      // Aggiungi qui validator e altri parametri se necessari
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          barrierLabel: "Seleziona la motivazione",
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
                                      contentPadding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      title: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right:
                                                  48.0), // Consider the leading space
                                          child: Text(
                                            "Seleziona la motivazione",
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
                                    for (ReplaceCardMotivation value
                                        in ReplaceCardMotivation.values)
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
                                                  displayStringForReplaceCardMotivation(
                                                              value) !=
                                                          ''
                                                      ? displayStringForReplaceCardMotivation(
                                                          value)
                                                      : '----',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge,
                                                ),
                                                const Spacer(),
                                                Icon(
                                                  formState.replaceCardMotivation ==
                                                          value
                                                      ? Icons
                                                          .radio_button_checked
                                                      : Icons
                                                          .radio_button_unchecked,
                                                  color: formState
                                                              .replaceCardMotivation ==
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
                                                  .read(createMemberFormProvider
                                                      .notifier)
                                                  .updateReplaceCardMotivation(
                                                      value);
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
                        controller: replaceCardController,
                        decoration: InputDecoration(
                          labelText: 'Motivazione',
                          filled: true,
                          border: InputBorder.none,
                          suffixIcon: Icon(
                            Icons.arrow_drop_down,
                            color: Theme.of(context)
                                .iconTheme
                                .color
                                ?.withOpacity(1.0),
                          ),
                          labelStyle: TextStyle(
                            color: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.color
                                ?.withOpacity(1.0),
                          ),
                          fillColor: Theme.of(context)
                              .colorScheme
                              .surfaceVariant
                              .withOpacity(1.0),
                        ),
                        enabled: false,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        const Spacer(),
                        isLoading
                            ? CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: () async {
                                  ref.read(isLoadingProvider.notifier).state =
                                      true;
                                  final result = await MemberService()
                                      .replaceMemberCard(
                                          formState.memberId,
                                          formState.numberCard,
                                          formState
                                              .replaceCardMotivation.index);
                                  ref.read(isLoadingProvider.notifier).state =
                                      false;
                                  ref
                                      .read(
                                          isMemberReplaceCardProvider.notifier)
                                      .state = false;
                                  if (result.valid) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        content: Text(
                                            "Carta sostituita con successo!"),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(result.error!),
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 10),
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                                child: Text(
                                  "Sostituisci",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      ),
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
