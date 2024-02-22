import 'package:alfi_gest/models/member.dart';
import 'package:alfi_gest/services/member_service.dart';
import 'package:riverpod/riverpod.dart';

class MemberNotifier extends StateNotifier<Member?> {
  final memberService = MemberService();

  MemberNotifier() : super(null);

  Future<void> fetchMemberData(String memberId) async {
    try {
      final memberData = await memberService.getMember(memberId);
      if (memberData.hasData) {
        state = memberData.data;
      } else {
        state = null; // Aggiorna lo stato a null se non ci sono dati
      }
    } catch (e) {
      state = null; // Gestisci eventuali errori impostando lo stato a null
    }
  }

  Future<void> deleteMember(String userId) async {
    try {
      final deleteMember = await memberService.deleteMember(userId);
      if (deleteMember.hasData) {
        state = null;
      } else {
        return;
      }
    } catch (e) {
      state = null;
    }
  }
}

final memberProvider =
    StateNotifierProvider.autoDispose<MemberNotifier, Member?>((ref) {
  return MemberNotifier();
});
