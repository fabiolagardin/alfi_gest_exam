import 'package:alfi_gest/providers/members_data_provider.dart';
import 'package:alfi_gest/screens/members/form_member.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MembersScreen extends ConsumerWidget {
  const MembersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
// Show the create member form
    void showCreateMemberForm() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Dialog(
            child: Stack(
              alignment: Alignment.topRight,
              children: <Widget>[
                const CreateMemberForm(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Get the filtered members
    final filteredMembers = ref.watch(filteredMembersProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista Socie'),
      ),
      body: Container(
        margin: const EdgeInsetsDirectional.only(top: 16),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Consumer(
              builder: (context, ref, child) {
                return TextField(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 24),
                    hintText: "Ricerca socia",
                    suffixIcon: const Icon(
                      Icons.search,
                    ),
                    suffixIconColor: Theme.of(context).colorScheme.onPrimary,
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.primary,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 0,
                      ),
                    ),
                  ),
                  onChanged: (query) {
                    // Aggiorna la query di ricerca
                    ref.read(searchQueryProvider.notifier).state = query;

                    // Filtra i membri in base alla query
                    ref
                        .read(filteredMembersProvider.notifier)
                        .searchMember(query);
                  },
                );
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredMembers.length,
                itemBuilder: (context, index) {
                  final member = filteredMembers[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          (filteredMembers[index].profileImageFile != null)
                              ? NetworkImage(
                                  filteredMembers[index].profileImageFile!.path)
                              : null,
                    ),
                    title: Text('${member.givenName} ${member.lastName}'),
                    subtitle: Text('Tessera: ${member.numberCard}'),
                    trailing: member.expirationDate.isBefore(DateTime.now())
                        ? Container(
                            width: 100,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            alignment: AlignmentDirectional.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color:
                                  Theme.of(context).colorScheme.errorContainer,
                            ),
                            child: Text(
                              'Scaduta',
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              ),
                            ),
                          )
                        : null,
                    onTap: () {
                      // Do something when the member is tapped
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCreateMemberForm();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
