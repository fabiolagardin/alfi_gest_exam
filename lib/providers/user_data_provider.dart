import 'package:alfi_gest/models/member.dart';
import 'package:alfi_gest/services/member_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = StreamProvider<User?>(
  (ref) => FirebaseAuth.instance.authStateChanges(),
);

class UserNotifier extends StateNotifier<Member?> {
  final String userId;
  final memberService = MemberService();

  UserNotifier(this.userId) : super(null) {
    userId.isNotEmpty ? fetchUserData() : null;
  }

  Future<void> fetchUserData() async {
    try {
      final memberData = await memberService.getMember(userId);
      if (memberData.hasData) {
        state = memberData.data;
      } else {
        state = null; // Aggiorna lo stato a null se non ci sono dati
      }
    } catch (e) {
      state = null; // Gestisci eventuali errori impostando lo stato a null
    }
  }

  // Future<void> deleteMember(String userId) async {
  //   try {
  //     final deleteMember = await memberService.deleteMember(userId);
  //     if (deleteMember.hasData) {
  //       state = null;
  //     } else {
  //       return;
  //     }
  //   } catch (e) {
  //     state = null;
  //   }
  // }
}

final userDataProvider =
    StateNotifierProvider.autoDispose<UserNotifier, Member?>((ref) {
  final user = ref.watch(userProvider).asData?.value;
  if (user != null) {
    return UserNotifier(user.uid);
  } else {
    return UserNotifier(
        ''); // Replace the empty string with an appropriate default value
  }
});
