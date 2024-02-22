enum TypeDocument {
  nonAssegnato,
  passport,
  identityCard,
  driversLicense,
}

final documentNames = {
  TypeDocument.passport: 'Passaporto',
  TypeDocument.identityCard: 'Carta d\'identità',
  TypeDocument.driversLicense: 'Patente di guida',
};

// come usarlo con in nomi tradotti
//  var document = TypeDocument.passport;
//   print('Il documento è: ${documentNames[document]}');

enum Role {
  nonAssegnato,
  amministratore,
  segretariaNazionale,
  responsabileCircolo,
  socia,
}

enum TypeSendNotifications {
  email,
  notifica,
  emailENotifica,
}

enum Pronoun {
  nonAssegnato,
  lui,
  lei,
  luiLei,
}

enum ReplaceCardMotivation {
  nonAssegnato,
  smarrimento,
  rottura,
}
