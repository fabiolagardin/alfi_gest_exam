import 'package:alfi_gest/providers/user_data_provider.dart';
import 'package:alfi_gest/services/member_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoleNotifier extends StateNotifier<String?> {
  final String userId;
  final memberService = MemberService();

  RoleNotifier(this.userId) : super(null) {
    if (userId.isNotEmpty) {
      fetchMemberRole();
    }
  }

  Future<void> fetchMemberRole() async {
    try {
      final memberRole = await memberService.getMemberRole(userId);
      if (memberRole.hasData) {
        state = memberRole.data;
      } else {
        state = null; // Aggiorna lo stato a null se non ci sono dati
      }
    } catch (e) {
      state = null; // Gestisci eventuali errori impostando lo stato a null
    }
  }
}

final roleProvider = StateNotifierProvider<RoleNotifier, String?>((ref) {
  final user = ref.watch(userProvider);
  if (user != null && user.value != null) {
    return RoleNotifier(user.value!.uid);
  } else {
    return RoleNotifier(
        ''); // Provide a default value if user or user.value is null
  }
});
