import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alfi_gest/models/club.dart';
import 'package:alfi_gest/services/club_service.dart';

// Definisci un provider per ClubService
final clubServiceProvider = Provider<ClubService>((ref) {
  return ClubService();
});

// Definisci un FutureProvider per recuperare i club
final clubsProvider = FutureProvider<List<Club>>((ref) async {
  final clubService = ref.watch(clubServiceProvider);
  final result = await clubService.getClubs();

  if (result.valid && result.data != null) {
    return result.data!;
  } else {
    // Gestisci l'errore o restituisci una lista vuota
    throw Exception('Errore nel recupero dei club: ${result.error}');
  }
});

class ClubsDataProvider extends StateNotifier<List<Club>> {
  ClubsDataProvider() : super([]) {
    getClubs();
  }

  Future<void> getClubs() async {
    final clubsStream =
        FirebaseFirestore.instance.collection('clubs').snapshots();

    clubsStream.listen((snapshot) {
      state =
          snapshot.docs.map((doc) => Club.fromMap(doc.id, doc.data())).toList();
    });
  }
}
