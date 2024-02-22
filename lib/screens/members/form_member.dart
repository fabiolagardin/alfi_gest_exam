import 'package:alfi_gest/models/member.dart';
import 'package:alfi_gest/providers/create_member_provider.dart';
import 'package:alfi_gest/services/member_service.dart';
import 'package:alfi_gest/widgets/members/contact_details_form%20.dart';
import 'package:alfi_gest/widgets/members/membership_details_form.dart';
import 'package:alfi_gest/widgets/members/payment_details_form.dart';
import 'package:alfi_gest/widgets/members/personal_details_form.dart';
import 'package:alfi_gest/widgets/members/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateMemberForm extends ConsumerStatefulWidget {
  const CreateMemberForm({super.key});

  @override
  CreateMemberFormState createState() => CreateMemberFormState();
}

class CreateMemberFormState extends ConsumerState<CreateMemberForm> {
  int currentStep = 1;
  final int totalSteps =
      4; // Numero totale di passaggi come mostrato nel design
  final GlobalKey<FormState> personalDetailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> contactDetailsFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> membershipDetailsFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> paymentDetailFormKey = GlobalKey<FormState>();
  String getNameForStep(int step) {
    switch (step) {
      case 1:
        return "Dettagli Personali";
      case 2:
        return "Contatti e Consensi";
      case 3:
        return "Circolo e Tessera";
      case 4:
        return "Pagamento";
      default:
        return "Dettaglio Sconosciuto";
    }
  }

  void goToNextStep() {
    if (currentStep < totalSteps) {
      bool isCurrentStepValid = false;
      switch (currentStep) {
        case 1:
          isCurrentStepValid =
              personalDetailFormKey.currentState?.validate() ?? false;
          break;
        case 2:
          isCurrentStepValid =
              contactDetailsFormKey.currentState?.validate() ?? false;
          break;
        case 3:
          isCurrentStepValid =
              membershipDetailsFormKey.currentState?.validate() ?? false;
          break;
        case 4:
          isCurrentStepValid =
              paymentDetailFormKey.currentState?.validate() ?? false;
          break;
      }
      if (isCurrentStepValid) {
        setState(() => currentStep++);
      } else {
        setState(() {
          // Questo forzerà il rebuild dei widget e mostrerà i messaggi di errore
        });
      }
    }
  }

  void goToPreviousStep() {
    if (currentStep > 1) {
      setState(() => currentStep--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(createMemberFormProvider);
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    final isLoading = ref.watch(isLoadingProvider);
    String namePage = getNameForStep(currentStep);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 34),
          child: Column(
            children: [
              Container(
                //margin: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(
                    top: 40, bottom: 50, right: 20, left: 20),
                width: 100,
                child: isDarkMode
                    ? Image.asset('assets/images/logo-dark.png')
                    : Image.asset('assets/images/logo-light.png'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => Navigator.pushNamed(context, '/login'),
                    child: Row(
                      children: [
                        Icon(Icons.chevron_left, size: 32.0),
                        SizedBox(
                            width:
                                5), // Aggiungi uno spazio tra l'icona e il testo
                        Text(
                          'Torna al login',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 12,
              ),
              StepProgressIndicator(
                currentStep: currentStep,
                totalSteps: totalSteps,
                namePage: namePage,
              ),
              const SizedBox(height: 20),
              // Qui aggiungiamo il widget del form attuale in base al passo
              if (currentStep == 1)
                PersonalDetailsForm(formKey: personalDetailFormKey),
              if (currentStep == 2)
                ContactDetailsForm(formKey: contactDetailsFormKey),
              if (currentStep == 3)
                MembershipDetailsForm(formKey: membershipDetailsFormKey),
              if (currentStep == 4)
                PaymentDetailsForm(formKey: paymentDetailFormKey),

              // Navigazione tra i passaggi:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (currentStep > 1)
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            Theme.of(context).primaryColor, // Background color
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        color: Colors.white,
                        onPressed: goToPreviousStep,
                      ),
                    ),
                  const Spacer(), // Questo crea uno spazio tra i due bottoni
                  if (currentStep < totalSteps)
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            Theme.of(context).primaryColor, // Background color
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        color: Colors.white,
                        onPressed: goToNextStep,
                      ),
                    ),
                  if (currentStep == totalSteps)
                    isLoading
                        ? const CircularProgressIndicator() // Mostra lo spinner se isLoading è true
                        : ElevatedButton(
                            onPressed: () async {
                              // Imposta isLoading su true
                              ref.read(isLoadingProvider.notifier).state = true;

                              // Raccogli i dati dal provider
                              final formState =
                                  ref.read(createMemberFormProvider);

                              // Crea l'oggetto Member
                              final newMember = Member(
                                memberId: "",
                                legalName: formState.legalName,
                                givenName: formState.givenName,
                                lastName: formState.lastName,
                                pronoun: formState.pronoun,
                                address: formState.address,
                                birthDate: formState.birthDate,
                                taxIdCode: formState.taxIdCode,
                                documentType: formState.documentType,
                                documentNumber: formState.documentNumber,
                                telephone: formState.telephone,
                                email: formState.email,
                                consentWhatsApp: formState.consentWhatsApp,
                                consentNewsletter: formState.consentNewsletter,
                                workingPartner: formState.workingPartner,
                                volunteerMember: formState.volunteerMember,
                                numberCard: formState.numberCard,
                                idClub: formState.idClub,
                                haveCardARCI: formState.haveCardARCI,
                                memberSince: DateTime.now(),
                                creationDate: DateTime.now(),
                                userCreation: "",
                                updateDate: DateTime.now(),
                                updateUser: "",
                                dateLastRenewal: DateTime.now(),
                                expirationDate: DateTime.now(),
                                profileImageFile: formState.profileImageFile,
                                replaceCardMotivation:
                                    formState.replaceCardMotivation,
                                isSuspended: formState.isSuspended,
                              );

                              // Valida i dati
                              final validationResult =
                                  newMember.validate(newMember);

                              if (validationResult.valid) {
                                final userResult = await MemberService()
                                    .registerUser(formState.email, "Prova123");
                                if (!mounted) {
                                  return; // Verifica che il widget sia ancora nell'albero
                                }

                                if (!userResult.valid) {
                                  ref.read(isLoadingProvider.notifier).state =
                                      false;

                                  // Errore durante la registrazione dell'utente
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title:
                                          const Text('Errore di registrazione'),
                                      content: Text(userResult.error ??
                                          'Si è verificato un errore sconosciuto.'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () => Navigator.pushNamed(
                                              context, '/error-page'),
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                final userId =
                                    userResult.data!; // Estrai l'ID dell'utente
                                newMember.memberId = userId;
                                newMember.userCreation = userId;
                                newMember.updateUser = userId;
                                // Salva i dati su Firebase
                                final result = await MemberService()
                                    .createMember(userId, newMember);

                                // Imposta isLoading su false
                                ref.read(isLoadingProvider.notifier).state =
                                    false;
                                // Gestisci il risultato
                                if (result.valid) {
                                  // Successo: naviga verso una nuova schermata o mostra un messaggio
                                  Navigator.pushNamed(context, '/success-page');
                                } else {
                                  // Errore: mostra un messaggio di errore
                                  Navigator.pushNamed(context, '/error-page');
                                }
                              } else {
                                ref.read(isLoadingProvider.notifier).state =
                                    false;
                                // Errore durante la registrazione dell'utente
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title:
                                        const Text('Errore di registrazione'),
                                    content: Text(validationResult
                                            .errors!.isNotEmpty
                                        ? validationResult.errors!.join(' - ')
                                        : 'Si è verificato un errore sconosciuto.'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () => Navigator.pushNamed(
                                            context, '/error-page'),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.only(left: 40, right: 40),
                              minimumSize:
                                  Size(0, 48), // Imposta l'altezza desiderata
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              alignment: Alignment.center,
                            ),
                            child: Text(
                              'Richiedi tessera',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
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
