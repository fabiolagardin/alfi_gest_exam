import 'dart:async';

import 'package:alfi_gest/models/member.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MembersProvider extends StateNotifier<List<Member>> {
  MembersProvider() : super([]) {
    getMembers();
  }
  late StreamSubscription<QuerySnapshot>? _membersSubscription;

  Future<void> getMembers() async {
    final membersStream =
        FirebaseFirestore.instance.collection('members').snapshots();

    _membersSubscription = membersStream.listen((snapshot) {
      state = snapshot.docs
          .map((doc) => Member.fromMap(doc.id, doc.data()))
          .toList();
    });
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

// Definisci il tuo StateNotifierProvider per i membri filtrati
final filteredMembersProvider =
    StateNotifierProvider<FilteredMembersNotifier, List<Member>>((ref) {
  final members = ref.watch(membersProvider);
  return FilteredMembersNotifier(allMembers: members);
});

class FilteredMembersNotifier extends StateNotifier<List<Member>> {
  final List<Member> allMembers;
  List<Member> filteredMembers;

  FilteredMembersNotifier({required this.allMembers})
      : filteredMembers = List.of(allMembers),
        super(allMembers);

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
    filteredMembers = List.of(allMembers);
    state = List.of(allMembers);
  }

  // Metodo per ordinare i membri per lastName
  void orderByLastName({required OrderType orderType}) {
    var orginalState = List.of(allMembers);
    if (orderType == OrderType.notSelected) {
      state = orginalState;
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
    var originalState = List.of(allMembers);

    // Filtra per stato della carta se cardState è fornito
    if (cardState != null) {
      if (cardState == CardState.notSelected) {
        filteredMembers = originalState;
      } else {
        filteredMembers = allMembers.where((member) {
          if (cardState == CardState.expiried) {
            return member.expirationDate.isBefore(DateTime.now());
          } else if (cardState == CardState.suspend) {
            return member.isSuspended == true;
          } else {
            return member.isSuspended == false &&
                member.expirationDate.isAfter(DateTime.now());
          }
        }).toList();
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
