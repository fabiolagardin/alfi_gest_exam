import 'package:flutter_riverpod/flutter_riverpod.dart';

final refreshListProvider =
    StateNotifierProvider<RefreshList, int>((ref) => RefreshList());

class RefreshList extends StateNotifier<int> {
  RefreshList() : super(0);

  void refresh() {
    state++;
  }
}
