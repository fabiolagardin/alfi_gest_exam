import 'package:alfi_gest/core/result.dart';
import 'package:alfi_gest/providers/clubs/club_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClubLogo extends ConsumerWidget {
  final String idClub;
  final double? radius;

  ClubLogo({required this.idClub, this.radius});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<Result<String>> clubLogoUrl =
        ref.watch(clubLogoUrlProvider(idClub));
    return clubLogoUrl.when(
      data: (result) => result.isOk
          ? CircleAvatar(
              radius: radius ??
                  27, // Il diametro sarà il doppio del raggio, quindi 54
              backgroundImage: NetworkImage(result.data ?? ''),
            )
          : const SizedBox.shrink(),
      loading: () => CircularProgressIndicator(),
      error: (_, __) =>
          Icon(Icons.error, color: Theme.of(context).colorScheme.error),
    );
  }
}
