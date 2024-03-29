import 'dart:io';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:alfi_gest/core/result.dart';
import 'package:alfi_gest/models/club.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as path;

class ClubService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Result<bool>> checkClubName(String clubName) async {
    final clubsRef = FirebaseFirestore.instance.collection('clubs');

    final doc = await clubsRef.doc(clubName).get();

    if (doc.exists) {
      return Result.fail(
          error: 'Il nome del circolo è già presente nel database.');
    } else {
      return Result.ok(value: true, data: true);
    }
  }

  Future<Result<Club>> getClub(String cid) async {
    final docRef = _firestore.collection('clubs').doc(cid);
    final docSnapshot = await docRef.get();

    if (!docSnapshot.exists) {
      return Result(error: "Club non esistente");
    }

    final data = docSnapshot.data();
    if (data == null) {
      return Result(error: "Dati Club non esistenti");
    }

    return Result(valid: true, data: Club.fromMap(cid, data));
  }

  Future<Result<List<Club>>> getClubs() async {
    final collectionRef = _firestore.collection('clubs');
    final querySnapshot = await collectionRef.get();

    final clubs = <Club>[];
    for (final docSnapshot in querySnapshot.docs) {
      final data = docSnapshot.data();
      if (data.isEmpty) {
        return Result(
            error:
                "Errore durante il recupero dei dati del club: ${docSnapshot.id}");
      }

      final club = Club.fromMap(docSnapshot.id, data);
      clubs.add(club);
    }

    return Result(valid: true, data: clubs);
  }

  Future<Result<bool>> createClub(String cid, Club newClub) async {
    // Controlla se tutti i campi obbligatori sono validi
    var isValid = newClub.validate(newClub);
    if (!isValid.valid) {
      return Result(valid: false, errors: isValid.errors);
    }
    final functions = FirebaseFunctions.instance;

    // Controlla se un club con l'ID utente specificato esiste già
    final club = await functions.httpsCallable('getClub').call({'idClub': cid});
    var existing = club.data as Map<String, dynamic>;
    if (!existing.containsValue("Circolo non trovato")) {
      return Result(valid: false, error: "Circolo già esitente");
    }

    newClub.idClub = cid;
    // Crea un nuovo membro nel database
    final result = await functions
        .httpsCallable('createClub')
        .call({'newClub': newClub.toMap()});
    var data = result.data as Map<String, dynamic>;
    if (data.containsValue(
        "Si è verificato un errore durante la creazione del circolo.")) {
      return Result(
          valid: false,
          error: "Si è verificato un errore durante la creazione del circolo.");
    }
    return Result(valid: true, data: true);
  }

  Future<Result<bool>> updateClub(String cid, Club updatedClub) async {
    var isValid = updatedClub.validate(updatedClub);
    if (!isValid.valid) {
      return Result(valid: false, errors: isValid.errors);
    }

    final functions = FirebaseFunctions.instance;

    final club = await functions.httpsCallable('getClub').call({'idClub': cid});
    var existing = club.data as Map<String, dynamic>;
    if (existing.containsValue("Socia* non trovata")) {
      return Result(valid: false, error: "Socia* non trovata");
    }

    // Update the club in the database
    final result = await functions
        .httpsCallable('updateClub')
        .call({'idClub': cid, 'updatedClub': updatedClub.toMap()});

    var data = result.data as Map<String, dynamic>;
    if (data.containsValue(
        "Un errore si è verificato durante l'aggiornamento del circolo.")) {
      return Result(
          valid: false,
          error:
              "Un errore si è verificato durante l'aggiornamento del circolo.");
    }
    return Result(valid: true, data: true, message: data['message']);
  }

  Future<Result<bool>> updateClubManager(
      String cid, String idMemberManager) async {
    final functions = FirebaseFunctions.instance;

    final club = await functions.httpsCallable('getClub').call({'idClub': cid});
    var existing = club.data as Map<String, dynamic>;
    if (existing.containsValue("Socia* non trovata")) {
      return Result(valid: false, error: "Socia* non trovata");
    }

    // Update the club manager in the database
    final result = await functions
        .httpsCallable('updateClubManager')
        .call({'idClub': cid, 'idMemberManager': idMemberManager});

    var data = result.data as Map<String, dynamic>;
    if (data.containsValue(
        "Un errore si è verificato durante l'aggiornamento del circolo.")) {
      return Result(
          valid: false,
          error:
              "Un errore si è verificato durante l'aggiornamento del circolo.");
    }
    return Result(valid: true, data: true, message: data['message']);
  }

  Future<Result<Club>> deleteClub(String cid) async {
    // Check if the Club exists
    final clubResult = await getClub(cid);
    if (!clubResult.isSuccess() || !clubResult.hasData) {
      return Result(valid: false, error: "Club non esitente");
    }

    // Delete the Club's document from the database
    await _firestore.collection('clubs').doc(cid).delete();

    return Result(valid: true);
  }

  // funzione che aggiorna il valore se il circolo è sospeso o chiuso usando firestore
  Future<Result<bool>> updateClubStatus(
      String cid, bool isSuspend, bool status) async {
    try {
      await _firestore.collection('clubs').doc(cid).update({
        if (!isSuspend && !status) 'isSuspend': status,
        if (isSuspend) 'isSuspend': status,
        if (!isSuspend) 'isClosed': status,
      });
      return Result(valid: true, data: true);
    } catch (e) {
      return Result(valid: false, error: e.toString());
    }
  }

  Future<Result<bool>> uploadLogoClub(String filePath, String idClub) async {
    File file = File(filePath);
    try {
      // Crea un riferimento a Firebase Storage
      FirebaseStorage storage = FirebaseStorage.instance;

      // Crea un riferimento alla cartella
      Reference folderRef = storage.ref().child('club_images/$idClub');

      // Ottieni la lista dei file nella cartella
      ListResult result = await folderRef.listAll();

      // Elimina tutti i file nella cartella
      for (var fileRef in result.items) {
        await fileRef.delete();
      }

      // Ottieni il nome del file dal percorso del file
      String fileName = path.basename(file.path);

      // Crea un riferimento al file che vuoi caricare
      Reference ref = storage.ref().child('club_images/$idClub/$fileName');

      // Carica il file su Firebase Storage
      UploadTask uploadTask = ref.putFile(file);

      // Aspetta che il caricamento sia completato
      await uploadTask.whenComplete(() => null);
      print('Upload complete.');

      // Restituisci un Result con valore true per indicare che l'upload è stato completato con successo
      return Result<bool>.ok(value: true, data: true);
    } catch (e) {
      print(e);

      // Restituisci un Result con l'errore per indicare che l'upload è fallito
      return Result<bool>.fail(error: e.toString());
    }
  }

  Future<Result<String>> getClubLogoUrl(String idClub) async {
    try {
      // Crea un riferimento a Firebase Storage
      FirebaseStorage storage = FirebaseStorage.instance;

      // Crea un riferimento alla cartella
      Reference folderRef = storage.ref().child('club_images/$idClub');

      // Ottieni la lista dei file nella cartella
      ListResult result = await folderRef.listAll();

      // Controlla se la cartella contiene almeno un file
      if (result.items.isEmpty) {
        return Result<String>.fail(error: "Nessun file trovato nella cartella");
      }

      // Crea un riferimento al primo file nella cartella
      Reference fileRef = result.items.first;

      // Ottieni l'URL del file
      String downloadURL = await fileRef.getDownloadURL();

      // Restituisci un Result con l'URL del file
      return Result<String>.ok(value: true, data: downloadURL);
    } catch (e) {
      print(e);

      // Restituisci un Result con l'errore
      return Result<String>.fail(error: e.toString());
    }
  }
}
