import 'package:alfi_gest/helpers/result.dart';
import 'package:alfi_gest/models/club.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClubService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Result<bool>> checkClubName(String clubName) async {
    final clubsRef = FirebaseFirestore.instance.collection('clubs');

    final doc = await clubsRef.doc(clubName).get();

    if (doc.exists) {
      return Result.fail(
          error: 'Il nome del circolo è già presente nel database.');
    } else {
      return Result.ok(value: true);
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

  Future<Result<Club>> createClub(String cid, Club newClub) async {
    // Controlla se tutti i campi obbligatori sono validi
    var isValid = newClub.validate(newClub);
    if (!isValid.valid) {
      return Result(valid: false, errors: isValid.errors);
    }

    // Controlla se un membro con l'ID utente specificato esiste già
    final setRole = FirebaseFirestore.instance.collection('clubs').doc(cid);
    final docSnapshot = await setRole.get();

    if (docSnapshot.exists) {
      // Membro con l'ID utente specificato esiste già
      return Result(valid: false, error: "Club già esitente");
    }

    // Crea il documento del membro nel database
    await setRole.set(newClub.toMap());

    var result = await getClub(cid);
    if (!result.hasData) {
      return Result(valid: false, error: "Club non registrato nel database.");
    }

    return result;
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
}
