import 'dart:io';

import 'package:alfi_gest/core/result.dart';
import 'package:alfi_gest/models/enums.dart';
import 'package:alfi_gest/models/member.dart';
import 'package:alfi_gest/models/user_role.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class MemberService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Result<Member>> getMember(String uid) async {
    if (uid.isEmpty) {
      return Result(error: "UID non valido");
    }

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
                "Errore durante il recupero dei dati dell socia*: ${docSnapshot.id}");
      }

      final member = Member.fromMap(docSnapshot.id, data);
      members.add(member);
    }

    return Result(valid: true, data: members);
  }

  Future<Result<List<Member>>> getSuspendedMembers() async {
    final functions = FirebaseFunctions.instance;

    // Call the getSuspendedMembers function
    final result = await functions.httpsCallable('getSuspendedMembers').call();

    var data = result.data as List<dynamic>;
    if (data.isEmpty) {
      return Result(
          valid: false,
          error: "Si è verificato un errore nel recupero delle socie* sospese");
    }

    // Map the data to a list of Member objects
    final members = data.map((item) {
      return Member.fromMap(item['id'], item as Map<String, dynamic>);
    }).toList();

    return Result(valid: true, data: members);
  }

  Future<Result<String>> validateNewCardNumber(String newCardNumber) async {
    var members = await getMembers();
    var existingCardNumbers =
        members.data!.map((member) => member.numberCard).toSet();
    var valid = existingCardNumbers.contains(newCardNumber);

    if (valid) {
      String firstAvailableCardNumber = "";
      for (int i = 1; i <= 999999; i++) {
        String cardNumber = i.toString().padLeft(6, '0');
        if (!existingCardNumbers.contains(cardNumber)) {
          firstAvailableCardNumber = cardNumber;
          break;
        }
      }
      return Result(
          valid: false,
          message:
              "Il numero della carta è già stato assegnato. Il primo numero disponibile è: $firstAvailableCardNumber",
          data: firstAvailableCardNumber);
    }

    return Result(valid: true, data: newCardNumber);
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

  Future<Result<bool>> updateProfile(String uid, Member updatedMember) async {
    final functions = FirebaseFunctions.instance;

    final member =
        await functions.httpsCallable('getMember').call({'memberId': uid});
    var existing = member.data as Map<String, dynamic>;
    if (existing.containsValue("Socia* non trovata")) {
      return Result(valid: false, error: "Socia* non trovata");
    }

    // Update the member in the database
    final result = await functions
        .httpsCallable('updateProfile')
        .call({'memberId': uid, 'updatedMember': updatedMember.toMap()});

    var data = result.data as Map<String, dynamic>;
    if (data.containsValue(
        "Un errore si è verificato durante l'aggiornamento del Profilo.")) {
      return Result(
          valid: false,
          error:
              "Un errore si è verificato durante l'aggiornamento del Profilo.");
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

  Future<Result<bool>> refuseMember(String memberId, bool isRefuse) async {
    HttpsCallable refuseMember =
        FirebaseFunctions.instance.httpsCallable('refuseMember');

    final HttpsCallableResult result = await refuseMember
        .call(<String, dynamic>{'memberId': memberId, 'isRejected': isRefuse});

    var data = result.data as Map<String, dynamic>;
    if (data.containsValue(
        "Si è verificato un errore durante il rifiuto della socia*.")) {
      return Result(
          valid: false,
          error: "Si è verificato un errore durante il rifiuto della socia*.");
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

  Future<Result<bool>> setRoleMember(String uid, UserRole memberRole) async {
    final functions = FirebaseFunctions.instance;
    // Crea un nuovo membro nel database
    final result = await functions
        .httpsCallable('createRoleMember')
        .call({'newRoleMember': memberRole.toMap()});
    var data = result.data as Map<String, dynamic>;
    if (data.containsValue(
        "Si è verificato un errore durante la creazione del ruolo della socia*")) {
      return Result(
          valid: false,
          error:
              "Si è verificato un errore durante la creazione del ruolo della socia*");
    }

    return Result(valid: true, data: true);
  }

  Future<Result<Role>> getMemberRole(String uid) async {
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
    final roleIndex = await memberDocument.get("role") as int;
    final role = Role.values[roleIndex];

    return Result(valid: true, data: role);
  }

  Future<Result<bool>> uploadImageProfile(
      String filePath, String idMember) async {
    File file = File(filePath);
    try {
      // Crea un riferimento a Firebase Storage
      FirebaseStorage storage = FirebaseStorage.instance;

      // Crea un riferimento alla cartella
      Reference folderRef =
          storage.ref().child('users_image_profile/$idMember');

      // Ottieni la lista dei file nella cartella
      ListResult result = await folderRef.listAll();

      // Elimina tutti i file nella cartella
      for (var fileRef in result.items) {
        await fileRef.delete();
      }

      // Ottieni il nome del file dal percorso del file
      String fileName = path.basename(file.path);

      // Crea un riferimento al file che vuoi caricare
      Reference ref =
          storage.ref().child('users_image_profile/$idMember/$fileName');

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

  Future<Result<String>> getImageProfileUrl(String idMember) async {
    try {
      // Crea un riferimento a Firebase Storage
      FirebaseStorage storage = FirebaseStorage.instance;

      // Crea un riferimento alla cartella
      Reference folderRef =
          storage.ref().child('users_image_profile/$idMember');

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

  Result<String> compareRoleWithSting(String role) {
    if (role == Role.amministratore.name) {
      return Result(valid: true, data: "Amministratore");
    } else if (role == Role.segretariaNazionale.name) {
      return Result(valid: true, data: "Segretaria Nazionale");
    } else if (role == Role.responsabileCircolo.name) {
      return Result(valid: true, data: "Responsabile Circolo");
    } else if (role == Role.socia.name) {
      return Result(valid: true, data: "Socia");
    } else if (role == Role.nonAssegnato.name) {
      return Result(valid: true, data: "Ospite");
    } else {
      return Result(valid: false, error: "Ruolo non valido");
    }
  }
}
