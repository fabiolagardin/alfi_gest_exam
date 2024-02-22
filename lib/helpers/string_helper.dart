import 'package:alfi_gest/models/enums.dart';

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
      return "Non assegnato";
    case Role.amministratore:
      return "Amministratore";
    case Role.segretariaNazionale:
      return "Segretaria Nazionale";
    case Role.responsabileCircolo:
      return "Responsabile Circolo";
    case Role.socia:
      return "Socia";
    default:
      return "";
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
