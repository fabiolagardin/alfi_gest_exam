import 'dart:io';
import 'package:alfi_gest/helpers/date_time.dart';
import 'package:alfi_gest/models/enums.dart';
import 'package:alfi_gest/models/member.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alfi_gest/models/club.dart';
import 'package:alfi_gest/services/club_service.dart';

final isLoadingProvider = StateProvider<bool>((ref) => false);

class CreateMemberFormState {
  String memberId;
  String legalName;
  String givenName;
  String lastName;
  Pronoun pronoun;
  String address;
  DateTime birthDate;
  String taxIdCode;
  TypeDocument documentType;
  String documentNumber;
  String telephone;
  String email;
  bool consentWhatsApp;
  bool consentNewsletter;
  bool workingPartner;
  bool volunteerMember;
  String numberCard;
  String idClub;
  bool haveCardARCI;
  DateTime creationDate;
  String userCreation;
  DateTime updateDate;
  String updateUser;
  DateTime dateLastRenewal;
  DateTime expirationDate;
  File? profileImageFile;
  bool isSuspended;
  ReplaceCardMotivation replaceCardMotivation;
  String creditCard;
  String creditCardName;
  DateTime? creditCardExpirationDate;
  String? creditCardCvvCode;
  String paypalEmail;

  CreateMemberFormState({
    this.memberId = '',
    this.legalName = '',
    this.givenName = '',
    this.lastName = '',
    this.pronoun = Pronoun.nonAssegnato,
    this.address = '',
    required this.birthDate,
    this.taxIdCode = '',
    this.documentType = TypeDocument.nonAssegnato,
    this.documentNumber = '',
    this.telephone = '',
    this.email = '',
    this.consentWhatsApp = false,
    this.consentNewsletter = false,
    this.workingPartner = false,
    this.volunteerMember = false,
    this.numberCard = '',
    this.idClub = '',
    this.haveCardARCI = false,
    required this.creationDate,
    this.userCreation = '',
    required this.updateDate,
    this.updateUser = '',
    required this.dateLastRenewal,
    required this.expirationDate,
    this.profileImageFile,
    this.isSuspended = false,
    this.replaceCardMotivation = ReplaceCardMotivation.nonAssegnato,
    this.creditCard = '',
    this.creditCardName = '',
    this.creditCardExpirationDate,
    this.creditCardCvvCode,
    this.paypalEmail = '',
  });

  void reset() {
    address = '';
    birthDate = DateTime.now();
    consentNewsletter = false;
    consentWhatsApp = false;
    creationDate = DateTime.now();
    creditCard = '';
    creditCardCvvCode = '';
    creditCardExpirationDate = null;
    creditCardName = '';
    dateLastRenewal = DateTime.now();
    documentNumber = '';
    documentType = TypeDocument.nonAssegnato;
    email = '';
    expirationDate = DateHelper.calculateExpirationDate();
    givenName = '';
    haveCardARCI = false;
    idClub = '';
    isSuspended = false;
    replaceCardMotivation = ReplaceCardMotivation.nonAssegnato;
    lastName = '';
    legalName = '';
    memberId = '';
    numberCard = '';
    profileImageFile = null;
    pronoun = Pronoun.nonAssegnato;
    taxIdCode = '';
    telephone = '';
    updateDate = DateTime.now();
    updateUser = '';
    volunteerMember = false;
    workingPartner = false;
  }

  CreateMemberFormState copyWith({
    String? memberId,
    String? legalName,
    String? givenName,
    String? lastName,
    Pronoun? pronoun,
    String? address,
    DateTime? birthDate,
    String? taxIdCode,
    TypeDocument? documentType,
    String? documentNumber,
    String? telephone,
    String? email,
    bool? consentWhatsApp,
    bool? consentNewsletter,
    bool? workingPartner,
    bool? volunteerMember,
    String? numberCard,
    String? idClub,
    bool? haveCardARCI,
    DateTime? creationDate,
    String? userCreation,
    DateTime? updateDate,
    String? updateUser,
    DateTime? dateLastRenewal,
    DateTime? expirationDate,
    File? profileImageFile,
    bool? isSuspended,
    ReplaceCardMotivation? replaceCardMotivation,
    String? creditCard,
    String? creditCardName,
    DateTime? creditCardExpirationDate,
    String? creditCardCvvCode,
    String? paypalEmail,
  }) {
    return CreateMemberFormState(
      memberId: memberId ?? this.memberId,
      legalName: legalName ?? this.legalName,
      givenName: givenName ?? this.givenName,
      lastName: lastName ?? this.lastName,
      pronoun: pronoun ?? this.pronoun,
      address: address ?? this.address,
      birthDate: birthDate ?? this.birthDate,
      taxIdCode: taxIdCode ?? this.taxIdCode,
      documentType: documentType ?? this.documentType,
      documentNumber: documentNumber ?? this.documentNumber,
      telephone: telephone ?? this.telephone,
      email: email ?? this.email,
      consentWhatsApp: consentWhatsApp ?? this.consentWhatsApp,
      consentNewsletter: consentNewsletter ?? this.consentNewsletter,
      workingPartner: workingPartner ?? this.workingPartner,
      volunteerMember: volunteerMember ?? this.workingPartner,
      numberCard: numberCard ?? this.numberCard,
      idClub: idClub ?? this.idClub,
      haveCardARCI: haveCardARCI ?? this.haveCardARCI,
      creationDate: creationDate ?? DateTime.now(),
      userCreation: userCreation ?? this.userCreation,
      updateDate: updateDate ?? DateTime.now(),
      updateUser: updateUser ?? this.updateUser,
      dateLastRenewal: dateLastRenewal ?? this.dateLastRenewal,
      expirationDate:
          expirationDate ?? DateTime.now().add(const Duration(days: 365)),
      isSuspended: isSuspended ?? this.isSuspended,
      replaceCardMotivation:
          replaceCardMotivation ?? this.replaceCardMotivation,
      profileImageFile: profileImageFile ?? this.profileImageFile,
      creditCard: creditCard ?? this.creditCard,
      creditCardCvvCode: creditCardCvvCode ?? this.creditCardCvvCode,
      creditCardExpirationDate: creditCardExpirationDate ?? DateTime.now(),
      creditCardName: creditCardName ?? this.creditCardName,
      paypalEmail: paypalEmail ?? this.paypalEmail,
    );
  }
}

class CreateMemberFormStateNotifier
    extends StateNotifier<CreateMemberFormState> {
  final ClubService _clubService;
  CreateMemberFormStateNotifier(this._clubService)
      : super(CreateMemberFormState(
            birthDate: DateTime.now(),
            creationDate: DateTime.now(),
            updateDate: DateTime.now(),
            dateLastRenewal: DateTime.now(),
            expirationDate: DateTime.now().add(const Duration(days: 365))));
  void updateMemberId(String value) => state = state.copyWith(memberId: value);
  void updateLegalName(String value) =>
      state = state.copyWith(legalName: value);
  void updateGivenName(String value) =>
      state = state.copyWith(givenName: value);
  void updateLastName(String value) => state = state.copyWith(lastName: value);
  void updatePronoun(Pronoun value) => state = state.copyWith(pronoun: value);
  void updateAddress(String value) => state = state.copyWith(address: value);
  void updateBirthDate(DateTime value) =>
      state = state.copyWith(birthDate: value);
  void updateTaxIdCode(String value) =>
      state = state.copyWith(taxIdCode: value);
  void updateDocumentType(TypeDocument value) =>
      state = state.copyWith(documentType: value);
  void updateDocumentNumber(String value) =>
      state = state.copyWith(documentNumber: value);
  void updateTelephone(String value) =>
      state = state.copyWith(telephone: value);
  void updateEmail(String value) => state = state.copyWith(email: value);
  void updateConsentWhatsApp(bool consentWhatsAppValue) =>
      state = state.copyWith(consentWhatsApp: consentWhatsAppValue);
  void updateConsentNewsletter(bool value) =>
      state = state.copyWith(consentNewsletter: value);
  void updateWorkingPartner(bool value) =>
      state = state.copyWith(workingPartner: value);
  void updateVolunteerMember(bool value) =>
      state = state.copyWith(volunteerMember: value);
  void updateNumberCard(String value) =>
      state = state.copyWith(numberCard: value);
  void updateIdClub(String value) => state = state.copyWith(idClub: value);
  void updateHaveCardARCI(bool value) =>
      state = state.copyWith(haveCardARCI: value);
  void updateCreationDate(DateTime value) =>
      state = state.copyWith(creationDate: value);
  void updateUserCreation(String value) =>
      state = state.copyWith(userCreation: value);
  void updateUpdateDate(DateTime value) =>
      state = state.copyWith(updateDate: value);
  void updateUpdateUser(String value) =>
      state = state.copyWith(updateUser: value);
  void updateDateLastRenewal(DateTime value) =>
      state = state.copyWith(dateLastRenewal: value);
  void updateExpirationDate(DateTime value) =>
      state = state.copyWith(expirationDate: value);
  void updateIsSuspended(bool value) =>
      state = state.copyWith(isSuspended: value);
  void updateReplaceCardMotivation(ReplaceCardMotivation value) =>
      state = state.copyWith(replaceCardMotivation: value);
  void updateProfileImageFile(File? file) =>
      state = state.copyWith(profileImageFile: file);
  void updateCreditCard(String value) =>
      state = state.copyWith(creditCard: value);
  void updateCreditCardCvvCode(String value) =>
      state = state.copyWith(creditCardCvvCode: value);
  void updateCreditCardExpirationDate(DateTime value) =>
      state = state.copyWith(creditCardExpirationDate: value);
  void updateCreditCardName(String value) =>
      state = state.copyWith(creditCardName: value);
  void updatePaypalEmail(String value) =>
      state = state.copyWith(paypalEmail: value);

  Future<List<Club>> getClubs() async {
    final result = await _clubService.getClubs();
    if (result.valid && result.data != null) {
      return result.data!;
    } else {
      // Handle the error or return an empty list
      // You might want to do something with the error like logging or displaying a message
      return [];
    }
  }
}

final createMemberFormProvider =
    StateNotifierProvider<CreateMemberFormStateNotifier, CreateMemberFormState>(
  (ref) {
    // Create an instance of ClubService
    final clubService = ClubService();

    // Inject the ClubService instance into the CreateMemberFormStateNotifier
    return CreateMemberFormStateNotifier(clubService);
  },
);
