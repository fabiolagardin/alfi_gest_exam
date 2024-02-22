bool isValidCodiceFiscale(String codiceFiscale) {
  // Check the length of the codice fiscale
  if (codiceFiscale.length != 16) {
    return false;
  }

  // Check the characters of the codice fiscale
  for (int i = 0; i < 16; i++) {
    if (!RegExp(r'[A-Z0-9]').hasMatch(codiceFiscale[i])) {
      return false;
    }
  }

  // Check the first character of the codice fiscale
  if (!RegExp(r'[A-Z]').hasMatch(codiceFiscale[0])) {
    return false;
  }

  // Check the last two characters of the codice fiscale
  if (!RegExp(r'[0-9]').hasMatch(codiceFiscale[14]) ||
      !RegExp(r'[A-Z]').hasMatch(codiceFiscale[15])) {
    return false;
  }

  // Convert the first 15 characters of the codice fiscale to a list
  // final carattere = codiceFiscale.substring(0, 15).split('');

  // Calculate the codice fiscale controllo
  // int codiceFiscaleControllo = 0;
  // for (int i = 0; i < 15; i++) {
  //   codiceFiscaleControllo += (i + 1) * carattere[i].codeUnitAt(0);
  // }

  // codiceFiscaleControllo %= 26;

  // String codiceFiscaleControlloString = "";
  // if (codiceFiscaleControllo < 10) {
  //   codiceFiscaleControlloString = "0$codiceFiscaleControllo";
  // } else {
  //   codiceFiscaleControlloString = codiceFiscaleControllo.toString();
  // }

  // Verify the codice fiscale controllo
  // if (codiceFiscale[15] != codiceFiscaleControlloString[0]) {
  //   return false;
  // }

  return true;
}
