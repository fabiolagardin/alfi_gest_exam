import 'package:alfi_gest/helpers/string_helper.dart';
import 'package:alfi_gest/models/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:alfi_gest/screens/main_screen.dart';

final bookSelectedProvider =
    StateProvider<BookType>((ref) => BookType.nonAssegnato);

class BooksClubPage extends ConsumerWidget {
  const BooksClubPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsetsDirectional.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SingleChildScrollView(
        child: Column(
          children: [
            InkWell(
              onTap: () {
                ref.read(isBookDetailsPageProvider.notifier).state = true;
                ref.read(isBookPageProvider.notifier).state = false;
                ref.read(isMainAppBarProvider.notifier).state = false;
                ref.read(bookSelectedProvider.notifier).state =
                    BookType.libroSocie;
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      width: 1,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              displayStringForBookType(BookType.libroSocie),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                ref.read(isBookDetailsPageProvider.notifier).state = true;
                ref.read(isBookPageProvider.notifier).state = false;
                ref.read(isMainAppBarProvider.notifier).state = false;
                ref.read(bookSelectedProvider.notifier).state =
                    BookType.libroSocieVolontarie;
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      width: 1,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              displayStringForBookType(
                                  BookType.libroSocieVolontarie),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                ref.read(isBookDetailsPageProvider.notifier).state = true;
                ref.read(isBookPageProvider.notifier).state = false;
                ref.read(isMainAppBarProvider.notifier).state = false;
                ref.read(bookSelectedProvider.notifier).state =
                    BookType.libroSocieLavoratrici;
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      width: 1,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              displayStringForBookType(
                                  BookType.libroSocieLavoratrici),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
