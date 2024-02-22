import 'dart:io';

import 'package:alfi_gest/models/club.dart';
import 'package:alfi_gest/services/club_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class CreateClubForm extends StatefulWidget {
  const CreateClubForm({super.key});

  @override
  State<CreateClubForm> createState() => _CreateClubFormState();
}

class _CreateClubFormState extends State<CreateClubForm> {
  final _formKey = GlobalKey<FormState>();

  final _nameClubController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _idMemberManagerController = TextEditingController();
  File? _profileImageFile;
  final ImagePicker _imagePicker = ImagePicker();
  final ClubService _clubService = ClubService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var uuid = const Uuid();
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _nameClubController,
                decoration: const InputDecoration(
                  labelText: 'Nome circolo',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Inserire il nome del circolo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: 'Città',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Inserire la città';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Indirizzo *',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Inserire l\'indirizzo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email *',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Inserire l\'email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _idMemberManagerController,
                decoration: const InputDecoration(
                  labelText: 'ID responsabile',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Inserire l\'ID responsabile';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Carica un'immagine del profilo
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: TextEditingController(
                          text: _profileImageFile?.path ?? ''),
                      decoration: const InputDecoration(
                        labelText: 'Immagine del profilo',
                      ),
                      readOnly: true,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_a_photo),
                    onPressed: () async {
                      // Apre la galleria fotografica
                      final XFile? image = await _imagePicker.pickImage(
                        source: ImageSource.gallery,
                      );

                      if (image != null) {
                        setState(() {
                          _profileImageFile = File(image.path);
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  // Controlla se il nome del circolo è già presente nel database
                  final result = await _clubService.checkClubName(
                    _nameClubController.text,
                  );

                  if (result.valid) {
                    // Il nome del circolo non è presente nel database
                    // Crea il nuovo club
                    final club = Club(
                      idClub: uuid.v4(),
                      nameClub: _nameClubController.text,
                      city: _cityController.text,
                      address: _addressController.text,
                      email: _emailController.text,
                      idMemberManager: _idMemberManagerController.text,
                      isSuspend: false,
                      creationDate: DateTime.now(),
                      userCreation: 'admin',
                      updateDate: DateTime.now(),
                      updateUser: 'admin',
                      profileImageFile: _profileImageFile,
                    );

                    // Invia la richiesta al backend
                    final result = await _clubService.createClub(
                      club.idClub,
                      club,
                    );

                    if (result.valid) {
                      // Chiude la schermata
                      Navigator.pop(context);
                    } else {
                      // Mostra un messaggio di errore
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(result.error!)),
                      );
                    }
                  } else {
                    // Il nome del circolo è già presente nel database
                    // Mostra un messaggio di errore
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                                                              behavior: SnackBarBehavior.floating,
                        content: Text(
                          'Il nome del circolo è già presente nel database.',
                        ),
                      ),
                    );
                  }
                },
                child: const Text('Crea Club'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
