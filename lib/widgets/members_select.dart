import 'package:alfi_gest/helpers/string_helper.dart';
import 'package:alfi_gest/providers/clubs/create_club_provider.dart';
import 'package:alfi_gest/screens/main_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alfi_gest/models/member.dart';
import 'package:flutter/material.dart';

class MembersSelectWidget extends ConsumerWidget {
  final TextEditingController memberController;
  final List<Member> members;
  final String idClub;
  final String label;
  final String placeholder;
  final void Function(Member) onSelected;

  MembersSelectWidget({
    required this.memberController,
    required this.members,
    required this.idClub,
    required this.label,
    required this.placeholder,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(createClubFormProvider);

    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          barrierLabel: label,
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
                            placeholder,
                          ),
                        ),
                      ),
                      leading: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          onSelected;
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    for (Member member in members)
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
                                  formatMemberName(member),
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                const Spacer(),
                                Icon(
                                  formState.idClubSecretary == member.memberId
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_unchecked,
                                  color: formState.idClubSecretary ==
                                          member.memberId
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.secondary,
                                ),
                              ],
                            ),
                            onTap: () {
                              ref
                                  .read(createClubFormProvider.notifier)
                                  .setIdClubSecretary(member.memberId);
                              memberController.text = formatMemberName(member);
                              ref.read(isClubReadyFor.notifier).state = true;
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
        controller: memberController,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          border: InputBorder.none,
          suffixIcon: Icon(
            Icons.arrow_drop_down,
            color: Theme.of(context).iconTheme.color?.withOpacity(1.0),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
          ),
          labelStyle: TextStyle(
            color: Theme.of(context).colorScheme.secondary.withOpacity(1.0),
          ),
          fillColor:
              Theme.of(context).colorScheme.surfaceVariant.withOpacity(1.0),
        ),
        enabled: false,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.secondary,
            ),
      ),
    );
  }
}
