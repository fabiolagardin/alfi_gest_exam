import 'package:alfi_gest/models/member.dart';
import 'package:alfi_gest/providers/auth/user_data_provider.dart';
import 'package:alfi_gest/services/member_service.dart';
import 'package:riverpod/riverpod.dart';

class MemberNotifier extends StateNotifier<Member?> {
  final memberService = MemberService();
  final String userId;
  MemberNotifier({required this.userId}) : super(null) {
    fetchMemberData(userId);
  }

  Future<Member?> fetchMemberData(String memberId) async {
    if (mounted) {
      try {
        final memberData = await memberService.getMember(memberId);
        if (memberData.hasData && memberData.error == null) {
          state = memberData.data;
          return state;
        } else {
          state = null;
          if (memberData.data != null) {
            return memberData.data;
          }
        }
      } catch (e) {
        state = null;
      }
    }
    return state;
  }

  Future<void> deleteMember(String userId) async {
    if (mounted) {
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
}

final memberProvider =
    StateNotifierProvider.autoDispose<MemberNotifier, Member?>((ref) {
  final user = ref.watch(userProvider);
  final userId = user.value?.uid ?? '';
  return MemberNotifier(userId: userId);
});
