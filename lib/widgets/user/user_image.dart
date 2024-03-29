import 'package:alfi_gest/core/result.dart';
import 'package:alfi_gest/providers/auth/user_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserImageProfile extends ConsumerWidget {
  final String memeberId;
  final String initials;

  final double? radius;

  UserImageProfile(
      {required this.memeberId, required this.initials, this.radius});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<Result<String>> imageProfileUrl =
        ref.watch(getImageProfileProvider(memeberId));
    return imageProfileUrl.when(
      data: (result) => result.isOk
          ? CircleAvatar(
              radius: radius ??
                  27, // Il diametro sarà il doppio del raggio, quindi 54
              backgroundImage: NetworkImage(result.data ?? ''),
            )
          : CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              )),
      loading: () => CircularProgressIndicator(),
      error: (_, __) =>
          Icon(Icons.error, color: Theme.of(context).colorScheme.error),
    );
  }
}
