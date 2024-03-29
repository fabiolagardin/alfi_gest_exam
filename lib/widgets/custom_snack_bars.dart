import 'dart:async';

import 'package:flutter/material.dart';

class CustomSnackBar {
  static showCountdownSnackBar({
    required BuildContext context,
    required StreamController<int> countdownController,
    required String message,
    required VoidCallback onCancel,
    required int countdownValue,
  }) {
    final sm = ScaffoldMessenger.of(context);
    Timer.periodic(Duration(seconds: 1), (timer) {
      countdownController.add(countdownValue);
      if (countdownValue == 0) {
        timer.cancel();
        countdownController.close();
      } else {
        countdownValue--;
      }
    });

    sm.showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
        content: StreamBuilder<int>(
          stream: countdownController.stream,
          builder: (context, snapshot) {
            return Text(
              '$message si cancella in ${snapshot.data ?? 3}',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            );
          },
        ),
        action: SnackBarAction(
          label: 'Annulla',
          onPressed: onCancel,
        ),
      ),
    );
  }

  static showSuccessSnackBar({
    required BuildContext context,
    required String message,
  }) {
    final sm = ScaffoldMessenger.of(context);
    final snackBar = SnackBar(
      backgroundColor: Theme.of(context)
          .colorScheme
          .primary, // Cambia questo colore come desideri
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      content: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context)
                  .colorScheme
                  .onPrimary, // Cambia questo colore come desideri
            ),
      ),
      behavior: SnackBarBehavior.floating,
    );
    sm.showSnackBar(snackBar);
  }

  static showErrorSnackBar({
    required BuildContext context,
    required String message,
  }) {
    final sm = ScaffoldMessenger.of(context);
    final snackBar = SnackBar(
      backgroundColor: Theme.of(context).colorScheme.errorContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      content: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.onTertiary,
            ),
      ),
      behavior: SnackBarBehavior.floating,
    );
    sm.showSnackBar(snackBar);
  }
}
