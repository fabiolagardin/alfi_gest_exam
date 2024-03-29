import 'package:alfi_gest/widgets/standard_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InputCard extends ConsumerWidget {
  const InputCard(
      {Key? key,
      required this.title,
      required this.labelsInputs,
      required this.textBtn})
      : super(key: key);
  final String title;
  final Map<int, String> labelsInputs;
  final String textBtn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: Theme.of(context).colorScheme.primary,
      elevation: 0.0,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(
                    10.0), // Imposta il raggio per l'angolo in basso a sinistra
                bottomRight: Radius.circular(
                    10.0), // Imposta il raggio per l'angolo in basso a destra
              ),
            ),
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                for (var i = 0; i < labelsInputs.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: labelsInputs[i],
                        labelStyle: Theme.of(context).textTheme.bodyMedium,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                Row(
                  children: [
                    const Spacer(),
                    StandardButton(
                      onPressed: () async {},
                      child: Text(textBtn,
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary
                                        .withOpacity(0.8),
                                  )),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
