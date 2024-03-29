import 'package:alfi_gest/pages/members/members_page.dart';
import 'package:alfi_gest/providers/member/members_data_provider.dart';
import 'package:alfi_gest/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MembersRefusePage extends ConsumerStatefulWidget {
  @override
  _MembersRefusePageState createState() => _MembersRefusePageState();
}

class _MembersRefusePageState extends ConsumerState<MembersRefusePage> {
  @override
  Widget build(BuildContext context) {
    final idClubSelected = ref.watch(idClubSelectedProvider);
    final membersReject =
        ref.watch(rejectedMembersStreamProvider(idClubSelected));
    final searchQuery = ref.watch(searchQueryProvider);

    return membersReject.when(
      data: (members) {
        final filteredMembers = members.where((member) {
          final query = searchQuery.toLowerCase();
          final title = member.title.toLowerCase();
          return title.contains(query);
        }).toList();
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 70,
            leading: Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 4),
              child: TextButton(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chevron_left,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      Text(
                        "Indietro",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                color: Theme.of(context).colorScheme.secondary),
                      ),
                    ],
                  ),
                  onPressed: () {
                    ref.read(isMembersRejectedPageProvider.notifier).state =
                        false;
                    ref
                        .read(isMembersRejectedDetailsPageProvider.notifier)
                        .state = false;
                  }),
            ),
            leadingWidth: 150,
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            actions: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 14, 0),
                child: Text(
                  "Socie* rifiutate",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                ),
              ),
            ],
          ),
          body: Stack(
            children: [
              Container(
                margin: const EdgeInsetsDirectional.only(top: 16),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Consumer(
                      builder: (context, ref, child) {
                        return TextField(
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 24),
                            hintText: "Cerca socie*",
                            hintStyle:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant
                                          .withOpacity(0.5),
                                    ),
                            suffixIcon: const Icon(
                              Icons.search,
                            ),
                            suffixIconColor:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.background,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(28),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: (query) {
                            // Aggiorna la query di ricerca
                            ref.read(searchQueryProvider.notifier).state =
                                query;
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 14),
                    filteredMembers.length <= 0
                        ? Center(
                            heightFactor: 2.5,
                            child: Text(
                              "Nessun risultato",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                            ))
                        : Expanded(
                            child: ListView.builder(
                              itemCount: filteredMembers.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          width: 1.0,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                    ),
                                  ),
                                  child: ListTile(
                                    title: Text(filteredMembers[index].title),
                                    trailing: IconButton(
                                      icon: Icon(Icons.remove_red_eye_outlined),
                                      onPressed: () {
                                        ref
                                            .read(memberSelected.notifier)
                                            .state = filteredMembers[index];
                                        ref
                                            .read(isMembersRejectedPageProvider
                                                .notifier)
                                            .state = false;
                                        ref
                                            .read(
                                                isMembersRejectedDetailsPageProvider
                                                    .notifier)
                                            .state = true;
                                        ref
                                            .read(
                                                isMemberPendingDetailsPageProvider
                                                    .notifier)
                                            .state = true;
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      error: (error, stackTrace) {
        return Scaffold(
          body: Center(
            child: Text(
              "Errore: $error",
            ),
          ),
        );
      },
    );
  }
}
