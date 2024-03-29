import 'package:alfi_gest/models/enums.dart';
import 'package:alfi_gest/models/member.dart';
import 'package:alfi_gest/models/user_role.dart';
import 'package:alfi_gest/providers/member/create_member_provider.dart';
import 'package:alfi_gest/screens/auth/auth.dart';
import 'package:alfi_gest/services/member_service.dart';
import 'package:alfi_gest/widgets/members/contact_details_form%20.dart';
import 'package:alfi_gest/widgets/members/membership_details_form.dart';
import 'package:alfi_gest/widgets/members/payment_details_form.dart';
import 'package:alfi_gest/widgets/members/personal_details_form.dart';
import 'package:alfi_gest/widgets/members/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterMemberForm extends ConsumerStatefulWidget {
  const RegisterMemberForm({super.key});

  @override
  RegisterMemberFormState createState() => RegisterMemberFormState();
}

class RegisterMemberFormState extends ConsumerState<RegisterMemberForm> {
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

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(isLoadingProvider);
    String namePage = getNameForStep(currentStep);

    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    ref.read(isRegisterMemberProvider.notifier).state = false;
                  },
                  child: Transform.translate(
                    offset: const Offset(-10.0, 0),
                    child: Row(
                      children: [
                        Icon(Icons.chevron_left, size: 32.0),
                        SizedBox(width: 5),
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
            if (currentStep == 1)
              PersonalDetailsForm(formKey: personalDetailFormKey),
            if (currentStep == 2)
              ContactDetailsForm(formKey: contactDetailsFormKey),
            if (currentStep == 3)
              MembershipDetailsForm(formKey: membershipDetailsFormKey),
            if (currentStep == 4)
              PaymentDetailsForm(formKey: paymentDetailFormKey),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (currentStep > 1)
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).primaryColor,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color: Theme.of(context).colorScheme.onPrimary,
                      onPressed: goToPreviousStep,
                    ),
                  ),
                const Spacer(),
                if (currentStep < totalSteps)
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).primaryColor,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      color: Theme.of(context).colorScheme.onPrimary,
                      onPressed: goToNextStep,
                    ),
                  ),
                if (currentStep == totalSteps)
                  isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () async {
                            ref.read(isLoadingProvider.notifier).state = true;

                            final formState =
                                ref.read(createMemberFormProvider);

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
                              profileImageString: formState.profileImageString,
                              replaceCardMotivation:
                                  formState.replaceCardMotivation,
                              isSuspended: true, // nuova socia sospesa
                              isRejected: false, // nuova socia non rifiutata
                            );

                            final validationResult =
                                newMember.validate(newMember);

                            if (validationResult.valid) {
                              final userResult = await MemberService()
                                  .registerUser(formState.email, "Prova123");
                              if (!mounted) {
                                return;
                              }

                              if (!userResult.valid) {
                                ref.read(isLoadingProvider.notifier).state =
                                    false;

                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title:
                                        const Text('Errore di registrazione'),
                                    content: Text(userResult.error ??
                                        'Si è verificato un errore sconosciuto.'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          ref
                                              .read(
                                                  isErrorPageProvider.notifier)
                                              .state = true;
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              final userId = userResult.data!;
                              newMember.memberId = userId;
                              newMember.userCreation = userId;
                              newMember.updateUser = userId;
                              final newRole = UserRole(
                                idUserRole: userId,
                                role: Role.socia,
                                creationDate: DateTime.now(),
                                userCreation: userId,
                                updateDate: DateTime.now(),
                                updateUser: userId,
                              );
                              final result = await MemberService()
                                  .createMember(userId, newMember);
                              final setRole = await MemberService()
                                  .setRoleMember(userId, newRole);

                              ref.read(isLoadingProvider.notifier).state =
                                  false;

                              if (result.valid && setRole.valid) {
                                formState.reset();
                                ref.read(isSuccessPageProvider.notifier).state =
                                    true;
                              }
                            } else {
                              ref.read(isLoadingProvider.notifier).state =
                                  false;

                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Errore di registrazione'),
                                  content: Text(validationResult
                                          .errors!.isNotEmpty
                                      ? validationResult.errors!.join(' - ')
                                      : 'Si è verificato un errore sconosciuto.'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        ref
                                            .read(isErrorPageProvider.notifier)
                                            .state = true;
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.only(left: 40, right: 40),
                            minimumSize: Size(0, 48),
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
    );
  }
}
