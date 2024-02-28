import 'package:flutter_riverpod/flutter_riverpod.dart';

final validationProvider =
    StateNotifierProvider<ValidationNotifier, bool>((ref) {
  return ValidationNotifier();
});

class ValidationNotifier extends StateNotifier<bool> {
  ValidationNotifier()
      : super(true); // Assumiamo che all'inizio i campi non siano validati

  void validateFields({required bool areFieldsValid}) {
    state = areFieldsValid;
  }
}
