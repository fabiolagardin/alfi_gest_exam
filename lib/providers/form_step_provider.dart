import 'package:flutter_riverpod/flutter_riverpod.dart';

final formStepProvider = StateProvider<int>((ref) {
  return 0; // Initial step is 0, corresponding to the first form step
});
