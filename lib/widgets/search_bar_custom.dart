import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchBarCustom extends StatelessWidget {
  final String hintText;
  final Function(String) onQueryChanged;

  SearchBarCustom({required this.hintText, required this.onQueryChanged});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return TextField(
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(left: 24),
            hintText: hintText,
            hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant
                      .withOpacity(0.5),
                ),
            suffixIcon: const Icon(
              Icons.search,
            ),
            suffixIconColor: Theme.of(context).colorScheme.onSurfaceVariant,
            filled: true,
            fillColor: Theme.of(context).colorScheme.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: onQueryChanged,
        );
      },
    );
  }
}
