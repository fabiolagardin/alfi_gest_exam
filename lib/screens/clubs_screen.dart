import 'package:alfi_gest/helpers/result.dart';
import 'package:alfi_gest/models/club.dart';
import 'package:alfi_gest/services/club_service.dart';
import 'package:alfi_gest/widgets/form_club.dart';
import 'package:flutter/material.dart';

class ClubsScreen extends StatefulWidget {
  const ClubsScreen({super.key});
  @override
  State<StatefulWidget> createState() => _ClubsScreenState();
}

class _ClubsScreenState extends State<ClubsScreen> {
  late ClubService _clubService;
  late var _clubsFuture;
  void _showCreateClubForm() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Dialog(
          child: Stack(
            alignment: Alignment.topRight,
            children: <Widget>[
              const CreateClubForm(),
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

  @override
  void initState() {
    super.initState();
    _clubService = ClubService();
    _clubsFuture = _clubService.getClubs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Circoli'),
      ),
      body: FutureBuilder<Result<List<Club>>>(
        future: _clubsFuture as Future<Result<List<Club>>>,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.valid) {
              // Convert the snapshot.data to Result<List<Club>> type
              final clubs = snapshot.data!.data;

              return ListView.builder(
                itemCount: clubs!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: (clubs[index].profileImageFile != null)
                          ? NetworkImage(clubs[index].profileImageFile!.path)
                          : null,
                    ),
                    title: Text(clubs[index].nameClub),
                    subtitle: Text(clubs[index].city),
                    onTap: () {
                      Navigator.pushNamed(context, '/circolo',
                          arguments: clubs[index]);
                    },
                  );
                },
              );
            } else {
              return Center(child: Text(snapshot.data!.error!));
            }
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
            onPressed: () {
              _showCreateClubForm();
            },
            child: const Text('Crea'),
          ),
          ElevatedButton(
            onPressed: () {
              // ...
            },
            child: const Text('Modifica'),
          ),
          ElevatedButton(
            onPressed: () {
              // ...
            },
            child: const Text('Cerca'),
          ),
          ElevatedButton(
            onPressed: () {
              // ...
            },
            child: const Text('Cancella'),
          ),
        ],
      ),
    );
  }
}
