import 'package:alfi_gest/helpers/result.dart';
import 'package:alfi_gest/models/enums.dart';
import 'package:alfi_gest/models/member.dart';
import 'package:alfi_gest/models/user_role.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/services.dart';

class MemberService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Result<Member>> getMember(String uid) async {
    final docRef = _firestore.collection('members').doc(uid);
    final docSnapshot = await docRef.get();

    if (!docSnapshot.exists) {
      return Result(error: "Socio non esistente");
    }

    final data = docSnapshot.data();
    if (data == null) {
      return Result(error: "Dati Socio non esistenti");
    }

    return Result(valid: true, data: Member.fromMap(docSnapshot.id, data));
  }

  Future<Result<List<Member>>> getMembers() async {
    final collectionRef = _firestore.collection('members');
    final querySnapshot = await collectionRef.get();

    final members = <Member>[];
    for (final docSnapshot in querySnapshot.docs) {
      final data = docSnapshot.data();
      if (data.isEmpty) {
        return Result(
            error:
                "Errore durante il recupero dei dati del club: ${docSnapshot.id}");
      }

      final member = Member.fromMap(docSnapshot.id, data);
      members.add(member);
    }

    return Result(valid: true, data: members);
  }

  Future<Result<String>> registerUser(String email, String password) async {
    final HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('registerUser');
    final response = await callable
        .call(<String, dynamic>{'email': email, 'password': password});

    final data = response.data as Map<String, dynamic>;
    if (data.containsKey('uid')) {
      return Result(valid: true, data: data['uid']);
    } else if (data.containsKey('error')) {
      return Result(valid: false, error: data['error']);
    } else {
      return Result(error: "Errore imprevisto durante la registrazione");
    }
  }

  Future<Result<bool>> createMember(String uid, Member newMember) async {
    // Controlla se tutti i campi obbligatori sono validi
    var isValid = newMember.validate(newMember);
    if (!isValid.valid) {
      return Result(valid: false, errors: isValid.errors);
    }
    final functions = FirebaseFunctions.instance;

    final member =
        await functions.httpsCallable('getMember').call({'memberId': uid});
    var existing = member.data as Map<String, dynamic>;
    if (!existing.containsValue("Socia* non trovata")) {
      return Result(valid: false, error: "Socio già esitente");
    }

    // Aggiungi memberId al nuovo membro
    newMember.memberId = uid;

    // Crea un nuovo membro nel database
    final result = await functions
        .httpsCallable('createMember')
        .call({'newMember': newMember.toMap()});
    var data = result.data as Map<String, dynamic>;
    if (data.containsValue(
        "Si è verificato un errore durante la creazione della socia*.")) {
      return Result(
          valid: false,
          error:
              "Si è verificato un errore durante la creazione della socia*.");
    }
    return Result(valid: true, data: true);
  }

  Future<Result<bool>> updateMember(String uid, Member updatedMember) async {
    // Check if all required fields are valid
    var isValid = updatedMember.validate(updatedMember);
    if (!isValid.valid) {
      return Result(valid: false, errors: isValid.errors);
    }

    final functions = FirebaseFunctions.instance;

    final member =
        await functions.httpsCallable('getMember').call({'memberId': uid});
    var existing = member.data as Map<String, dynamic>;
    if (existing.containsValue("Socia* non trovata")) {
      return Result(valid: false, error: "Socia* non trovata");
    }

    // Update the member in the database
    final result = await functions
        .httpsCallable('updateMember')
        .call({'memberId': uid, 'updatedMember': updatedMember.toMap()});

    var data = result.data as Map<String, dynamic>;
    if (data.containsValue(
        "Un errore si è verificato durante l'aggiornamento della socia*.")) {
      return Result(
          valid: false,
          error:
              "Un errore si è verificato durante l'aggiornamento della socia*.");
    }
    return Result(valid: true, data: true);
  }

  Future<Result<bool>> replaceMemberCard(String memberId, String newNumberCard,
      int newReplaceCardMotivation) async {
    HttpsCallable replaceCard =
        FirebaseFunctions.instance.httpsCallable('replaceCard');

    final HttpsCallableResult result = await replaceCard.call(<String, dynamic>{
      'memberId': memberId,
      'newNumberCard': newNumberCard,
      'newReplaceCardMotivation': newReplaceCardMotivation,
    });

    var data = result.data as Map<String, dynamic>;
    if (data.containsValue(
        "Si è verificato un errore durante la sostituzione della carta.")) {
      return Result(
          valid: false,
          error:
              "Si è verificato un errore durante la sostituzione della carta.");
    }
    return Result(valid: true, data: true);
  }

  Future<Result<bool>> renewOrSuspendMember(
      String memberId, bool isSuspened, String expirationDate) async {
    HttpsCallable renewCard =
        FirebaseFunctions.instance.httpsCallable('renewCard');
    HttpsCallable suspendMember =
        FirebaseFunctions.instance.httpsCallable('suspendMember');

    final HttpsCallableResult result = isSuspened
        ? await suspendMember.call(<String, dynamic>{
            'memberId': memberId,
            'isSuspended': isSuspened,
          })
        : await renewCard.call(<String, dynamic>{
            'memberId': memberId,
            'isSuspended': isSuspened,
            'expirationDate': expirationDate,
          });

    var data = result.data as Map<String, dynamic>;
    if (data.containsValue(
        "Si è verificato un errore durante il rinnovo della carta.")) {
      return Result(
          valid: false,
          error:
              "Si è verificato un errore durante la sostituzione della carta.");
    }
    if (data.containsValue(
        "Si è verificato un errore durante la sospensione della socia*.")) {
      return Result(
          valid: false,
          error:
              "Si è verificato un errore durante la sospensione della socia*.");
    }
    return Result(valid: true, data: true);
  }

  Future<Result<Member>> deleteMember(String uid) async {
    // Check if the member exists
    final functions = FirebaseFunctions.instance;
    final deleteUserFunction = functions.httpsCallable('deleteUser');
    final memberResult = await getMember(uid);
    if (!memberResult.isSuccess() || !memberResult.hasData) {
      return Result(valid: false, error: "Socio non esitente");
    }

    // Delete the member's document from the database
    try {
      final response = await deleteUserFunction.call(<String, dynamic>{
        'uid': uid,
      });
      print('Utente eliminato con successo: ${response.data}');
    } catch (e, s) {
      print('Errore durante l\'eliminazione dell\'utente: $e');
      print('Stack trace: $s');
    }
    try {
      await _firestore.collection('members').doc(uid).delete();
    } catch (e) {
      return Result(
          valid: false, error: "Errore durante la cancellazione della socia");
    }

    return Result(valid: true);
  }

  Future<Result<Member>> setRoleMember(String uid, Role role) async {
    // Check if the member exists
    final memberResult = await getMember(uid);
    if (!memberResult.isSuccess() || !memberResult.hasData) {
      return Result(valid: false, error: "Socio non esitente");
    }

    // Create the member's role document in the database
    await _firestore.collection('roles').doc(uid).set(UserRole(
            creationDate: DateTime.now(),
            userCreation: uid,
            updateDate: DateTime.now(),
            updateUser: uid,
            role: role)
        .toMap());

    var result = await getMember(uid);

    return result;
  }

  Future<Result<String>> getMemberRole(String uid) async {
    // Check if the member exists
    final memberResult = await getMember(uid);
    if (!memberResult.isSuccess() || !memberResult.hasData) {
      return Result(valid: false, error: "Socio non esitente");
    }

    // Get the member's role from the database
    final memberDocument = await _firestore.collection('roles').doc(uid).get();
    if (!memberDocument.exists) {
      return Result(valid: false, error: "Ruolo non trovato");
    }

    // Extract the role from the document
    final role = await memberDocument.get("role") as int;
    final roleString = Role.values[role].name;

    return Result(valid: true, data: roleString);
  }
}
