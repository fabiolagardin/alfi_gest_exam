import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alfi_gest/providers/create_member_provider.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class PaymentDetailsForm extends ConsumerWidget {
  final GlobalKey<FormState> formKey;

  PaymentDetailsForm({Key? key, required this.formKey}) : super(key: key);
  final TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(createMemberFormProvider);
    // Controller con il formato di data desiderato
    // Aggiorna il controller solo se formState.creditCardExpirationDate cambia e non è null.
    if (formState.creditCardExpirationDate != null &&
        DateFormat('dd-MM-yyyy').format(formState.creditCardExpirationDate!) !=
            dateController.text) {
      dateController.text =
          DateFormat('dd-MM-yyyy').format(formState.creditCardExpirationDate!);
    }
    return Form(
      key: formKey,
      child: SizedBox(
        width: 357,
        height: 290,
        child: DefaultTabController(
          length: 2, // Numero di tab
          child: Column(
            children: [
              TabBar(
                tabs: const [
                  Tab(text: 'Carta di credito'),
                  Tab(text: 'PayPal'),
                ],
                labelColor: Theme.of(context)
                    .colorScheme
                    .primary, // Colore del testo del tab selezionato
                unselectedLabelColor: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant, // Colore del testo del tab non selezionato
                indicatorColor: Theme.of(context)
                    .colorScheme
                    .primary, // Colore dell'indicatore sotto il tab selezionato
                // Aggiungi altri stili al TabBar se necessario
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    // Primo tab: Carta di credito
                    Column(
                      children: [
                        const SizedBox(height: 20),
                        TextFormField(
                          initialValue: formState.creditCardName,
                          decoration: InputDecoration(
                            labelText: 'Intestata a',
                            fillColor:
                                Theme.of(context).colorScheme.surfaceVariant,
                            filled: true,
                            border: InputBorder.none,
                          ),
                          style: Theme.of(context).textTheme.bodyMedium,

                          keyboardType: TextInputType.name,
                          autocorrect: false,
                          onChanged: (value) {
                            // Aggiorna lo stato del provider con il nuovo nome
                            ref
                                .read(createMemberFormProvider.notifier)
                                .updateAddress(value);
                          },
                          // Aggiungi qui validator e altri parametri se necessari
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          initialValue: formState.creditCard,
                          decoration: InputDecoration(
                            labelText: 'Numero Carta',
                            fillColor:
                                Theme.of(context).colorScheme.surfaceVariant,
                            filled: true,
                            border: InputBorder.none,
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(
                                  12.0), // Aggiusta lo spazio come necessario
                              child: Image.asset(
                                  'assets/images/MasterCard.png'), // Assicurati che il percorso dell'immagine sia corretto
                            ),
                          ),
                          style: Theme.of(context).textTheme.bodyMedium,

                          keyboardType: TextInputType.number,
                          autocorrect: false,
                          onChanged: (value) {
                            ref
                                .read(createMemberFormProvider.notifier)
                                .updateCreditCard(value);
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter
                                .digitsOnly, // Accetta solo numeri
                            LengthLimitingTextInputFormatter(
                                19), // Limite di lunghezza per i numeri della carta di credito (16 numeri + 3 spazi)
                          ],
                          // ... Aggiungi qui validator e altri parametri se necessari
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: dateController,
                                decoration: InputDecoration(
                                  labelText: 'Data di scadenza',
                                  fillColor: Theme.of(context)
                                      .colorScheme
                                      .surfaceVariant,
                                  filled: true,
                                  border: InputBorder.none,
                                  suffixIcon: const Icon(Icons.calendar_today),
                                ),
                                readOnly:
                                    true, // Impedisce la digitazione manuale della data
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate:
                                        formState.creditCardExpirationDate ??
                                            DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now(),
                                  );
                                  if (pickedDate != null) {
                                    // Aggiorna lo stato del provider con la nuova data di nascita
                                    ref
                                        .read(createMemberFormProvider.notifier)
                                        .updateCreditCardExpirationDate(
                                            pickedDate);
                                    // Aggiorna il testo del controller con la data formattata
                                    dateController.text =
                                        DateFormat('dd-MM-yyyy')
                                            .format(pickedDate);
                                  }
                                },
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                initialValue: formState.creditCardCvvCode,
                                decoration: InputDecoration(
                                  labelText: 'CVV',
                                  fillColor: Theme.of(context)
                                      .colorScheme
                                      .surfaceVariant,
                                  filled: true,
                                  border: InputBorder.none,
                                  suffixIcon: const Padding(
                                    padding: EdgeInsets.all(
                                        12.0), // Aggiusta lo spazio come necessario
                                    child: Icon(Icons.credit_card_outlined),
                                  ),
                                ),
                                style: Theme.of(context).textTheme.bodyMedium,

                                keyboardType: TextInputType.number,
                                autocorrect: false,
                                onChanged: (value) {
                                  ref
                                      .read(createMemberFormProvider.notifier)
                                      .updateCreditCard(value);
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter
                                      .digitsOnly, // Accetta solo numeri
                                  LengthLimitingTextInputFormatter(3),
                                ],
                                // ... Aggiungi qui validator e altri parametri se necessari
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Secondo tab: PayPal
                    Column(
                      children: [
                        const SizedBox(height: 10),

                        TextFormField(
                          initialValue: formState.paypalEmail,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            fillColor:
                                Theme.of(context).colorScheme.surfaceVariant,
                            filled: true,
                            border: InputBorder.none,
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(
                                  12.0), // Aggiusta lo spazio come necessario
                              child: Image.asset(
                                  'assets/images/Paypal.png'), // Assicurati che il percorso dell'immagine sia corretto
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,

                          onChanged: (value) {
                            ref
                                .read(createMemberFormProvider.notifier)
                                .updatePaypalEmail(value);
                          },
                          // ... Aggiungi qui validator e altri parametri se necessari
                        ),
                        // ... aggiungi qui altri widget per PayPal se necessario
                      ],
                    ),
                  ],
                ),
              ),
              // ... aggiungi qui altri widget se necessario
            ],
          ),
        ),
      ),
    );
  }
}
