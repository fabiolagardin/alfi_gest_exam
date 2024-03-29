import 'package:alfi_gest/helpers/date_time.dart';
import 'package:alfi_gest/core/result.dart';
import 'package:alfi_gest/helpers/string_helper.dart';
import 'package:alfi_gest/models/user_role.dart';
import 'package:alfi_gest/models/enums.dart';
import 'package:alfi_gest/models/member.dart';
import 'package:alfi_gest/providers/auth/user_data_provider.dart';
import 'package:alfi_gest/providers/clubs/clubs_provider.dart';
import 'package:alfi_gest/providers/member/create_member_provider.dart';
import 'package:alfi_gest/providers/member/member_data_provider.dart';
import 'package:alfi_gest/providers/member/member_role_provider.dart';
import 'package:alfi_gest/screens/main_screen.dart';
import 'package:alfi_gest/services/member_service.dart';
import 'package:alfi_gest/widgets/clubs/clubs_select.dart';
import 'package:alfi_gest/widgets/custom_snack_bars.dart';
import 'package:alfi_gest/widgets/tab_bar_custom.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CreateMemberPage extends ConsumerStatefulWidget {
  const CreateMemberPage({super.key});

  @override
  CreateMemberPageState createState() => CreateMemberPageState();
}

class CreateMemberPageState extends ConsumerState<CreateMemberPage>
    with TickerProviderStateMixin {
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController pronController = TextEditingController();
  final TextEditingController docTypeController = TextEditingController();
  final TextEditingController expirationDateController =
      TextEditingController();
  final TextEditingController clubController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  late TabController _tabController;

  void initState() {
    super.initState();
    // Inizializzazione del TabController con 3 tabs
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose(); // Disposizione del TabController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(createMemberFormProvider);
    final user = ref.watch(userProvider);
    final isMemberPage = ref.watch(isMemberPageProvider);
    final clubs = ref.watch(filteredClubsProvider);
    final isReadyFor = ref.watch(isMemberReadyFor);
    final isLoading = ref.watch(isLoadingProvider);
    final isMemberUpdate = ref.watch(isMemberDetailsUpdatePageProvider);
    final listTabsLabels = ['Anagrafica', 'Contatti', 'Circolo'];
    final userRole = ref.watch(roleProvider);
    final userData = ref.watch(memberProvider);
    // Update the pronController and docTypeController text based on the selected pronoun
    pronController.text = displayStringForPronoun(formState.pronoun);
    docTypeController.text =
        displayStringForTypeDocument(formState.documentType);
    expirationDateController.text =
        DateFormat('dd-MM-yyyy').format(formState.birthDate);
    final matchingClubs =
        clubs.where((element) => element.idClub == formState.idClub).toList();
    clubController.text =
        (matchingClubs.isNotEmpty) ? matchingClubs.first.nameClub : '';

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0, 18, 0, 0),
          child: Text(
            isMemberUpdate ? "Modifica socia*" : "Nuova socia*",
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
                    if (isMemberUpdate) {
                      ref.read(isMemberDetailsPageProvider.notifier).state =
                          true;
                      ref.read(isMemberPageProvider.notifier).state = false;
                    } else {
                      ref.read(isMemberPageProvider.notifier).state = true;
                      ref.read(isMemberDetailsPageProvider.notifier).state =
                          false;
                    }
                    ref.read(isMainAppBarProvider.notifier).state = false;

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
            child: isLoading == true
                ? const CircularProgressIndicator()
                : isReadyFor && !isLoading
                    ? TextButton(
                        onPressed: () async {
                          // Valida il form su ciascuna pagina
                          for (int i = 0; i < listTabsLabels.length; i++) {
                            _pageController.jumpToPage(i);
                            _tabController.animateTo(i);

                            // Aspetta un frame per assicurarti che la pagina sia nel tree dei widget
                            await Future.delayed(
                                const Duration(milliseconds: 100));

                            // Valida il form
                            var formIsValid = _formKey.currentState!.validate();

                            // Se il form non è valido, mostra un dialogo di allerta
                            if (!formIsValid) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Errore di validazione'),
                                  content: const Text(
                                      'Si prega di correggere gli errori nel modulo.'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                              return; // Interrompi l'esecuzione se il form non è valido
                            }
                          }

                          // Imposta isLoading su true
                          ref.read(isLoadingProvider.notifier).state = true;

                          // Raccogli i dati dal provider
                          final formState = ref.read(createMemberFormProvider);

                          // Crea l'oggetto Member
                          final member = Member(
                            memberId: formState.memberId,
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
                            idClub: userRole == Role.responsabileCircolo &&
                                    userData != null
                                ? userData.idClub
                                : formState.idClub,
                            haveCardARCI: formState.haveCardARCI,
                            memberSince: DateTime.now(),
                            creationDate: DateTime.now(),
                            userCreation: "",
                            updateDate: DateTime.now(),
                            updateUser: "",
                            dateLastRenewal: DateTime.now(),
                            expirationDate: formState.expirationDate,
                            profileImageString: formState.profileImageString,
                            replaceCardMotivation:
                                formState.replaceCardMotivation,
                            isSuspended: formState.isSuspended,
                            isRejected: formState.isRejected,
                          );

                          // Valida i dati
                          final validationResult = member.validate(member);

                          if (validationResult.valid) {
                            final userResult = isMemberUpdate
                                ? Result(valid: true, data: "update")
                                : await MemberService()
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
                                  title: const Text('Errore di registrazione'),
                                  content: Text(userResult.error ??
                                      'Si è verificato un errore sconosciuto.'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            }
                            final memberId = userResult.data == "update"
                                ? formState.memberId
                                : userResult.data;
                            final newRole = UserRole(
                              idUserRole: memberId!,
                              role: Role.socia,
                              creationDate: DateTime.now(),
                              userCreation: memberId,
                              updateDate: DateTime.now(),
                              updateUser: memberId,
                            );
                            member.userCreation = user.value!.uid;
                            member.updateUser = user.value!.uid;

                            final result = isMemberUpdate
                                ? await MemberService()
                                    .updateMember(memberId, member)
                                : await MemberService()
                                    .createMember(memberId, member);

                            final setRole = await MemberService()
                                .setRoleMember(memberId, newRole);
                            if (!mounted) {
                              return;
                            }
                            // Gestisci il risultato
                            if (result.valid && setRole.valid) {
                              ref.read(isLoadingProvider.notifier).state =
                                  false;
                              ref.read(isMainAppBarProvider.notifier).state =
                                  true;
                              ref.read(isMemberPageProvider.notifier).state =
                                  !isMemberPage;
                              if (isMemberUpdate)
                                ref
                                    .read(isMemberDetailsUpdatePageProvider
                                        .notifier)
                                    .state = false;
                              CustomSnackBar.showSuccessSnackBar(
                                  context: context,
                                  message: isMemberUpdate
                                      ? "Socia* modificata con successo"
                                      : "Socia creata con successo");
                            } else {
                              CustomSnackBar.showErrorSnackBar(
                                context: context,
                                message: "${result.error} ${setRole.error}",
                              );
                              ref.read(isLoadingProvider.notifier).state =
                                  false;
                            }
                          } else {
                            ref.read(isLoadingProvider.notifier).state = false;
                            // Errore durante la registrazione dell'utente
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Errore di registrazione'),
                                content: Text(validationResult.errors != null
                                    ? validationResult.errors!.join(' - ')
                                    : 'Si è verificato un errore sconosciuto.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      ref
                                          .read(isLoadingProvider.notifier)
                                          .state = false;
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        child: Text(
                          "Salva",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  color: isMemberUpdate
                                      ? Theme.of(context).colorScheme.secondary
                                      : Theme.of(context)
                                          .colorScheme
                                          .secondary),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Text(
                          "Salva",
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary
                                        .withOpacity(0.5),
                                  ),
                        ),
                      ),
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();

                  formState.numberCard.isNotEmpty
                      ? ref.read(isMemberReadyFor.notifier).state = true
                      : ref.read(isMemberReadyFor.notifier).state = false;
                },
                child: DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      CustomTabBar(
                        tabController: _tabController,
                        tabsLabels: listTabsLabels,
                        formKey: _formKey,
                        onTapTab: (index) {
                          _formKey.currentState!.validate();

                          // se tutti i 3 tab hanno superto la validazione allora ref.read(isMemberReadyFor.notifier).state = true;
                          if (index == 2 && formState.numberCard.isNotEmpty) {
                            ref.read(isMemberReadyFor.notifier).state = true;
                          } else {
                            ref.read(isMemberReadyFor.notifier).state = false;
                          }
                          _pageController.jumpToPage(index);
                        },
                      ),
                      Expanded(
                        child: PageView(
                          controller: _pageController,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            // Primo tab: Dati anagrafici
                            SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextFormField(
                                      initialValue: formState.legalName,
                                      decoration: InputDecoration(
                                        labelText: 'Nome *',
                                        fillColor: Theme.of(context)
                                            .colorScheme
                                            .surfaceVariant,
                                        filled: true,
                                        border: InputBorder.none,
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                        ),
                                        errorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error),
                                        ),
                                        focusedErrorBorder:
                                            UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error),
                                        ),
                                        labelStyle: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                      keyboardType: TextInputType.name,
                                      autocorrect: false,
                                      onChanged: (value) {
                                        // Aggiorna lo stato del provider con il nuovo nome
                                        ref
                                            .read(createMemberFormProvider
                                                .notifier)
                                            .updateLegalName(value);
                                      },
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return 'Campo obbligatorio!';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 11),
                                    TextFormField(
                                      initialValue: formState.givenName,
                                      decoration: InputDecoration(
                                        labelText: 'Nome scelto',
                                        fillColor: Theme.of(context)
                                            .colorScheme
                                            .surfaceVariant,
                                        filled: true,
                                        border: InputBorder.none,
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                        ),
                                        errorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error),
                                        ),
                                        focusedErrorBorder:
                                            UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error),
                                        ),
                                        labelStyle: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,

                                      keyboardType: TextInputType.name,
                                      autocorrect: false,
                                      onChanged: (value) {
                                        // Aggiorna lo stato del provider con il nuovo nome
                                        ref
                                            .read(createMemberFormProvider
                                                .notifier)
                                            .updateGivenName(value);
                                      },
                                      // Aggiungi qui validator e altri parametri se necessari
                                    ),
                                    const SizedBox(height: 11),
                                    TextFormField(
                                      initialValue: formState.lastName,
                                      decoration: InputDecoration(
                                        labelText: 'Cognome *',
                                        fillColor: Theme.of(context)
                                            .colorScheme
                                            .surfaceVariant,
                                        filled: true,
                                        border: InputBorder.none,
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                        ),
                                        errorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error),
                                        ),
                                        focusedErrorBorder:
                                            UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error),
                                        ),
                                        labelStyle: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                      keyboardType: TextInputType.name,
                                      autocorrect: false,
                                      onChanged: (value) {
                                        // Aggiorna lo stato del provider con il nuovo nome
                                        ref
                                            .read(createMemberFormProvider
                                                .notifier)
                                            .updateLastName(value);
                                      },
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return 'Campo obbligatorio!';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 11),
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
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.horizontal_rule,
                                                          size: 40,
                                                        ),
                                                      ],
                                                    ),
                                                    ListTile(
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              left: 10,
                                                              right: 10),
                                                      title: Center(
                                                        child: Padding(
                                                          padding: const EdgeInsets
                                                              .only(
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
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                    ),
                                                    for (Pronoun value
                                                        in Pronoun.values)
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    10.0),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              border: Border(
                                                                  bottom: BorderSide(
                                                            width: 1.0,
                                                            color: Theme.of(
                                                                    context)
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
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyLarge,
                                                                ),
                                                                const Spacer(),
                                                                Icon(
                                                                  formState.pronoun ==
                                                                          value
                                                                      ? Icons
                                                                          .radio_button_checked
                                                                      : Icons
                                                                          .radio_button_unchecked,
                                                                  color: formState
                                                                              .pronoun ==
                                                                          value
                                                                      ? Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .primary
                                                                      : Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .secondary,
                                                                ),
                                                              ],
                                                            ),
                                                            onTap: () {
                                                              ref
                                                                  .read(createMemberFormProvider
                                                                      .notifier)
                                                                  .updatePronoun(
                                                                      value);

                                                              Navigator.pop(
                                                                  context);
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
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .error),
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(height: 11),
                                    TextFormField(
                                      controller: expirationDateController,

                                      decoration: InputDecoration(
                                        labelText: 'Data di nascita *',
                                        fillColor: Theme.of(context)
                                            .colorScheme
                                            .surfaceVariant,
                                        filled: true,
                                        border: InputBorder.none,
                                        suffixIcon:
                                            const Icon(Icons.calendar_today),
                                        errorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error),
                                        ),
                                        labelStyle: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary
                                              .withOpacity(1.0),
                                        ),
                                      ),
                                      readOnly:
                                          true, // Impedisce la digitazione manuale della data
                                      onTap: () async {
                                        final DateTime? pickedDate =
                                            await showDatePicker(
                                          context: context,
                                          initialDate: formState.birthDate,
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime.now(),
                                          locale: Locale('it', 'IT'),
                                        );

                                        if (pickedDate != null) {
                                          formState.birthDate = pickedDate;
                                          // Aggiorna lo stato del provider con la nuova data di nascita
                                          ref
                                              .read(createMemberFormProvider
                                                  .notifier)
                                              .updateBirthDate(pickedDate);
                                          // Aggiorna il testo del controller con la data formattata
                                          expirationDateController.text =
                                              DateFormat('dd-MM-yyyy')
                                                  .format(pickedDate);
                                        }
                                      },
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                      validator: (value) {
                                        if (!DateHelper.isAdult(
                                            formState.birthDate)) {
                                          return 'Devi avere almeno 18 anni per iscriverti';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 11),
                                    TextFormField(
                                      initialValue: formState.taxIdCode,
                                      decoration: InputDecoration(
                                        labelText: 'Codice fiscale *',
                                        fillColor: Theme.of(context)
                                            .colorScheme
                                            .surfaceVariant,
                                        filled: true,
                                        border: InputBorder.none,
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                        ),
                                        errorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error),
                                        ),
                                        focusedErrorBorder:
                                            UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error),
                                        ),
                                        labelStyle: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                      keyboardType: TextInputType.text,
                                      textCapitalization:
                                          TextCapitalization.characters,
                                      autocorrect: false,
                                      onChanged: (value) {
                                        // Aggiorna lo stato del provider con il nuovo nome
                                        ref
                                            .read(createMemberFormProvider
                                                .notifier)
                                            .updateTaxIdCode(value);
                                      },
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return 'Campo obbligatorio!';
                                        }
                                        if (!RegExp(
                                                r'^[A-Z]{6}\d{2}[A-Z]\d{2}[A-Z]\d{3}[A-Z]$')
                                            .hasMatch(value.trim())) {
                                          return 'Per favore inserire un codice fiscale valido.';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 11),
                                    InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          barrierLabel:
                                              "Seleziona il documento",
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
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.horizontal_rule,
                                                          size: 40,
                                                        ),
                                                      ],
                                                    ),
                                                    ListTile(
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              left: 10,
                                                              right: 10),
                                                      title: Center(
                                                        child: Padding(
                                                          padding: const EdgeInsets
                                                              .only(
                                                              right:
                                                                  48.0), // Consider the leading space
                                                          child: Text(
                                                            "Seleziona il documento",
                                                          ),
                                                        ),
                                                      ),
                                                      leading: IconButton(
                                                        icon: Icon(Icons.close),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                    ),
                                                    for (TypeDocument value
                                                        in TypeDocument.values
                                                            .where((element) =>
                                                                false ==
                                                                element.name
                                                                    .contains(
                                                                        'nonAssegnato')))
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    10.0),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              border: Border(
                                                                  bottom: BorderSide(
                                                            width: 1.0,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .outlineVariant,
                                                          ))),
                                                          child: ListTile(
                                                            title: Row(
                                                              children: [
                                                                Text(
                                                                  displayStringForTypeDocument(
                                                                      value),
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyLarge,
                                                                ),
                                                                const Spacer(),
                                                                Icon(
                                                                  formState.documentType ==
                                                                          value
                                                                      ? Icons
                                                                          .radio_button_checked
                                                                      : Icons
                                                                          .radio_button_unchecked,
                                                                  color: formState
                                                                              .documentType ==
                                                                          value
                                                                      ? Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .primary
                                                                      : Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .secondary,
                                                                ),
                                                              ],
                                                            ),
                                                            onTap: () {
                                                              ref
                                                                  .read(createMemberFormProvider
                                                                      .notifier)
                                                                  .updateDocumentType(
                                                                      value);

                                                              Navigator.pop(
                                                                  context);
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
                                        controller: docTypeController,
                                        decoration: InputDecoration(
                                          labelText: 'Tipo di documento *',
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
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .error),
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            ),
                                        validator: (value) {
                                          if (value == '') {
                                            return 'Campo obbligatorio!';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 11),
                                    TextFormField(
                                      initialValue: formState.documentNumber,
                                      decoration: InputDecoration(
                                        labelText: 'Numero documento *',
                                        fillColor: Theme.of(context)
                                            .colorScheme
                                            .surfaceVariant,
                                        filled: true,
                                        border: InputBorder.none,
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                        ),
                                        errorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error),
                                        ),
                                        focusedErrorBorder:
                                            UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error),
                                        ),
                                        labelStyle: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                      keyboardType: TextInputType.text,
                                      textCapitalization:
                                          TextCapitalization.characters,
                                      autocorrect: false,
                                      onChanged: (value) {
                                        // Aggiorna lo stato del provider con il nuovo nome
                                        ref
                                            .read(createMemberFormProvider
                                                .notifier)
                                            .updateDocumentNumber(value);
                                      },
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return 'Campo obbligatorio!';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 11),
                                  ],
                                ),
                              ),
                            ),
                            // Secondo tab: Contatti
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 16),
                              child: Column(
                                children: [
                                  TextFormField(
                                    initialValue: formState.address,
                                    decoration: InputDecoration(
                                      labelText: 'Indirizzo *',
                                      fillColor: Theme.of(context)
                                          .colorScheme
                                          .surfaceVariant,
                                      filled: true,
                                      border: InputBorder.none,
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                      ),
                                      errorBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error),
                                      ),
                                      focusedErrorBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error),
                                      ),
                                      labelStyle: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                    keyboardType: TextInputType.streetAddress,
                                    autocorrect: false,
                                    onChanged: (value) {
                                      // Aggiorna lo stato del provider con il nuovo nome
                                      ref
                                          .read(
                                              createMemberFormProvider.notifier)
                                          .updateAddress(value);
                                    },
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'Campo obbligatorio!';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 13),
                                  TextFormField(
                                    initialValue: formState.telephone,
                                    decoration: InputDecoration(
                                      labelText: 'Telefono',
                                      fillColor: Theme.of(context)
                                          .colorScheme
                                          .surfaceVariant,
                                      filled: true,
                                      border: InputBorder.none,
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                      ),
                                      errorBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error),
                                      ),
                                      focusedErrorBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error),
                                      ),
                                      labelStyle: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),

                                    keyboardType: TextInputType.phone,
                                    autocorrect: false,
                                    onChanged: (value) {
                                      // Aggiorna lo stato del provider con il nuovo nome
                                      ref
                                          .read(
                                              createMemberFormProvider.notifier)
                                          .updateTelephone(value);
                                    },
                                    // Aggiungi qui validator e altri parametri se necessari
                                  ),
                                  const SizedBox(height: 13),
                                  TextFormField(
                                    initialValue: formState.email,
                                    decoration: InputDecoration(
                                      labelText: 'Email *',
                                      fillColor: Theme.of(context)
                                          .colorScheme
                                          .surfaceVariant,
                                      filled: true,
                                      border: InputBorder.none,
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                      ),
                                      errorBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error),
                                      ),
                                      focusedErrorBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error),
                                      ),
                                      labelStyle: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                    keyboardType: TextInputType.emailAddress,
                                    autocorrect: false,
                                    onChanged: (value) {
                                      // Aggiorna lo stato del provider con il nuovo nome
                                      ref
                                          .read(
                                              createMemberFormProvider.notifier)
                                          .updateEmail(value);
                                    },
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'Campo obbligatorio!';
                                      }

                                      // Regular expression pattern per validare la maggior parte degli indirizzi email.
                                      const emailPattern =
                                          r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';

                                      // Verifica che il valore inserito corrisponda al pattern dell'email.
                                      if (!RegExp(emailPattern)
                                          .hasMatch(value.trim())) {
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
                                              .read(createMemberFormProvider
                                                  .notifier)
                                              .updateConsentWhatsApp(
                                                  isConsentWhatsApp);
                                        },
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'Whatsapp',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            ),
                                      ),
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
                                              .read(createMemberFormProvider
                                                  .notifier)
                                              .updateConsentNewsletter(
                                                  isConsentNewsletter);
                                        },
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'Newsletter',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 30),
                                ],
                              ),
                            ),
                            // Terzo Tab: Circolo
                            userData == null ||
                                    clubs.isEmpty ||
                                    userRole == null
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 16),
                                    child: Column(
                                      children: [
                                        userRole == Role.responsabileCircolo
                                            ? TextFormField(
                                                decoration: InputDecoration(
                                                  labelText: 'Circolo *',
                                                  filled: true,
                                                  border: InputBorder.none,
                                                  errorBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .error),
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
                                                readOnly: true,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                    ),
                                                initialValue: clubs
                                                    .where((c) =>
                                                        c.idClub ==
                                                        userData.idClub)
                                                    .first
                                                    .nameClub,
                                              )
                                            : ClubsSelectWidget(
                                                clubController: clubController,
                                                clubs: clubs,
                                                isTextField: true,
                                              ),
                                        const SizedBox(height: 11),
                                        TextFormField(
                                          initialValue: DateFormat('dd-MM-yyyy')
                                              .format(formState.expirationDate),
                                          decoration: InputDecoration(
                                            labelText: 'Data di Scadenza',
                                            fillColor: Theme.of(context)
                                                .colorScheme
                                                .surfaceVariant,
                                            filled: true,
                                            border: InputBorder.none,
                                            errorBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .error),
                                            ),
                                            labelStyle: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            ),
                                          ),
                                          readOnly: true,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                              ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return 'Campo obbligatorio!';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 11),
                                        TextFormField(
                                          initialValue: formState.numberCard,
                                          decoration: InputDecoration(
                                            labelText: 'Numero Tessera *',
                                            fillColor: Theme.of(context)
                                                .colorScheme
                                                .surfaceVariant,
                                            filled: true,
                                            border: InputBorder.none,
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary),
                                            ),
                                            errorBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .error),
                                            ),
                                            focusedErrorBorder:
                                                UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .error),
                                            ),
                                            labelStyle: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            ),
                                          ),
                                          readOnly:
                                              isMemberUpdate ? true : false,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                              ),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          onChanged: (value) {
                                            ref
                                                .read(createMemberFormProvider
                                                    .notifier)
                                                .updateNumberCard(value);
                                          },
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return 'Campo obbligatorio!';
                                            }
                                            if (value.length < 6) {
                                              return 'Il numero della tessera deve essere di almeno 6 cifre';
                                            }
                                            if (value.length > 6) {
                                              return 'Il numero della tessera deve essere di al massimo 6 cifre';
                                            }
                                            //deve essere solo numero
                                            if (!RegExp(r'^[0-9]*$')
                                                .hasMatch(value)) {
                                              return 'Il numero della tessera deve essere solo numerico';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 22),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Switch(
                                              value: formState.haveCardARCI,
                                              onChanged: (bool haveCardARCI) {
                                                ref
                                                    .read(
                                                        createMemberFormProvider
                                                            .notifier)
                                                    .updateHaveCardARCI(
                                                        haveCardARCI);
                                              },
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              'Tessera ARCI',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Switch(
                                              value: formState.workingPartner,
                                              onChanged: (bool workingPartner) {
                                                ref
                                                    .read(
                                                        createMemberFormProvider
                                                            .notifier)
                                                    .updateWorkingMember(
                                                        workingPartner);
                                              },
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              'Socia* Lavoratrice',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Switch(
                                              value: formState.volunteerMember,
                                              onChanged:
                                                  (bool volunteerMember) {
                                                ref
                                                    .read(
                                                        createMemberFormProvider
                                                            .notifier)
                                                    .updateVolunteerMember(
                                                        volunteerMember);
                                              },
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              'Socia* Volontaria',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 25,
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
