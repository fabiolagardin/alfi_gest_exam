import 'dart:io';

import 'package:alfi_gest/helpers/result.dart';
import 'package:alfi_gest/helpers/validate_data.dart';
import 'package:alfi_gest/models/enums.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class Member {
  Member({
    required this.memberId,
    required this.legalName,
    required this.givenName,
    required this.lastName,
    required this.pronoun,
    required this.address,
    required this.birthDate,
    required this.taxIdCode,
    required this.documentType,
    required this.documentNumber,
    required this.telephone,
    required this.email,
    required this.consentWhatsApp,
    required this.consentNewsletter,
    required this.workingPartner,
    required this.volunteerMember,
    required this.numberCard,
    required this.idClub,
    required this.haveCardARCI,
    required this.memberSince,
    required this.creationDate,
    required this.userCreation,
    required this.updateDate,
    required this.updateUser,
    required this.dateLastRenewal,
    required this.expirationDate,
    required this.profileImageFile,
    required this.replaceCardMotivation,
    required this.isSuspended,
  });

  String memberId;
  final String legalName;
  final String givenName;
  final String lastName;
  final Pronoun pronoun;
  final String address;
  final DateTime birthDate;
  final String taxIdCode;
  final TypeDocument documentType;
  final String documentNumber;
  final String telephone;
  final String email;
  final bool consentWhatsApp;
  final bool consentNewsletter;
  final bool workingPartner;
  final bool volunteerMember;
  final String numberCard;
  final String idClub;
  final bool haveCardARCI;
  final DateTime memberSince;
  final DateTime creationDate;
  String userCreation;
  final DateTime updateDate;
  String updateUser;
  final DateTime dateLastRenewal;
  final DateTime expirationDate;
  final File? profileImageFile;
  final ReplaceCardMotivation replaceCardMotivation;
  final bool isSuspended;

  Map<String, dynamic> toMap() {
    return {
      'memberId': memberId,
      'legalName': legalName,
      'givenName': givenName,
      'lastName': lastName,
      'pronoun': pronoun.index,
      'address': address,
      'birthDate': birthDate.toIso8601String(),
      'taxIdCode': taxIdCode,
      'documentType': documentType.index,
      'documentNumber': documentNumber,
      'telephone': telephone,
      'email': email,
      'consentWhatsApp': consentWhatsApp,
      'consentNewsletter': consentNewsletter,
      'workingPartner': workingPartner,
      'volunteerMember': volunteerMember,
      'numberCard': numberCard,
      'idClub': idClub,
      'haveCardARCI': haveCardARCI,
      'memberSince': memberSince.toIso8601String(),
      'creationDate': creationDate.toIso8601String(),
      'userCreation': userCreation,
      'updateDate': updateDate.toIso8601String(),
      'updateUser': updateUser,
      'dateLastRenewal': dateLastRenewal.toIso8601String(),
      'expirationDate': expirationDate.toIso8601String(),
      'profileImage': profileImageFile?.path ?? "",
      'replaceCardMotivation': replaceCardMotivation.index,
      'isSuspended': isSuspended,
    };
  }

  factory Member.fromMap(String id, Map<String, dynamic> map) {
    return Member(
      memberId: id,
      legalName: map['legalName'] as String,
      givenName: map['givenName'] as String,
      lastName: map['lastName'] as String,
      pronoun: Pronoun.values.elementAt(map['pronoun'] as int),
      address: map['address'] as String,
      birthDate: DateTime.parse(map['birthDate'] as String),
      taxIdCode: map['taxIdCode'] as String,
      documentType: TypeDocument.values.elementAt(map['documentType'] as int),
      documentNumber: map['documentNumber'] as String,
      telephone: map['telephone'] as String,
      email: map['email'] as String,
      consentWhatsApp: map['consentWhatsApp'] as bool,
      consentNewsletter: map['consentNewsletter'] as bool,
      workingPartner: map['workingPartner'] as bool,
      volunteerMember: map['volunteerMember'] as bool,
      numberCard: map['numberCard'] as String,
      idClub: map['idClub'] as String,
      haveCardARCI: map['haveCardARCI'] as bool,
      memberSince: DateTime.parse(map['memberSince'] as String),
      creationDate: DateTime.parse(map['creationDate'] as String),
      userCreation: map['userCreation'] as String,
      updateDate: DateTime.parse(map['updateDate'] as String),
      updateUser: map['updateUser'] as String,
      dateLastRenewal: DateTime.parse(map['dateLastRenewal'] as String),
      expirationDate: DateTime.parse(map['expirationDate'] as String),
      profileImageFile: (map['profileImage'] != null)
          ? File(map['profileImage'] as String)
          : null,
      replaceCardMotivation: ReplaceCardMotivation.values
          .elementAt(map['replaceCardMotivation'] as int),
      isSuspended: map['isSuspended'] as bool,
    );
  }

  Result<Member> validate(Member member) {
    List<String> errs = [];

    if (member.legalName.isEmpty) {
      errs.add("Nome legale obligatorio");
    }

    if (member.lastName.isEmpty) {
      errs.add("Cognome obligatorio");
    }

    if (member.address.isEmpty) {
      errs.add("Indirizzo obligatorio");
    }
    final currentYear = DateTime.now().year;
    final birthYear = member.birthDate.year;
    final age = currentYear - birthYear;

    if (age < 18) {
      errs.add('Membro non idoneo: età inferiore a 18 anni');
    }

    // if (member.taxIdCode.isEmpty) {
    //   errs.add("Codice Fiscale obligatorio");
    // }

    if (member.documentType == TypeDocument.nonAssegnato) {
      errs.add("Tipo di documento obligatorio");
    }

    if (member.documentNumber.isEmpty) {
      errs.add("Numero documento obligatorio");
    }

    // if (member.telephone.isEmpty) {
    //   errs.add("Numero di Telefono obligatorio");
    // }

    if (member.email.isEmpty) {
      errs.add("Email obligatoria");
    }

    // Check email validity
    if (!RegExp(r'^.+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(member.email)) {
      errs.add("Inserire un email valida");
    }

    // Check codice fiscale validity
    if (!isValidCodiceFiscale(member.taxIdCode)) {
      errs.add("Inserire un codice fiscale valido");
    }

    return errs.isNotEmpty
        ? Result(valid: false, errors: errs, data: member)
        : Result(valid: true, data: member);
  }
}
