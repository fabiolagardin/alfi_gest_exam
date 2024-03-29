import 'package:alfi_gest/helpers/string_helper.dart';
import 'package:alfi_gest/models/club.dart';
import 'package:alfi_gest/models/clubs_payment_data.dart';
import 'package:alfi_gest/models/enums.dart';
import 'package:alfi_gest/providers/auth/user_data_provider.dart';
import 'package:alfi_gest/providers/clubs/club_data_provider.dart';
import 'package:alfi_gest/providers/clubs/create_club_provider.dart';
import 'package:alfi_gest/providers/member/create_member_provider.dart';
import 'package:alfi_gest/providers/member/member_role_provider.dart';
import 'package:alfi_gest/providers/member/members_data_provider.dart';
import 'package:alfi_gest/screens/main_screen.dart';
import 'package:alfi_gest/services/club_service.dart';
import 'package:alfi_gest/widgets/custom_snack_bars.dart';
import 'package:alfi_gest/widgets/image_picker_button.dart';
import 'package:alfi_gest/widgets/members_select.dart';
import 'package:alfi_gest/widgets/tab_bar_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateClubPage extends ConsumerStatefulWidget {
  const CreateClubPage({super.key});
  @override
  _CreateClubPageState createState() => _CreateClubPageState();
}

class _CreateClubPageState extends ConsumerState<CreateClubPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  late TabController _tabController;
  final TextEditingController memberController = TextEditingController();

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

  void updateMemberId(String id) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(memberIdProvider.notifier).state = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(createClubFormProvider);
    final userData = ref.watch(userDataProvider);

    final user = ref.watch(userProvider);
    final isClubUpdate = ref.watch(isClubDetailsUpdatePageProvider);
    final isClubPage = ref.watch(isClubPageProvider);
    final isLoading = ref.watch(isLoadingProvider);
    final isReadyFor = ref.watch(isClubReadyFor);
    final members = ref.watch(filteredMembersProvider);
    final memberRole = ref.watch(memberRoleProvider);
    final logoUrl = ref.watch(clubLogoUrlProvider(formState.idClub)).value;

    final membersOfClub =
        members.where((member) => member.idClub == formState.idClub).toList();

    var matchingMembers = membersOfClub
        .where((member) => member.memberId == formState.idClubSecretary)
        .map((e) => formatMemberName(e));

    memberController.text =
        matchingMembers.isNotEmpty ? matchingMembers.first : '';
    final listTabsLabels = ['Anagrafica', 'Pagamenti', 'Notifiche'];

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0, 18, 0, 0),
          child: Text(
            isClubUpdate ? "Modifica circolo" : "Nuovo circolo",
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
                    ref.read(isClubDetailsPageProvider.notifier).state = true;

                    ref.read(isClubPageProvider.notifier).state = false;

                    ref.read(isMainAppBarProvider.notifier).state = false;
                    ref.read(isClubDetailsUpdatePageProvider.notifier).state =
                        true;
                    // formState.reset();
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
                              CustomSnackBar.showErrorSnackBar(
                                  context: context,
                                  message:
                                      "Si prega di correggere gli errori nel modulo.");
                              return; // Interrompi l'esecuzione se il form non è valido
                            }
                          }

                          // Imposta isLoading su true
                          ref.read(isLoadingProvider.notifier).state = true;

                          // Raccogli i dati dal provider
                          final formState = ref.read(createClubFormProvider);

                          // Crea l'oggetto Club
                          final club = Club(
                            idClub: formState.idClub,
                            address: formState.address,
                            email: formState.email,
                            city: formState.city,
                            idMemberManager:
                                formState.idMemberManager.isNotEmpty
                                    ? formState.idMemberManager
                                    : user.value!.uid,
                            idClubSecretary: formState.idClubSecretary,
                            isClosed: formState.isClosed,
                            nameClub: formState.nameClub,
                            creationDate: DateTime.now(),
                            userCreation: user.value!.uid,
                            updateDate: DateTime.now(),
                            updateUser: user.value!.uid,
                            logoPath: formState.logoPath,
                            isSuspended: formState.isSuspended,
                          );

                          final clubPayment = ClubPayment(
                            idClubPayment: formState.idClub,
                            bic: formState.bic,
                            iban: formState.iban,
                            nameBank: formState.nameBank,
                            nameAccount: formState.nameAccount,
                            payPal: formState.paypal,
                          );

                          // Valida i dati
                          final validationResult = club.validate(club);
                          if (formState.logoPath != null &&
                              formState.logoPath!.isNotEmpty) {
                            var updateLogo = await ClubService().uploadLogoClub(
                                formState.logoPath!, formState.idClub);
                            if (updateLogo.error != null) {
                              CustomSnackBar.showErrorSnackBar(
                                  context: context,
                                  message: updateLogo.error ??
                                      "Errore nel caricamento del logo");

                              ref.read(isLoadingProvider.notifier).state =
                                  false;
                            }
                          }
                          var newIdClub = uuid.v6();
                          if (validationResult.valid) {
                            final result = isClubUpdate
                                ? await ClubService()
                                    .updateClub(club.idClub, club)
                                : await ClubService()
                                    .createClub(newIdClub, club);

                            if (!mounted) {
                              return;
                            }
                            // Gestisci il risultato
                            if (result.valid) {
                              ref.refresh(
                                  clubLogoUrlProvider(formState.idClub));
                              ref.read(isLoadingProvider.notifier).state =
                                  false;
                              ref.read(isMainAppBarProvider.notifier).state =
                                  false;

                              ref.read(isClubPageProvider.notifier).state =
                                  !isClubPage;
                              if (isClubUpdate)
                                ref
                                    .read(isClubDetailsUpdatePageProvider
                                        .notifier)
                                    .state = false;
                              CustomSnackBar.showSuccessSnackBar(
                                  context: context,
                                  message: "Salvataggio avvenuto con successo");
                              ref.read(isLoadingProvider.notifier).state =
                                  false;
                            } else {
                              CustomSnackBar.showErrorSnackBar(
                                  context: context,
                                  message: result.error ??
                                      "Errore durante il salvataggio");
                              ref.read(isLoadingProvider.notifier).state =
                                  false;
                              ref.read(isMainAppBarProvider.notifier).state =
                                  true;
                            }
                          } else {
                            ref.read(isLoadingProvider.notifier).state = false;
                            ref.read(isMainAppBarProvider.notifier).state =
                                true;
                            // Errore durante la registrazione dell'utente

                            CustomSnackBar.showErrorSnackBar(
                                context: context,
                                message: validationResult.errors != null
                                    ? validationResult.errors!.join(' - ')
                                    : 'Si è verificato un errore sconosciuto.');
                          }
                        },
                        child: Text(
                          "Salva",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  color: isClubUpdate
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
                },
                child: DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 17, 12, 31),
                        child: CustomTabBar(
                          tabController: _tabController,
                          tabsLabels: listTabsLabels,
                          formKey: _formKey,
                          onTapTab: (index) {
                            _formKey.currentState!.validate();

                            // se tutti i 3 tab hanno superto la validazione allora ref.read(isMemberReadyFor.notifier).state = true;
                            if (index == 2) {
                              ref.read(isClubReadyFor.notifier).state = true;
                            } else {
                              ref.read(isClubReadyFor.notifier).state = false;
                            }
                            _pageController.jumpToPage(index);
                          },
                        ),
                      ),
                      Expanded(
                          child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          // Primo tab: anagrafica del circolo
                          SingleChildScrollView(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    initialValue: formState.nameClub,
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
                                          .read(createClubFormProvider.notifier)
                                          .setNameClub(value);
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
                                    initialValue: formState.city,
                                    decoration: InputDecoration(
                                      labelText: 'Città *',
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
                                          .read(createClubFormProvider.notifier)
                                          .setCity(value);
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
                                          .read(createClubFormProvider.notifier)
                                          .setAddress(value);
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
                                          .read(createClubFormProvider.notifier)
                                          .setEmail(value);
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
                                  MembersSelectWidget(
                                    memberController: memberController,
                                    members: membersOfClub
                                        .map((m) {
                                          updateMemberId(m.id);
                                          return m;
                                        })
                                        .where((m) => memberRole != Role.socia
                                            // &&
                                            // memberRole != null,
                                            )
                                        .toList(),
                                    idClub: formState.idClub,
                                    label: "Segretaria*",
                                    placeholder: "Seleziona la segretaria*",
                                    onSelected: (m) => updateMemberId(m.id),
                                  ),
                                  const SizedBox(height: 11),
                                  ImagePickerTextField(
                                    labelText: 'Logo',
                                    onImageSelected: (imagePath) {
                                      formState.logoPath = imagePath;
                                    },
                                    imageUrl:
                                        logoUrl != null ? logoUrl.data : null,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Secondo tab: pagamenti
                          SingleChildScrollView(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    initialValue: formState.nameAccount,
                                    decoration: InputDecoration(
                                      labelText: 'Nome Beneficiario *',
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
                                          .read(createClubFormProvider.notifier)
                                          .setNameAccount(value);
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
                                    initialValue: formState.nameBank,
                                    decoration: InputDecoration(
                                      labelText: 'Nome Banca *',
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
                                          .read(createClubFormProvider.notifier)
                                          .setNameBank(value);
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
                                    initialValue: formState.iban,
                                    decoration: InputDecoration(
                                      labelText: 'IBAN *',
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
                                          .read(createClubFormProvider.notifier)
                                          .setIban(value);
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
                                    initialValue: formState.bic,
                                    decoration: InputDecoration(
                                      labelText: 'BIC *',
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
                                          .read(createClubFormProvider.notifier)
                                          .setBic(value);
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
                                    initialValue: formState.bic,
                                    decoration: InputDecoration(
                                      labelText: 'PayPal',
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
                                          .read(createClubFormProvider.notifier)
                                          .setPaypal(value);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Terzo tab: notifiche
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Seleziona le notifiche che vuoi ricevere via e-mail:",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Switch(
                                      value: formState.notifyExpiringCard,
                                      onChanged: (bool value) {
                                        ref
                                            .read(
                                                createClubFormProvider.notifier)
                                            .setnotifyExpiringCard(value);
                                      },
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Tessere in scadenza',
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Switch(
                                      value: formState
                                          .notifyExpiredMembershipCards,
                                      onChanged: (bool value) {
                                        ref
                                            .read(
                                                createClubFormProvider.notifier)
                                            .setnotifyExpiredMembershipCards(
                                                value);
                                      },
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Tessere Scadute',
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Switch(
                                      value:
                                          formState.notifyNewMemberRegistration,
                                      onChanged: (bool value) {
                                        ref
                                            .read(
                                                createClubFormProvider.notifier)
                                            .setnotifyNewMemberRegistration(
                                                value);
                                      },
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Iscrizione nuova socia*',
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Switch(
                                      value: formState.notifyRenewalMember,
                                      onChanged: (bool value) {
                                        ref
                                            .read(
                                                createClubFormProvider.notifier)
                                            .setnotifyRenewalMember(value);
                                      },
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Rinnovo di una socia*',
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
                              ],
                            ),
                          ),
                        ],
                      ))
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
