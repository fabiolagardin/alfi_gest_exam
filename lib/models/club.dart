import 'package:alfi_gest/helpers/result.dart';

import 'dart:io';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class Club {
  Club({
    required this.idClub,
    required this.nameClub,
    required this.city,
    required this.address,
    required this.email,
    required this.idMemberManager,
    required this.isSuspend,
    required this.creationDate,
    required this.userCreation,
    required this.updateDate,
    required this.updateUser,
    required this.profileImageFile,
  });

  final String idClub;
  final String nameClub;
  final String city;
  final String address;
  final String email;
  final String idMemberManager; // FK Responsabile
  final bool isSuspend;
  final DateTime creationDate;
  final String userCreation;
  final DateTime updateDate;
  final String updateUser;
  final File? profileImageFile;

  Map<String, dynamic> toMap() {
    return {
      'idClub': idClub,
      'nameClub': nameClub,
      'city': city,
      'address': address,
      'email': email,
      'idMemberManager': idMemberManager,
      'isSuspend': isSuspend,
      'creationDate': creationDate.millisecondsSinceEpoch,
      'userCreation': userCreation,
      'updateDate': updateDate.millisecondsSinceEpoch,
      'updateUser': updateUser,
      'profileImage': profileImageFile?.path ?? "",
    };
  }

  factory Club.fromMap(String clubId, Map<String, dynamic> map) {
    return Club(
      idClub: clubId,
      nameClub: map['nameClub'] as String,
      city: map['city'] as String,
      address: map['address'] as String,
      email: map['email'] as String,
      idMemberManager: map['idMemberManager'] as String,
      isSuspend: map['isSuspend'] as bool,
      creationDate:
          DateTime.fromMillisecondsSinceEpoch(map['creationDate'] as int),
      userCreation: map['userCreation'] as String,
      updateDate: DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int),
      updateUser: map['updateUser'] as String,
      profileImageFile: (map['profileImage'] != null)
          ? File(map['profileImage'] as String)
          : null,
    );
  }

  Result<Club> validate(Club club) {
    List<String> errs = [];

    if (club.nameClub.isEmpty) {
      errs.add("Nome circolo obligatorio");
    }

    if (club.city.isEmpty) {
      errs.add("Città obligatoria");
    }

    if (club.address.isEmpty) {
      errs.add("Indirizzo obligatorio");
    }
    if (club.email.isEmpty) {
      errs.add("Email obligatoria");
    }

    // Check email validity
    if (!RegExp(r'^.+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(club.email)) {
      errs.add("Inserire un email valida");
    }

    if (club.profileImageFile == null) {
      errs.add("Profilo Immagine obblatorio");
    }

    return errs.isNotEmpty
        ? Result(valid: true, data: club)
        : Result(valid: false, errors: errs, data: club);
  }
}
