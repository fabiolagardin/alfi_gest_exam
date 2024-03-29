import 'package:alfi_gest/models/club.dart';
import 'package:alfi_gest/models/enums.dart';
import 'package:alfi_gest/models/member.dart';

class StringHelper {
  static String splitOnCaps(String input) {
    var splited =
        input.replaceAllMapped(RegExp(r'[A-Z]'), (Match m) => ' ${m[0]!}');

    return toTitleCase(splited);
  }

  static String toTitleCase(String text) {
    if (text.length <= 1) {
      return text.toUpperCase();
    }

    // Divide la stringa in parole
    var words = text.split(' ');

    // Converte la prima lettera di ogni parola in maiuscolo
    var capitalized = words.map((word) {
      var first = word.substring(0, 1).toUpperCase();
      var rest = word.substring(1);
      return '$first$rest';
    });

    // Unisce le parole in una stringa
    return capitalized.join(' ');
  }
}

// Funzione helper per ottenere la stringa visualizzata per ogni valore di Pronoun
String displayStringForPronoun(Pronoun pronoun) {
  switch (pronoun) {
    case Pronoun.lui:
      return "Lui";
    case Pronoun.lei:
      return "Lei";
    case Pronoun.luiLei:
      return "Lui/Lei";
    default:
      return "";
  }
}

// Funzione helper per ottenere la stringa visualizzata per ogni valore di TypeDocument
String displayStringForTypeDocument(TypeDocument typeDocument) {
  switch (typeDocument) {
    case TypeDocument.identityCard:
      return "Carta d'identità";
    case TypeDocument.driversLicense:
      return "Patente";
    case TypeDocument.passport:
      return "Passaporto";
    default:
      return "";
  }
}

// Funzione helper per ottenere la stringa visualizzata per ogni valore di Role
String formatRole(Role role) {
  switch (role) {
    case Role.nonAssegnato:
      return "";
    case Role.amministratore:
      return "Amministratore";
    case Role.segretariaNazionale:
      return "Segretaria Nazionale";
    case Role.responsabileCircolo:
      return "Responsabile Circolo";
    case Role.socia:
      return "Socia*";
    default:
      return "";
  }
}

Role parseRole(String role) {
  switch (role) {
    case "Amministratore":
      return Role.amministratore;
    case "Segretaria Nazionale":
      return Role.segretariaNazionale;
    case "Responsabile Circolo":
      return Role.responsabileCircolo;
    case "Socia":
      return Role.socia;
    default:
      return Role.nonAssegnato;
  }
}

// Funzione helper per ottenere la stringa visualizzata per ogni valore di replaceCardMotivation
String displayStringForReplaceCardMotivation(ReplaceCardMotivation motivation) {
  switch (motivation) {
    case ReplaceCardMotivation.smarrimento:
      return "Smarrimento";
    case ReplaceCardMotivation.rottura:
      return "Rottura";
    default:
      return "";
  }
}

String formatMemberName(Member member) {
  return member.givenName.isEmpty
      ? "${member.legalName} ${member.lastName}"
      : "${member.givenName} ${member.lastName}";
}

String getClubName(Member member, List<Club> clubs) {
  for (Club club in clubs) {
    if (club.id == member.idClub) {
      return club.nameClub;
    }
  }
  return 'Senza Circolo';
}

// Funzione helper per ottenere la stringa visualizzata per ogni valore di BookType
String displayStringForBookType(BookType bookType) {
  switch (bookType) {
    case BookType.libroSocie:
      return "Libro socie*";
    case BookType.libroSocieVolontarie:
      return "Libro socie* volontarie";
    case BookType.libroSocieLavoratrici:
      return "Libro socie* lavoratrici";
    default:
      return "";
  }
}
