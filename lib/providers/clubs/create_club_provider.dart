import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateClubFormState {
  String idClub;
  String nameClub;
  String city;
  String address;
  String email;
  String idMemberManager; // FK Responsabile
  String idClubSecretary; // FK Segretaria*
  bool isSuspended;
  bool isClosed;
  DateTime? creationDate;
  String userCreation;
  DateTime? updateDate;
  String updateUser;
  String? logoPath;
  String idClubPayment;
  String nameBank;
  String iban;
  String bic;
  String? nameAccount;
  String? paypal;
  bool notifyExpiringCard = false;
  bool notifyExpiredMembershipCards = false;
  bool notifyNewMemberRegistration = false;
  bool notifyRenewalMember = false;

  CreateClubFormState({
    this.idClub = '',
    this.nameClub = '',
    this.city = '',
    this.address = '',
    this.email = '',
    this.idMemberManager = '',
    this.idClubSecretary = '',
    this.isSuspended = true,
    this.isClosed = false,
    this.creationDate,
    this.userCreation = '',
    this.updateDate,
    this.updateUser = '',
    this.logoPath,
    this.idClubPayment = '',
    this.nameBank = '',
    this.iban = '',
    this.bic = '',
    this.nameAccount = '',
    this.paypal = '',
    this.notifyExpiringCard = false,
    this.notifyExpiredMembershipCards = false,
    this.notifyNewMemberRegistration = false,
    this.notifyRenewalMember = false,
  });

  void reset() {
    idClub = "";
    nameClub = "";
    city = "";
    address = "";
    email = "";
    idMemberManager = "";
    isSuspended = false;
    isClosed = false;
    creationDate = DateTime.now();
    userCreation = "";
    updateDate = DateTime.now();
    updateUser = "";
    logoPath = null;
    idClubPayment = "";
    nameBank = "";
    iban = "";
    bic = "";
    nameAccount = "";
    paypal = "";
    notifyExpiringCard = false;
    notifyExpiredMembershipCards = false;
    notifyNewMemberRegistration = false;
    notifyRenewalMember = false;
  }

  CreateClubFormState copyWith({
    String? idClub,
    String? nameClub,
    String? city,
    String? address,
    String? email,
    String? idMemberManager,
    String? idClubSecretary,
    bool? isSuspended,
    bool? isClosed,
    DateTime? creationDate,
    String? userCreation,
    DateTime? updateDate,
    String? updateUser,
    String? logoPath,
    String? idClubPayment,
    String? nameBank,
    String? iban,
    String? bic,
    String? nameAccount,
    String? paypal,
    bool? notifyExpiringCard,
    bool? notifyExpiredMembershipCards,
    bool? notifyNewMemberRegistration,
    bool? notifyRenewalMember,
  }) {
    return CreateClubFormState(
      idClub: idClub ?? this.idClub,
      nameClub: nameClub ?? this.nameClub,
      city: city ?? this.city,
      address: address ?? this.address,
      email: email ?? this.email,
      idMemberManager: idMemberManager ?? this.idMemberManager,
      idClubSecretary: idClubSecretary ?? this.idClubSecretary,
      isSuspended: isSuspended ?? this.isSuspended,
      isClosed: isClosed ?? this.isClosed,
      creationDate: creationDate ?? this.creationDate,
      userCreation: userCreation ?? this.userCreation,
      updateDate: updateDate ?? this.updateDate,
      updateUser: updateUser ?? this.updateUser,
      logoPath: logoPath ?? this.logoPath,
      idClubPayment: idClubPayment ?? this.idClubPayment,
      nameBank: nameBank ?? this.nameBank,
      iban: iban ?? this.iban,
      bic: bic ?? this.bic,
      nameAccount: nameAccount ?? this.nameAccount,
      paypal: paypal ?? this.paypal,
      notifyExpiringCard: notifyExpiringCard ?? this.notifyExpiringCard,
      notifyExpiredMembershipCards:
          notifyExpiredMembershipCards ?? this.notifyExpiredMembershipCards,
      notifyNewMemberRegistration:
          notifyNewMemberRegistration ?? this.notifyNewMemberRegistration,
      notifyRenewalMember: notifyRenewalMember ?? this.notifyRenewalMember,
    );
  }
}

class CreateClubFormStateNotifier extends StateNotifier<CreateClubFormState> {
  CreateClubFormStateNotifier() : super(CreateClubFormState());

  void setIdClub(String idClub) {
    state = state.copyWith(idClub: idClub);
  }

  void setNameClub(String nameClub) {
    state = state.copyWith(nameClub: nameClub);
  }

  void setCity(String city) {
    state = state.copyWith(city: city);
  }

  void setAddress(String address) {
    state = state.copyWith(address: address);
  }

  void setEmail(String email) {
    state = state.copyWith(email: email);
  }

  void setIdMemberManager(String idMemberManager) {
    state = state.copyWith(idMemberManager: idMemberManager);
  }

  void setIdClubSecretary(String idClubSecretary) {
    state = state.copyWith(idClubSecretary: idClubSecretary);
  }

  void setIsSuspended(bool isSuspended) {
    state = state.copyWith(isSuspended: isSuspended);
  }

  void setIsClosed(bool isClosed) {
    state = state.copyWith(isClosed: isClosed);
  }

  void setCreationDate(DateTime creationDate) {
    state = state.copyWith(creationDate: creationDate);
  }

  void setUserCreation(String userCreation) {
    state = state.copyWith(userCreation: userCreation);
  }

  void setUpdateDate(DateTime updateDate) {
    state = state.copyWith(updateDate: updateDate);
  }

  void setUpdateUser(String updateUser) {
    state = state.copyWith(updateUser: updateUser);
  }

  void setProfileImageFile(String logoPath) {
    state = state.copyWith(logoPath: logoPath);
  }

  void setIdClubPayment(String idClubPayment) {
    state = state.copyWith(idClubPayment: idClubPayment);
  }

  void setNameBank(String nameBank) {
    state = state.copyWith(nameBank: nameBank);
  }

  void setIban(String iban) {
    state = state.copyWith(iban: iban);
  }

  void setBic(String bic) {
    state = state.copyWith(bic: bic);
  }

  void setNameAccount(String nameAccount) {
    state = state.copyWith(nameAccount: nameAccount);
  }

  void setPaypal(String paypal) {
    state = state.copyWith(paypal: paypal);
  }

  void setnotifyExpiringCard(bool notifyExpiringCard) {
    state = state.copyWith(notifyExpiringCard: notifyExpiringCard);
  }

  void setnotifyExpiredMembershipCards(bool notifyExpiredMembershipCards) {
    state = state.copyWith(
        notifyExpiredMembershipCards: notifyExpiredMembershipCards);
  }

  void setnotifyNewMemberRegistration(bool notifyNewMemberRegistration) {
    state = state.copyWith(
        notifyNewMemberRegistration: notifyNewMemberRegistration);
  }

  void setnotifyRenewalMember(bool notifyRenewalMember) {
    state = state.copyWith(notifyRenewalMember: notifyRenewalMember);
  }
}

final createClubFormProvider =
    StateNotifierProvider<CreateClubFormStateNotifier, CreateClubFormState>(
        (ref) => CreateClubFormStateNotifier());
