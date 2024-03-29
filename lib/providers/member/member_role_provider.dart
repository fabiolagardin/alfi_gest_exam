import 'package:alfi_gest/models/enums.dart';
import 'package:alfi_gest/models/user_role.dart';
import 'package:alfi_gest/providers/auth/user_data_provider.dart';
import 'package:alfi_gest/services/member_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userRoleProvider =
    StateNotifierProvider<UserRoleNotifier, UserRole>((ref) {
  return UserRoleNotifier();
});

class UserRoleNotifier extends StateNotifier<UserRole> {
  UserRoleNotifier()
      : super(UserRole(
          idUserRole: '',
          role: Role.socia, // Sostituisci con un valore di default appropriato
          creationDate: DateTime.now(),
          userCreation: '',
          updateDate: DateTime.now(),
          updateUser: '',
        ));

  void updateRole(Role updatedRole) {
    state = state.copyWith(role: updatedRole);
  }

  void selectUserRole(UserRole userRole) {
    state = userRole;
  }

  void updateUserRole(UserRole updatedUserRole) {
    state = updatedUserRole;
  }
}

class RoleNotifier extends StateNotifier<Role?> {
  final String userId;
  final memberService = MemberService();
  bool _mounted = true;
  RoleNotifier(this.userId) : super(null) {
    if (userId.isNotEmpty) {
      fetchMemberRole();
    }
  }
  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  Future<void> fetchMemberRole() async {
    try {
      final memberRole = await memberService.getMemberRole(userId);
      if (_mounted) {
        if (memberRole.hasData) {
          state = memberRole.data;
        } else {
          state = null; // Aggiorna lo stato a null se non ci sono dati
        }
      }
    } catch (e) {
      if (_mounted) {
        state = null; // Gestisci eventuali errori impostando lo stato a null
      }
    }
  }
}

final roleProvider = StateNotifierProvider<RoleNotifier, Role?>((ref) {
  final user = ref.watch(userProvider);
  if (user.value != null) {
    return RoleNotifier(user.value!.uid);
  } else {
    return RoleNotifier(
        ''); // Provide a default value if user or user.value is null
  }
});

final memberIdProvider = StateProvider<String>(((ref) => ""));

final memberRoleProvider = StateNotifierProvider<RoleNotifier, Role?>((ref) {
  final memberId = ref.watch(memberIdProvider);
  return RoleNotifier(memberId);
});
