import 'package:alfi_gest/providers/create_member_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContactDetailsForm extends ConsumerWidget {
  final GlobalKey<FormState> formKey;

  const ContactDetailsForm({Key? key, required this.formKey}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(createMemberFormProvider);

    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            initialValue: formState.address,
            decoration: InputDecoration(
              labelText: 'Indirizzo *',
              fillColor: Theme.of(context).colorScheme.surfaceVariant,
              filled: true,
              border: InputBorder.none,
            ),
            style: Theme.of(context).textTheme.bodyMedium,

            keyboardType: TextInputType.streetAddress,
            autocorrect: false,
            onChanged: (value) {
              // Aggiorna lo stato del provider con il nuovo nome
              ref.read(createMemberFormProvider.notifier).updateAddress(value);
            },
            // Aggiungi qui validator e altri parametri se necessari
          ),
          const SizedBox(height: 13),
          TextFormField(
            initialValue: formState.telephone,
            decoration: InputDecoration(
              labelText: 'Telefono',
              fillColor: Theme.of(context).colorScheme.surfaceVariant,
              filled: true,
              border: InputBorder.none,
            ),
            style: Theme.of(context).textTheme.bodyMedium,

            keyboardType: TextInputType.phone,
            autocorrect: false,
            onChanged: (value) {
              // Aggiorna lo stato del provider con il nuovo nome
              ref
                  .read(createMemberFormProvider.notifier)
                  .updateTelephone(value);
            },
            // Aggiungi qui validator e altri parametri se necessari
          ),
          const SizedBox(height: 13),
          TextFormField(
            initialValue: formState.email,
            decoration: InputDecoration(
              labelText: 'Email *',
              fillColor: Theme.of(context).colorScheme.surfaceVariant,
              filled: true,
              border: InputBorder.none,
            ),
            style: Theme.of(context).textTheme.bodyMedium,
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            onChanged: (value) {
              // Aggiorna lo stato del provider con il nuovo nome
              ref.read(createMemberFormProvider.notifier).updateEmail(value);
            },
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Campo obbligatorio!';
              }

              // Regular expression pattern per validare la maggior parte degli indirizzi email.
              const emailPattern = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';

              // Verifica che il valore inserito corrisponda al pattern dell'email.
              if (!RegExp(emailPattern).hasMatch(value.trim())) {
                return 'Per favore inserire un email valida.';
              }

              // Se arriva qui, significa che l'email è valida.
              return null;
            },
          ),
          const SizedBox(height: 13),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Switch(
                value: formState.consentWhatsApp,
                onChanged: (bool isConsentWhatsApp) {
                  ref
                      .read(createMemberFormProvider.notifier)
                      .updateConsentWhatsApp(isConsentWhatsApp);
                },
              ),
              const Text('Whatsapp'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Switch(
                value: formState.consentNewsletter,
                onChanged: (bool isConsentNewsletter) {
                  ref
                      .read(createMemberFormProvider.notifier)
                      .updateConsentNewsletter(isConsentNewsletter);
                },
              ),
              const Text('Newsletter'),
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
