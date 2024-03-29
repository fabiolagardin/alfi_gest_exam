import 'dart:async';

import 'package:alfi_gest/helpers/string_helper.dart';
import 'package:alfi_gest/models/enums.dart';
import 'package:alfi_gest/models/member.dart';
import 'package:alfi_gest/providers/firestore_provider.dart';
import 'package:alfi_gest/services/member_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MembersProvider extends StateNotifier<List<Member>> {
  MembersProvider() : super([]) {
    getMembers();
  }
  late StreamSubscription<QuerySnapshot>? _membersSubscription;
  Future<List<Member>> getMembers() async {
    final HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('getAllMembers');
    final results = await callable.call();
    final members = (results.data as List)
        .map((item) =>
            Member.fromMap(item['id'], (item as Map).cast<String, dynamic>()))
        .toList();
    state = members;
    return members;
  }

  void cancelMembersSubscription() {
    _membersSubscription?.cancel();
    _membersSubscription = null;
  }

  void filterMembers(String query) {
    state = state.where((member) {
      return member.legalName.toLowerCase().contains(query.toLowerCase()) ||
          member.givenName.toLowerCase().contains(query.toLowerCase()) ||
          member.lastName.toLowerCase().contains(query.toLowerCase()) ||
          member.numberCard.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}

final membersProvider = StateNotifierProvider<MembersProvider, List<Member>>(
  (ref) => MembersProvider(),
);

// Definisci il tuo StateProvider per la query di ricerca
final searchQueryProvider = StateProvider<String>((ref) => '');

final membersSuspendedProvider =
    FutureProvider.autoDispose.family<List<Member>, int>((ref, _) async {
  var members = await MembersProvider().getMembers();
  var result = members.where((m) => m.isSuspended == true).toList();
  return result;
});

final suspendedMembersProvider = Provider<List<Member>>((ref) {
  final membersNotifier =
      ref.watch(membersProvider).where((m) => m.isSuspended == true).toList();

  return membersNotifier;
});

final suspendedMembersStreamProvider =
    StreamProvider.autoDispose.family<List<Member>, String?>((ref, idClub) {
  Query query = FirebaseFirestore.instance
      .collection('members')
      .where('isSuspended', isEqualTo: true);

  if (idClub != null) {
    query = query.where('idClub', isEqualTo: idClub);
  }

  return query.snapshots().map((snapshot) {
    return snapshot.docs.map((doc) {
      return Member.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }).toList();
  });
});

final rejectedMembersStreamProvider =
    StreamProvider.autoDispose.family<List<Member>, String?>((ref, idClub) {
  Query query = FirebaseFirestore.instance
      .collection('members')
      .where('isRejected', isEqualTo: true);
  if (idClub != null) {
    query = query.where('idClub', isEqualTo: idClub);
  }
  return query.snapshots().map((snapshot) {
    return snapshot.docs.map((doc) {
      return Member.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }).toList();
  });
});

final suspendedMembersCountProvider =
    Provider.autoDispose.family<String, String?>((ref, idClub) {
  final suspendedMembers = ref.watch(suspendedMembersStreamProvider(idClub));
  return suspendedMembers.when(
    data: (members) => '${members.length} richieste',
    loading: () => 'Caricamento...',
    error: (error, stackTrace) => 'Errore: $error',
  );
});

final rejectedMembersCountProvider =
    Provider.autoDispose.family<String, String?>((ref, idClub) {
  final rejectedMembers = ref.watch(rejectedMembersStreamProvider(idClub));
  return rejectedMembers.when(
    data: (members) => '${members.length} socie*',
    loading: () => 'Caricamento...',
    error: (error, stackTrace) => 'Errore: $error',
  );
});
final membersDataProvider = Provider<MembersProvider>((ref) {
  return MembersProvider();
});
// Definisci il tuo StateNotifierProvider per i membri filtrati
final filteredMembersProvider =
    StateNotifierProvider<FilteredMembersNotifier, List<Member>>((ref) {
  final members = ref.watch(membersProvider);
  final firestore = ref.watch(firebaseFirestoreProvider);
  return FilteredMembersNotifier(allMembers: members, firestore: firestore);
});

final filteredMembersCountProvider = Provider<String>((ref) {
  final filteredMembers = ref.watch(filteredMembersProvider);
  final memberWithRole = ref.watch(memberWithRoleProvider);

  final filteredCount = filteredMembers
      .where((member) => memberWithRole
          .any((item) => item.member.id == member.id && item.role != "Socia"))
      .length;

  return filteredCount <= 0 ? 'loading...' : '$filteredCount persone';
});

class FilteredMembersNotifier extends StateNotifier<List<Member>> {
  List<Member> allMembers;
  List<Member> filteredMembers;
  final FirebaseFirestore _firestore;
  FilteredMembersNotifier(
      {required this.allMembers, required FirebaseFirestore firestore})
      : _firestore = firestore,
        filteredMembers = allMembers
            .where((c) => c.isSuspended == false)
            .where((c) => c.isRejected == false)
            .where((c) => c.numberCard != '')
            .toList(),
        super(allMembers
            .where((c) => c.isSuspend == false)
            .where((c) => c.isRejected == false)
            .where((c) => c.numberCard != '')
            .toList()) {
    listenToDatabaseChanges();
  }
  void searchMember(String query) {
    if (query.isNotEmpty) {
      // Filtra la lista solo se la query non è vuota
      state = filteredMembers.where((member) {
        return member.legalName.toLowerCase().contains(query.toLowerCase()) ||
            member.givenName.toLowerCase().contains(query.toLowerCase()) ||
            member.lastName.toLowerCase().contains(query.toLowerCase()) ||
            member.numberCard.toLowerCase().contains(query.toLowerCase());
      }).toList();
    } else {
      // Se la query è vuota, ripristina la lista filtrata
      state = List.of(filteredMembers);
    }
  }

  void resetFilters() {
    filteredMembers = allMembers
        .where((c) => c.isSuspended == false)
        .where((c) => c.isRejected == false)
        .where((c) => c.numberCard != '')
        .toList();
    if (mounted) {
      state = filteredMembers;
    }
  }

  void updateAllMembers(List<Member> updatedMembers) {
    allMembers = updatedMembers;
    filteredMembers = allMembers
        .where((c) => c.isSuspended == false)
        .where((c) => c.numberCard != '')
        .toList();
    resetFilters();
  }

  void listenToDatabaseChanges() {
    _firestore.collection('members').snapshots().listen((snapshot) {
      List<Member> updatedMembers = snapshot.docs.map((doc) {
        // Converti ogni DocumentSnapshot in un Member
        return Member.fromMap(doc.id, doc.data());
      }).toList();

      updateAllMembers(updatedMembers);
    });
  }

  // Metodo per ordinare i membri per lastName
  void orderByLastName({required OrderType orderType}) {
    var originalState = allMembers
        .where((c) => c.isSuspended == false)
        .where((c) => c.isRejected == false)
        .where((c) => c.numberCard != '')
        .toList();

    if (orderType == OrderType.notSelected) {
      state = originalState;
    } else {
      state.sort((a, b) {
        int order = a.lastName.compareTo(b.lastName);
        if (orderType == OrderType.descending) {
          order = -order;
        }
        return order;
      });
      state =
          List.from(state); // Aggiorna lo stato per riflettere il cambiamento
    }
  }

  void filterMembers({CardState? cardState, String? clubId}) {
    var originalState = allMembers
        .where((c) => c.isSuspended == false)
        .where((c) => c.isRejected == false)
        .where((c) => c.numberCard != '')
        .toList();
    // Filtra per stato della carta se cardState è fornito
    if (cardState != null) {
      if (cardState == CardState.notSelected) {
        filteredMembers = originalState;
      } else {
        filteredMembers = allMembers
            .where((member) {
              if (cardState == CardState.expiried) {
                return member.expirationDate.isBefore(DateTime.now());
              } else if (cardState == CardState.suspend) {
                return member.isSuspended == true &&
                    member.expirationDate.isAfter(DateTime.now());
              } else {
                return member.isSuspended == false &&
                    member.expirationDate.isAfter(DateTime.now());
              }
            })
            .where((c) => c.isRejected == false)
            .where((c) => c.numberCard != '')
            .toList();
      }
    }

    // Filtra per circolo se clubId è fornito
    if (clubId != null && clubId.isNotEmpty) {
      filteredMembers = filteredMembers.where((member) {
        return member.idClub == clubId;
      }).toList();
    }

    state = List.of(filteredMembers);
  }

  List<Member> getMembersSuspended() {
    var members = allMembers
        .where((m) => m.isSuspended == true)
        .where((c) => c.numberCard != '')
        .toList();
    return members;
  }
}

class MemberWithRole {
  final Member member;
  final String role;

  MemberWithRole({required this.member, required this.role});
}

final memberService = MemberService();

final memberWithRoleProvider =
    StateNotifierProvider<MemberWithRoleNotifier, List<MemberWithRole>>((ref) {
  return MemberWithRoleNotifier(memberService);
});

class MemberWithRoleNotifier extends StateNotifier<List<MemberWithRole>> {
  final MemberService memberService;

  MemberWithRoleNotifier(this.memberService) : super([]) {
    refresh();
  }

  Future<void> refresh() async {
    final members = await memberService.getMembers();
    List<MemberWithRole> membersWithRole = [];

    for (var member in members.data ?? []) {
      final role = await memberService.getMemberRole(member.id);
      membersWithRole.add(MemberWithRole(
          member: member, role: formatRole(role.data ?? Role.nonAssegnato)));
    }

    state = membersWithRole;
  }
}

final orderTypeProvider =
    StateProvider<OrderType>((ref) => OrderType.notSelected);

enum OrderType {
  notSelected,
  ascending,
  descending,
}

final filteredSelectedProvider =
    StateProvider<FilterdSelected>((ref) => FilterdSelected.notSelected);

enum FilterdSelected {
  notSelected,
  expiration,
  club,
  supended,
  closed,
}

final cardStateProvider =
    StateProvider<CardState>((ref) => CardState.notSelected);

enum CardState {
  notSelected,
  expiried,
  suspend,
  active,
}

final clubIdSelectedProvider = StateProvider<String>((ref) => "");
