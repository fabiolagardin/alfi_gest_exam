import 'package:alfi_gest/helpers/date_time.dart';
import 'package:alfi_gest/helpers/string_helper.dart';
import 'package:alfi_gest/models/enums.dart';
import 'package:alfi_gest/providers/member/create_member_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonalDetailsForm extends ConsumerWidget {
  final GlobalKey<FormState> formKey;

  PersonalDetailsForm({Key? key, required this.formKey}) : super(key: key);
  final TextEditingController dateController = TextEditingController();
  final TextEditingController pronounController = TextEditingController();
  final TextEditingController documentTypeController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Assuming createMemberFormProvider manages the form data
    final formState = ref.watch(createMemberFormProvider);

    // Controller with desired date format
    // Update the controller only if formState.birthDate changes and is not null
    if (DateFormat('dd-MM-yyyy').format(formState.birthDate) !=
        dateController.text) {
      dateController.text =
          DateFormat('dd-MM-yyyy').format(formState.birthDate);
    }

    // Update the pronounController text based on the selected pronoun
    pronounController.text = displayStringForPronoun(formState.pronoun);

    documentTypeController.text =
        displayStringForTypeDocument(formState.documentType);

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            initialValue: formState.legalName,
            decoration: InputDecoration(
              labelText: 'Nome *',
              fillColor: Theme.of(context).colorScheme.surfaceVariant,
              filled: true,
              border: InputBorder.none,
              focusedBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.primary),
              ),
              errorBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.error),
              ),
              focusedErrorBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.error),
              ),
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
            keyboardType: TextInputType.name,
            autocorrect: false,
            onChanged: (value) {
              // Update the provider state with the new name
              ref
                  .read(createMemberFormProvider.notifier)
                  .updateLegalName(value);
            },
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Campo obbligatorio!';
              }
              return null;
            },
          ),
          const SizedBox(height: 13),
          TextFormField(
            initialValue: formState.givenName,
            decoration: InputDecoration(
              labelText: 'Nome scelto',
              fillColor: Theme.of(context).colorScheme.surfaceVariant,
              filled: true,
              border: InputBorder.none,
              focusedBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.primary),
              ),
              errorBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.error),
              ),
              focusedErrorBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.error),
              ),
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            style: Theme.of(context).textTheme.bodyMedium,
            keyboardType: TextInputType.name,
            autocorrect: false,
            onChanged: (value) {
              // Update the provider state with the new name
              ref
                  .read(createMemberFormProvider.notifier)
                  .updateGivenName(value);
            },
            // Add validators and other parameters if needed
          ),
          const SizedBox(height: 13),
          TextFormField(
            initialValue: formState.lastName,
            decoration: InputDecoration(
              labelText: 'Cognome *',
              fillColor: Theme.of(context).colorScheme.surfaceVariant,
              filled: true,
              border: InputBorder.none,
              focusedBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.primary),
              ),
              errorBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.error),
              ),
              focusedErrorBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.error),
              ),
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
            keyboardType: TextInputType.name,
            autocorrect: false,
            onChanged: (value) {
              // Update the provider state with the new name
              ref.read(createMemberFormProvider.notifier).updateLastName(value);
            },
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Campo obbligatorio!';
              }
              return null;
            },
          ),
          const SizedBox(height: 13),
          InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                barrierLabel: "Seleziona il pronome",
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
                            contentPadding:
                                EdgeInsets.only(left: 10, right: 10),
                            title: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 48.0), // Consider the leading space
                                child: Text(
                                  "Seleziona il pronome",
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
                          for (Pronoun value in Pronoun.values)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
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
                                        displayStringForPronoun(value) != ''
                                            ? displayStringForPronoun(value)
                                            : '----',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                      const Spacer(),
                                      Icon(
                                        formState.pronoun == value
                                            ? Icons.radio_button_checked
                                            : Icons.radio_button_unchecked,
                                        color: formState.pronoun == value
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
                                        .read(createMemberFormProvider.notifier)
                                        .updatePronoun(value);

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
              controller: pronounController,
              decoration: InputDecoration(
                labelText: 'Pronome',
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
            ),
          ),
          const SizedBox(height: 13),
          TextFormField(
            controller: dateController,
            decoration: InputDecoration(
              labelText: 'Data di nascita *',
              fillColor: Theme.of(context).colorScheme.surfaceVariant,
              filled: true,
              border: InputBorder.none,
              suffixIcon: const Icon(Icons.calendar_today),
             
              errorBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.error),
              ),
            
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.secondary.withOpacity(1.0),
              ),
            ),

            readOnly: true, // Prevents manually typing the date
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: formState.birthDate,
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
                locale: Locale('it', 'IT'),
              );
              if (pickedDate != null) {
                formState.birthDate = pickedDate;

                // Update the provider state with the new birth date
                ref
                    .read(createMemberFormProvider.notifier)
                    .updateBirthDate(pickedDate);
                // Update the controller text with the formatted date
                dateController.text =
                    DateFormat('dd-MM-yyyy').format(pickedDate);
              }
            },
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Campo obbligatorio!';
              }

              if (!DateHelper.isAdult(formState.birthDate)) {
                return 'Devi essere maggiorenne per iscriverti!';
              }
              return null;
            },
          ),
          const SizedBox(height: 13),
          TextFormField(
            initialValue: formState.taxIdCode.toUpperCase(),
            decoration: InputDecoration(
              labelText: 'Codice fiscale *',
              fillColor: Theme.of(context).colorScheme.surfaceVariant,
              filled: true,
              border: InputBorder.none,
              focusedBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.primary),
              ),
              errorBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.error),
              ),
              focusedErrorBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.error),
              ),
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.characters,
            autocorrect: false,
            onChanged: (value) {
              // Update the provider state with the new name
              ref
                  .read(createMemberFormProvider.notifier)
                  .updateTaxIdCode(value.toUpperCase());
            },
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Campo obbligatorio!';
              }
              if (!RegExp(r'^[A-Z]{6}\d{2}[A-Z]\d{2}[A-Z]\d{3}[A-Z]$')
                  .hasMatch(value.trim())) {
                return 'Per favore inserire un codice fiscale valido.';
              }
              return null;
            },
          ),
          const SizedBox(height: 13),
          InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                barrierLabel: "Seleziona il documento",
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
                            contentPadding:
                                EdgeInsets.only(left: 10, right: 10),
                            title: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 48.0), // Consider the leading space
                                child: Text(
                                  "Seleziona il documento",
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
                          for (TypeDocument value in TypeDocument.values.where(
                              (element) =>
                                  false ==
                                  element.name.contains('nonAssegnato')))
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
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
                                        displayStringForTypeDocument(value),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                      const Spacer(),
                                      Icon(
                                        formState.documentType == value
                                            ? Icons.radio_button_checked
                                            : Icons.radio_button_unchecked,
                                        color: formState.documentType == value
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
                                        .read(createMemberFormProvider.notifier)
                                        .updateDocumentType(value);

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
              controller: documentTypeController,
              decoration: InputDecoration(
                labelText: 'Tipo di documento *',
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
            ),
          ),
          const SizedBox(height: 13),
          TextFormField(
            initialValue: formState.documentNumber,
            decoration: InputDecoration(
              labelText: 'Numero documento *',
              fillColor: Theme.of(context).colorScheme.surfaceVariant,
              filled: true,
              border: InputBorder.none,
              focusedBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.primary),
              ),
              errorBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.error),
              ),
              focusedErrorBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.error),
              ),
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.characters,
            autocorrect: false,
            onChanged: (value) {
              // Update the provider state with the new name
              ref
                  .read(createMemberFormProvider.notifier)
                  .updateDocumentNumber(value);
            },
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Campo obbligatorio!';
              }
              return null;
            },
          ),
          const SizedBox(height: 13),
        ],
      ),
    );
  }
}
