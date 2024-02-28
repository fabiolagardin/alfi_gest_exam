import 'package:alfi_gest/helpers/date_time.dart';
import 'package:alfi_gest/helpers/result.dart';
import 'package:alfi_gest/helpers/string_helper.dart';
import 'package:alfi_gest/models/enums.dart';
import 'package:alfi_gest/models/member.dart';
import 'package:alfi_gest/providers/auth/user_data_provider.dart';
import 'package:alfi_gest/providers/clubs/clubs_provder.dart';
import 'package:alfi_gest/providers/member/create_member_provider.dart';
import 'package:alfi_gest/screens/main_screen.dart';
import 'package:alfi_gest/services/member_service.dart';

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
    final clubsAsyncValue = ref.watch(clubsProvider);
    final isReadyFor = ref.watch(isMemberReadyFor);
    final isLoading = ref.watch(isLoadingProvider);
    final isMemberUpdate = ref.watch(isMemberDetailsUpdatePageProvider);

    // Update the pronController and docTypeController text based on the selected pronoun
    pronController.text = displayStringForPronoun(formState.pronoun);
    docTypeController.text =
        displayStringForTypeDocument(formState.documentType);

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
          child: TextButton(
            onPressed: () {
              ref.read(isMemberPageProvider.notifier).state = true;
              ref.read(isMemberDetailsUpdatePageProvider.notifier).state =
                  false;
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
            child: isLoadingProvider == true
                ? const CircularProgressIndicator()
                : isReadyFor || !isLoading
                    ? TextButton(
                        onPressed: () async {
                          //Scafolod
                          var sm = ScaffoldMessenger.of(context);
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
                            idClub: formState.idClub,
                            haveCardARCI: formState.haveCardARCI,
                            memberSince: DateTime.now(),
                            creationDate: DateTime.now(),
                            userCreation: "",
                            updateDate: DateTime.now(),
                            updateUser: "",
                            dateLastRenewal: DateTime.now(),
                            expirationDate: formState.expirationDate,
                            profileImageFile: formState.profileImageFile,
                            replaceCardMotivation:
                                formState.replaceCardMotivation,
                            isSuspended: formState.isSuspended,
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

                            member.userCreation = user.value!.uid;
                            member.updateUser = user.value!.uid;

                            final result = isMemberUpdate
                                ? await MemberService()
                                    .updateMember(memberId!, member)
                                : await MemberService()
                                    .createMember(memberId!, member);
                            final setRole = await MemberService()
                                .setRoleMember(memberId, Role.socia);
                            if (!mounted) {
                              return;
                            }
                            // Gestisci il risultato
                            if (result.valid) {
                              ref.read(isLoadingProvider.notifier).state =
                                  false;
                              ref.read(isMemberPageProvider.notifier).state =
                                  !isMemberPage;
                              if (isMemberUpdate)
                                ref
                                    .read(isMemberDetailsUpdatePageProvider
                                        .notifier)
                                    .state = false;
                            } else {
                              // Errore: mostra un messaggio di errore
                              final snackBar = SnackBar(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  content: Text(result.error ??
                                      'Si è verificato un errore sconosciuto.'),
                                  behavior: SnackBarBehavior.floating);
                              sm.showSnackBar(snackBar);
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
                                        .secondary
                                        .withOpacity(0.5),
                              ),
                        ),
                      )
                    : TextButton(
                        onPressed: () {},
                        child: Text(
                          "Salva",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                color: Theme.of(context).colorScheme.secondary,
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
                },
                child: DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      TabBar(
                        controller: _tabController,
                        tabs: const [
                          Tab(text: 'Anagrafica'),
                          Tab(text: 'Contatti'),
                          Tab(text: 'Circolo'),
                        ],
                        labelColor: Theme.of(context).colorScheme.primary,
                        unselectedLabelColor:
                            Theme.of(context).colorScheme.onSurfaceVariant,
                        indicatorColor: Theme.of(context).colorScheme.primary,
                        onTap: (index) {
                          // Impedisce il cambio di tab se la validazione fallisce
                          if (_formKey.currentState!.validate()) {
                            _pageController.jumpToPage(index);
                          } else {
                            // Forzare il TabController a rimanere sul tab corrente
                            _tabController
                                .animateTo(_tabController.previousIndex);
                          }
                        },
                      ),
                      Expanded(
                        child: PageView(
                          controller: _pageController,
                          physics: NeverScrollableScrollPhysics(),
                          onPageChanged: (index) {
                            setState(() {
                              _tabController.index = index;
                            });
                          },
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
                                          labelStyle: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary
                                                .withOpacity(1.0),
                                            fontWeight: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.fontWeight,
                                            fontSize: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.fontSize,
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
                                      initialValue: DateFormat('dd-MM-yyyy')
                                          .format(formState.birthDate),

                                      decoration: InputDecoration(
                                        labelText: 'Data di nascita *',
                                        fillColor: Theme.of(context)
                                            .colorScheme
                                            .surfaceVariant,
                                        filled: true,
                                        border: InputBorder.none,
                                        suffixIcon:
                                            const Icon(Icons.calendar_today),
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
                                          labelStyle: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary
                                                .withOpacity(1.0),
                                            fontWeight: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.fontWeight,
                                            fontSize: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.fontSize,
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
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 16),
                              child: Column(
                                children: [
                                  clubsAsyncValue.when(
                                    data: (clubs) =>
                                        DropdownButtonFormField<String>(
                                      value: formState.idClub != null &&
                                              clubs.any((club) =>
                                                  club.idClub ==
                                                  formState.idClub)
                                          ? formState.idClub
                                          : null, // Assicurati che il valore corrente esista nell'elenco, altrimenti imposta su null
                                      onChanged: (String? newValue) {
                                        ref
                                            .read(createMemberFormProvider
                                                .notifier)
                                            .updateIdClub(newValue ?? '');
                                      },
                                      items: clubs
                                          .map<DropdownMenuItem<String>>(
                                              (club) {
                                        return DropdownMenuItem<String>(
                                          value: club.idClub,
                                          child: Text(club.nameClub),
                                        );
                                      }).toList(),
                                      decoration: InputDecoration(
                                        labelText: 'Circolo',
                                        fillColor: Theme.of(context)
                                            .colorScheme
                                            .surfaceVariant,
                                        filled: true,
                                        border: InputBorder.none,
                                      ),
                                    ),
                                    loading: () =>
                                        const CircularProgressIndicator(),
                                    error: (e, _) => Text('Error: $e'),
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
                                    ),
                                    readOnly: isMemberUpdate ? true : false,
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
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    onChanged: (value) {
                                      ref
                                          .read(
                                              createMemberFormProvider.notifier)
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Switch(
                                        value: formState.haveCardARCI,
                                        onChanged: (bool haveCardARCI) {
                                          ref
                                              .read(createMemberFormProvider
                                                  .notifier)
                                              .updateHaveCardARCI(haveCardARCI);
                                        },
                                      ),
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
