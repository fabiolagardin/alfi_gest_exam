class DateHelper {
  static DateTime calculateExpirationDate() {
    DateTime now = DateTime.now();
    DateTime expirationDate;

    if (now.month > 10 || (now.month == 10 && now.day > 1)) {
      // Se oggi è dopo il 1° ottobre, imposta la data di scadenza al 1° ottobre dell'anno successivo
      expirationDate = DateTime(now.year + 1, 10, 1);
    } else {
      // Se oggi è il 1° ottobre o prima, imposta la data di scadenza al 1° ottobre dello stesso anno
      expirationDate = DateTime(now.year, 10, 1);
    }

    return expirationDate;
  }

  // funzione per calcolare se è maggiorenne
  static bool isAdult(DateTime birthDate) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime adultDate = DateTime(today.year - 18, today.month, today.day);
    return birthDate.isBefore(adultDate) ||
        birthDate.isAtSameMomentAs(adultDate);
  }
}
