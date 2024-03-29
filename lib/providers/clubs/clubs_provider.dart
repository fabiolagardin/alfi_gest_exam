import 'package:alfi_gest/core/result.dart';
import 'package:alfi_gest/providers/clubs/club_data_provider.dart';
import 'package:alfi_gest/providers/firestore_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alfi_gest/models/club.dart';
import 'package:alfi_gest/services/club_service.dart';

// Definisci un provider per ClubService
final clubServiceProvider = Provider<ClubService>((ref) {
  return ClubService();
});

final clubsProvider = FutureProvider<Result<List<Club>>>((ref) {
  final clubService = ref.watch(clubServiceProvider);
  return clubService.getClubs();
});
final clubsDataProvider = Provider<ClubsDataProvider>((ref) {
  return ClubsDataProvider();
});

/// A state notifier that provides a list of clubs.
class ClubsDataProvider extends StateNotifier<List<Club>> {
  ClubsDataProvider() : super([]) {
    getClubs();
  }

  /// Retrieves the list of clubs from Firestore.
  Future<List<Club>> getClubs() async {
    final clubsStream =
        FirebaseFirestore.instance.collection('clubs').snapshots();

    var clubs = <Club>[];

    var snapshot = await clubsStream.first;
    clubs =
        snapshot.docs.map((doc) => Club.fromMap(doc.id, doc.data())).toList();

    state = clubs;

    return clubs;
  }
}

// Definisci il tuo StateProvider per la query di ricerca
final searchQueryClubProvider = StateProvider<String>((ref) => '');

// Definisci il tuo StateNotifierProvider per i membri filtrati
final filteredClubsProvider =
    StateNotifierProvider<FilteredClubsNotifier, List<Club>>((ref) {
  final clubs = ref.watch(clubsProvider);
  final firestore = ref.watch(firebaseFirestoreProvider);

  return FilteredClubsNotifier(
      allClubs: clubs.value?.data ?? [], firestore: firestore);
});

/// A state notifier that filters and manages the list of clubs.
class FilteredClubsNotifier extends StateNotifier<List<Club>> {
  List<Club> allClubs;
  List<Club> filteredClubs;
  final FirebaseFirestore _firestore;

  FilteredClubsNotifier(
      {required this.allClubs, required FirebaseFirestore firestore})
      : _firestore = firestore,
        filteredClubs = allClubs
            .where((c) => c.isClosed == false && c.isSuspended == false)
            .toList(),
        super(allClubs
            .where((c) => c.isClosed == false && c.isSuspended == false)
            .toList()) {
    resetFilters();
  }

  /// Updates the list of all clubs and triggers database change listener.
  void updateAllClubs(List<Club> updatedClubs) {
    allClubs = updatedClubs;
    filteredClubs = allClubs
        .where((c) => c.isClosed == false && c.isSuspended == false)
        .toList();
    listenToDatabaseChanges();
  }

  /// Listens to database changes and updates the list of all clubs.
  void listenToDatabaseChanges() {
    _firestore.collection('clubs').snapshots().listen((snapshot) {
      List<Club> updatedClubs = snapshot.docs.map((doc) {
        // Converti ogni DocumentSnapshot in un Member
        return Club.fromMap(doc.id, doc.data());
      }).toList();

      updateAllClubs(updatedClubs);
    });
  }

  /// Filters the list of clubs based on the provided search query.
  void searchClub(String query) {
    if (query.isNotEmpty) {
      // Filtra la lista solo se la query non è vuota
      state = filteredClubs.where((club) {
        return club.nameClub.toLowerCase().contains(query.toLowerCase()) ||
            club.city.toLowerCase().contains(query.toLowerCase());
      }).toList();
    } else {
      // Se la query è vuota, ripristina la lista filtrata
      state = List.of(filteredClubs);
    }
  }

  /// Resets the filters and restores the original list of clubs.
  void resetFilters() {
    filteredClubs = allClubs
        .where((c) => c.isClosed == false && c.isSuspended == false)
        .toList();
    state = filteredClubs;
  }

  // Metodo per ordinare i membri per lastName
  void orderByLastName({required OrderClubsType orderType}) {
    var orginalState = filteredClubs;
    if (orderType == OrderClubsType.notSelected) {
      state = orginalState;
    } else {
      state.sort((a, b) {
        int order = a.nameClub.compareTo(b.nameClub);
        if (orderType == OrderClubsType.descending) {
          order = -order;
        }
        return order;
      });
      state =
          List.from(state); // Aggiorna lo stato per riflettere il cambiamento
    }
  }

  /// Filters the clubs based on the provided filter selection.
  ///
  /// The [filterSelected] parameter is an optional argument of type [FilterdClubSelected]
  /// that represents the selected filter criteria. If no filter is selected, all clubs
  /// will be returned.
  void filterClubs({FilterdClubSelected? filterSelected}) {
    var originalState = filteredClubs;

    // Filtra per stato della carta se filterSelected è fornito
    if (filterSelected != null) {
      if (filterSelected == FilterdClubSelected.notSelected) {
        filteredClubs = originalState;
      } else {
        filteredClubs = allClubs.where((club) {
          if (filterSelected == FilterdClubSelected.supended) {
            return club.isSuspended == true && club.isClosed == false;
          } else if (filterSelected == FilterdClubSelected.closed) {
            return club.isClosed == true;
          } else {
            return club.isSuspended == false && club.isClosed == false;
          }
        }).toList();
      }
    }

    state = List.of(filteredClubs);
  }
}
