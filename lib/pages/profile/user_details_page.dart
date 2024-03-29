import 'package:alfi_gest/core/result.dart';
import 'package:alfi_gest/helpers/string_helper.dart';
import 'package:alfi_gest/models/enums.dart';
import 'package:alfi_gest/models/member.dart';
import 'package:alfi_gest/pages/members/members_page.dart';
import 'package:alfi_gest/providers/auth/user_data_provider.dart';
import 'package:alfi_gest/providers/member/create_member_provider.dart';
import 'package:alfi_gest/screens/main_screen.dart';
import 'package:alfi_gest/screens/profile_screen.dart';
import 'package:alfi_gest/services/member_service.dart';
import 'package:alfi_gest/widgets/custom_snack_bars.dart';
import 'package:alfi_gest/widgets/image_picker_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserDetailsPage extends ConsumerStatefulWidget {
  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends ConsumerState<UserDetailsPage> {
  @override
  final TextEditingController pronController = TextEditingController();
  Widget build(BuildContext context) {
    final isLoading = ref.watch(isLoadingProvider);
    final formState = ref.read(createMemberFormProvider);
    final member = ref.watch(memberSelected);
    final user = ref.watch(userProvider);
    final imageProfileUrl = ref.watch(getImageProfileProvider(member.id)).value;
    setState(() {
      pronController.text = displayStringForPronoun(formState.pronoun);
    });
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0, 18, 0, 0),
          child: Text(
            member.title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w400,
                  fontSize: 22,
                  fontFamily: "Roboto",
                ),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(0, 28, 0, 0),
          child: isLoading
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(22, 14, 0, 0),
                  child: Text(
                    "Annulla",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.5),
                        ),
                  ),
                )
              : TextButton(
                  onPressed: () {
                    ref.read(isUserDetailsPageProvider.notifier).state = false;
                    formState.reset();
                  },
                  child: Text(
                    "Annulla",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                ),
        ),
        leadingWidth: 100,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 28, 0, 0),
            child: !isLoading
                ? TextButton(
                    onPressed: () async {
                      // Imposta isLoading su true
                      ref.read(isLoadingProvider.notifier).state = true;

                      // Raccogli i dati dal provider
                      final formState = ref.read(createMemberFormProvider);

                      // Crea l'oggetto Member
                      final updateProfile = Member(
                        memberId: formState.memberId.isEmpty
                            ? member.memberId
                            : formState.memberId,
                        legalName: formState.legalName,
                        givenName: formState.givenName,
                        lastName: formState.lastName,
                        pronoun: formState.pronoun != member.pronoun
                            ? formState.pronoun
                            : member.pronoun,
                        address: formState.address.isEmpty
                            ? member.address
                            : formState.address,
                        birthDate: formState.birthDate,
                        taxIdCode: formState.taxIdCode,
                        documentType: formState.documentType,
                        documentNumber: formState.documentNumber,
                        telephone: formState.telephone.isEmpty
                            ? member.telephone
                            : formState.telephone,
                        email: formState.email.isEmpty
                            ? member.email
                            : formState.email,
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
                        expirationDate: formState.expirationDate,
                        profileImageString:
                            formState.profileImageString != null &&
                                    formState.profileImageString!.isEmpty
                                ? member.profileImageString
                                : formState.profileImageString,
                        replaceCardMotivation: formState.replaceCardMotivation,
                        isSuspended: formState.isSuspended,
                        isRejected: formState.isRejected,
                      );

                      final memberId = user.value!.uid;

                      updateProfile.updateUser = user.value!.uid;

                      final memberService = MemberService();
                      final result = await memberService.updateProfile(
                          memberId, updateProfile);
                      final updateImage = member.profileImageString!.isNotEmpty
                          ? await memberService.uploadImageProfile(
                              updateProfile.profileImageString ?? "",
                              updateProfile.memberId,
                            )
                          : Result(
                              valid: true, message: "Immagine non caricata");

                      if (!mounted) {
                        return;
                      }
                      // Gestisci il risultato
                      if (result.valid && updateImage.valid) {
                        final result =
                            ref.refresh(getImageProfileProvider(member.id));

                        ref.read(isLoadingProvider.notifier).state = false;
                        ref.read(isMainAppBarProvider.notifier).state = true;
                        ref.read(isUserDetailsPageProvider.notifier).state =
                            false;
                        CustomSnackBar.showSuccessSnackBar(
                            context: context,
                            message: "Profilo aggiornato con successo!");
                      } else {
                        CustomSnackBar.showErrorSnackBar(
                          context: context,
                          message: "${result.error} ${updateImage.error}",
                        );
                        ref.read(isLoadingProvider.notifier).state = false;
                      }
                    },
                    child: Text(
                      "Salva",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Text(
                      "Salva",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.5),
                          ),
                    ),
                  ),
          ),
        ],

        //

        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        centerTitle: true,
      ),

      //
      body: isLoading
          ? Center(child: const CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                                  displayStringForPronoun(
                                                              value) !=
                                                          ''
                                                      ? displayStringForPronoun(
                                                          value)
                                                      : '----',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge,
                                                ),
                                                const Spacer(),
                                                Icon(
                                                  formState.pronoun == value
                                                      ? Icons
                                                          .radio_button_checked
                                                      : Icons
                                                          .radio_button_unchecked,
                                                  color:
                                                      formState.pronoun == value
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
                                              setState(() {
                                                ref
                                                    .read(
                                                        createMemberFormProvider
                                                            .notifier)
                                                    .updatePronoun(value);
                                                pronController.text =
                                                    displayStringForPronoun(
                                                        formState.pronoun);
                                              });

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
                        controller: pronController,
                        decoration: InputDecoration(
                          labelText: 'Pronome',
                          filled: true,
                          border: InputBorder.none,
                          suffixIcon: Icon(
                            Icons.arrow_drop_down,
                            color: Theme.of(context)
                                .iconTheme
                                .color
                                ?.withOpacity(1.0),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.error),
                          ),
                          labelStyle: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(1.0),
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
                    const SizedBox(height: 11),
                    TextFormField(
                      initialValue: member.address,
                      decoration: InputDecoration(
                        labelText: 'Indirizzo *',
                        fillColor: Theme.of(context).colorScheme.surfaceVariant,
                        filled: true,
                        border: InputBorder.none,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.error),
                        ),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.error),
                        ),
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                      keyboardType: TextInputType.streetAddress,
                      autocorrect: false,
                      onChanged: (value) {
                        // Aggiorna lo stato del provider con il nuovo nome
                        ref
                            .read(createMemberFormProvider.notifier)
                            .updateAddress(value);
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
                      initialValue: member.telephone,
                      decoration: InputDecoration(
                        labelText: 'Telefono',
                        fillColor: Theme.of(context).colorScheme.surfaceVariant,
                        filled: true,
                        border: InputBorder.none,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.error),
                        ),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.error),
                        ),
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),

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
                      initialValue: member.email,
                      decoration: InputDecoration(
                        labelText: 'Email *',
                        fillColor: Theme.of(context).colorScheme.surfaceVariant,
                        filled: true,
                        border: InputBorder.none,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.error),
                        ),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.error),
                        ),
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      onChanged: (value) {
                        // Aggiorna lo stato del provider con il nuovo nome
                        ref
                            .read(createMemberFormProvider.notifier)
                            .updateEmail(value);
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Campo obbligatorio!';
                        }

                        // Regular expression pattern per validare la maggior parte degli indirizzi email.
                        const emailPattern =
                            r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';

                        // Verifica che il valore inserito corrisponda al pattern dell'email.
                        if (!RegExp(emailPattern).hasMatch(value.trim())) {
                          return 'Per favore inserire un email valida.';
                        }

                        // Se arriva qui, significa che l'email è valida.
                        return null;
                      },
                    ),
                    const SizedBox(height: 13),
                    ImagePickerTextField(
                      labelText: 'Immagine profilo',
                      onImageSelected: (imagePath) {
                        formState.profileImageString = imagePath;
                        member.profileImageString = imagePath;
                      },
                      imageUrl:
                          imageProfileUrl != null ? imageProfileUrl.data : null,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
