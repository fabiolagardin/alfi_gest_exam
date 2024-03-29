import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alfi_gest/models/club.dart';
import 'package:alfi_gest/providers/member/create_member_provider.dart';
import 'package:flutter/material.dart';

class ClubsSelectWidget extends ConsumerWidget {
  final TextEditingController clubController;
  final List<Club> clubs;
  final bool isTextField;

  ClubsSelectWidget({
    required this.clubController,
    required this.clubs,
    required this.isTextField,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(createMemberFormProvider);
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          barrierLabel: "Seleziona il circolo",
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.horizontal_rule,
                          size: 40,
                        ),
                      ],
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.only(left: 10, right: 10),
                      title: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 48.0), // Consider the leading space
                          child: Text(
                            "Seleziona il circolo",
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
                    for (Club club in clubs)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                            width: 1.0,
                            color: Theme.of(context).colorScheme.outlineVariant,
                          ))),
                          child: ListTile(
                            title: Row(
                              children: [
                                Text(
                                  club.nameClub,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                const Spacer(),
                                Icon(
                                  formState.idClub == club.idClub
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_unchecked,
                                  color: formState.idClub == club.idClub
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.secondary,
                                ),
                              ],
                            ),
                            onTap: () {
                              ref
                                  .read(createMemberFormProvider.notifier)
                                  .updateIdClub(club.idClub);
                              clubController.text = club.nameClub;

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
      child: isTextField
          ? TextFormField(
              controller: clubController,
              decoration: InputDecoration(
                labelText: 'Circolo *',
                filled: true,
                border: InputBorder.none,
                suffixIcon: Icon(
                  Icons.arrow_drop_down,
                  color: Theme.of(context).iconTheme.color?.withOpacity(1.0),
                ),
                errorBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Theme.of(context).colorScheme.error),
                ),
                labelStyle: TextStyle(
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(1.0),
                ),
                fillColor: Theme.of(context)
                    .colorScheme
                    .surfaceVariant
                    .withOpacity(1.0),
              ),
              enabled: false,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            )
          : TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 0,
                ),
                suffixIcon: Icon(
                  Icons.arrow_drop_down,
                  color: Theme.of(context).iconTheme.color?.withOpacity(1.0),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                    width: 1, // Imposta lo spessore del bordo
                  ),
                ),
              ),
              controller: clubController,
              readOnly: true,
              enabled: false,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
    );
  }
}
