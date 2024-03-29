import 'package:alfi_gest/core/result.dart';
import 'package:alfi_gest/models/identifiable.dart';

import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class Club implements Identifiable {
  Club({
    required this.idClub,
    required this.nameClub,
    required this.city,
    required this.address,
    required this.email,
    required this.idMemberManager,
    required this.idClubSecretary,
    required this.isSuspended,
    required this.isClosed,
    required this.creationDate,
    required this.userCreation,
    required this.updateDate,
    required this.updateUser,
    required this.logoPath,
  });

  String idClub;
  final String nameClub;
  final String city;
  final String address;
  final String email;
  final String idMemberManager; // FK Responsabile
  final String idClubSecretary; // FK Segretaria*
  final bool isSuspended;
  final bool isClosed;
  final DateTime creationDate;
  final String userCreation;
  final DateTime updateDate;
  final String updateUser;
  final String? logoPath;
  @override
  dynamic get id => idClub;
  bool get isSuspend => isSuspended;
  bool get isRemoved => isClosed;
  String get title => nameClub;
  String get subTitle => city.isEmpty ? "Città mancante" : city;
  String get foreignKey => idMemberManager;

  Map<String, dynamic> toMap() {
    return {
      'idClub': idClub,
      'nameClub': nameClub,
      'city': city,
      'address': address,
      'email': email,
      'idMemberManager': idMemberManager,
      'idClubSecretary': idClubSecretary,
      'isSuspend': isSuspended,
      'isClosed': isClosed,
      'creationDate': creationDate.millisecondsSinceEpoch,
      'userCreation': userCreation,
      'updateDate': updateDate.millisecondsSinceEpoch,
      'updateUser': updateUser,
      'profileImage': logoPath ?? "",
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
      idClubSecretary: map['idClubSecretary'] as String,
      isSuspended: map['isSuspend'] as bool,
      isClosed: map['isClosed'] as bool,
      creationDate:
          DateTime.fromMillisecondsSinceEpoch(map['creationDate'] as int),
      userCreation: map['userCreation'] as String,
      updateDate: DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int),
      updateUser: map['updateUser'] as String,
      logoPath: (map['profileImage'] as String),
    );
  }

  factory Club.empty() {
    return Club(
      idClub: '',
      nameClub: '',
      city: '',
      address: '',
      email: '',
      idMemberManager: '',
      idClubSecretary: '',
      isSuspended: false,
      isClosed: false,
      creationDate: DateTime.now(),
      userCreation: '',
      updateDate: DateTime.now(),
      updateUser: '',
      logoPath: null,
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

    return errs.isEmpty
        ? Result(valid: true, data: club)
        : Result(valid: false, errors: errs, data: club);
  }
}
