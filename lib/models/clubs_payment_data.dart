class ClubPayment {
  final String idClubPayment;
  final String nameBank;
  final String iban;
  final String bic;
  final String? nameAccount;
  final String? debitCard;
  final String? payPal;

  const ClubPayment({
    required this.idClubPayment,
    required this.nameBank,
    required this.iban,
    required this.bic,
    this.nameAccount,
    this.debitCard,
    this.payPal,
  });

  Map<String, dynamic> toMap() {
    return {
      'idClubPayment': idClubPayment,
      'nameBank': nameBank,
      'iban': iban,
      'bic': bic,
      'nameAccount': nameAccount,
      'debitCard': debitCard,
      'payPal': payPal,
    };
  }

  ClubPayment.fromMap(String clubPaymentId, Map<String, dynamic> map)
      : idClubPayment = clubPaymentId,
        nameBank = map['nameBank'] as String,
        iban = map['iban'] as String,
        bic = map['bic'] as String,
        nameAccount = map['nameAccount'] as String?,
        debitCard = map['debitCard'] as String?,
        payPal = map['payPal'] as String?;
}
