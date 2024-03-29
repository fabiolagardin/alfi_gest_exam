import 'package:alfi_gest/core/result.dart';
import 'package:alfi_gest/models/club.dart';
import 'package:alfi_gest/providers/auth/user_data_provider.dart';
import 'package:alfi_gest/services/club_service.dart';
import 'package:riverpod/riverpod.dart';

final clubLogoUrlProvider = FutureProvider.autoDispose
    .family<Result<String>, String>((ref, idClub) async {
  var result = await ClubService().getClubLogoUrl(idClub);
  return result;
});

class ClubNotifier extends StateNotifier<Club?> {
  final clubService = ClubService();
  final String userId;
  ClubNotifier({required this.userId}) : super(null) {
    fetchClubData(userId);
  }

  Future<Club> fetchClubData(String clubId) async {
    try {
      final clubData = await clubService.getClub(clubId);
      if (clubData.hasData) {
        state = clubData.data;
        return state!;
      } else {
        state = null;
        return clubData.data!;
        // Aggiorna lo stato a null se non ci sono dati
      }
    } catch (e) {
      state = null; // Gestisci eventuali errori impostando lo stato a null
    }
    return state!;
  }

  Future<void> deleteClub(String userId) async {
    try {
      final deleteClub = await clubService.deleteClub(userId);
      if (deleteClub.hasData) {
        state = null;
      } else {
        return;
      }
    } catch (e) {
      state = null;
    }
  }
}

final clubProvider =
    StateNotifierProvider.autoDispose<ClubNotifier, Club?>((ref) {
  final user = ref.watch(userProvider);
  return ClubNotifier(userId: user.value!.uid);
});

final filteredClubsSelectedProvider = StateProvider<FilterdClubSelected>(
    (ref) => FilterdClubSelected.notSelected);

enum FilterdClubSelected { notSelected, supended, closed, sort }

final orderClubsTypeProvider =
    StateProvider<OrderClubsType>((ref) => OrderClubsType.notSelected);

enum OrderClubsType {
  notSelected,
  ascending,
  descending,
}
