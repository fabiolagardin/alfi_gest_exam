/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
const db = admin.firestore();

exports.registerUser = functions.https.onCall(async (data) => {
  const {email, password} = data;
  console.log(`Email:${email}, Password: ${password}`);
  try {
    const userRecord = await admin.auth().createUser({email, password});
    return {uid: userRecord.uid};
  } catch (error) {
    console.error(error);
    if (error.code === "auth/email-already-exists") {
      return {error: "Utente già registrato con questa email"};
    } else {
      return {
        error: "Si è verificato un errore durante la registrazione dell'utente",
      };
    }
  }
});

exports.deleteUser = functions.https.onCall(async (data) => {
  await admin.auth().deleteUser(data.uid);
  return {
    message: "Utente ${data.uid} eliminato con successo",
  };
});

exports.createMember = functions.https.onCall(async (data, context) => {
  const newMember = data.newMember;
  // Verifica che newMember sia un oggetto e che abbia i campi necessari
  if (typeof newMember !== "object" || !newMember) {
    throw new functions.https.
        HttpsError("invalid-argument", "New member must be an object");
  }
  // Assicurati che newMember abbia un campo memberId
  if (!newMember.memberId) {
    throw new functions.https.
        HttpsError("invalid-argument", "New member must have a memberId");
  }
  const docRef = admin.firestore()
      .collection("members").doc(newMember.memberId);
  try {
    await docRef.set(newMember);
  } catch (error) {
    return {
      error: "Si è verificato un errore durante la creazione della socia*.",
    };
  }
  return {memberId: docRef.id};
});

exports.updateMember = functions.https.onCall(async (data, context) => {
  // Verifica se l'utente è autenticato
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated",
        "The function must be called while authenticated.");
  }
  const memberId = data.memberId;
  const updatedMember = data.updatedMember;
  const memberRef = db.collection("members").doc(memberId);

  try {
    // Aggiorna il documento del membro con i dati forniti
    await memberRef.update(updatedMember);

    return {message: "Socia aggiornata con successo"};
  } catch (error) {
    return {
      error: "Un errore si è verificato durante l'aggiornamento della socia*.",
    };
  }
});

exports.updateProfile = functions.https.onCall(async (data, context) => {
  // Verifica se l'utente è autenticato
  if (!context.auth) {
    throw new functions.https.HttpsError(
        "unauthenticated",
        "Devi essere autenticato per chiamare questa funzione",
    );
  }
  const memberId = data.memberId;
  const updatedMember = data.updatedMember;
  const memberRef = db.collection("members").doc(memberId);
  console.log("updatedMember: ", updatedMember);
  try {
    // Aggiorna il campo idMemberManager del documento del club
    await memberRef.update({
      pronoun: updatedMember.pronoun,
      address: updatedMember.address,
      telephone: updatedMember.telephone,
      email: updatedMember.email,
      updateDate: updatedMember.updateDate,
      updateUser: updatedMember.updateUser,
      profileImageString:
      typeof updatedMember.profileImageString === "undefined" ?
      "" :
      updatedMember.profileImageString,

    });

    return {message: "Profilo aggiornato con successo"};
  } catch (error) {
    console.log("Error: ", error);

    return {
      error: "Un errore si è verificato durante l'aggiornamento del Profilo.",
    };
  }
});

exports.getMember = functions.https.onCall(async (data, context) => {
  const memberId = data.memberId;
  const doc = await db.collection("members").doc(memberId).get();
  if (!doc.exists) {
    return {error: "Socia* non trovata"};
  }
  return doc.data();
});

exports.getAllMembers = functions.https.onCall(async (data, context) => {
  const docs = await db.collection("members").get();
  const members = [];
  docs.forEach((doc) => {
    members.push({id: doc.id, ...doc.data()});
  });
  return members;
});

exports.replaceCard = functions.https.onCall(async (data, context) => {
  // ID del membro da aggiornare
  const memberId = data.memberId;

  // Nuovi valori per numberCard e replaceCardMotivation
  const newNumberCard = data.newNumberCard;
  const newReplaceCardMotivation = data.newReplaceCardMotivation;

  // Riferimento al documento del membro
  const memberRef = db.collection("members").doc(memberId);

  // Aggiorna i campi numberCard e replaceCardMotivation
  try {
    await memberRef.update({
      numberCard: newNumberCard,
      replaceCardMotivation: newReplaceCardMotivation,
    });

    return {result: "Carta sostituita con successo"};
  } catch (error) {
    return {
      error: "Si è verificato un errore durante la sostituzione della carta.",
    };
  }
});

exports.suspendMember = functions.https.onCall(async (data, context) => {
  const memberId = data.memberId;
  const isSuspended = data.isSuspended;
  const memberRef = db.collection("members").doc(memberId);

  try {
    await memberRef.update({
      isSuspended: isSuspended,
    });

    return {result: "Socia* sospesa con successo"};
  } catch (error) {
    return {
      error: "Si è verificato un errore durante la sospensione della socia*.",
    };
  }
});

exports.renewCard = functions.https.onCall(async (data, context) => {
  const memberId = data.memberId;
  const isSuspended = data.isSuspended;
  const expirationDate = data.expirationDate;
  const memberRef = db.collection("members").doc(memberId);

  try {
    await memberRef.update({
      isSuspended: isSuspended,
      expirationDate: expirationDate,
    });

    return {result: "Carta rinnovata con successo"};
  } catch (error) {
    return {
      error: "Si è verificato un errore durante il rinnovo della carta.",
    };
  }
});

exports.refuseMember = functions.https.onCall(async (data, context) => {
  const memberId = data.memberId;
  const isRejected = data.isRejected;
  const memberRef = db.collection("members").doc(memberId);
  try {
    await memberRef.update({
      isRejected: isRejected,
      isSuspended: false,
    });

    return {result: "Socia* rifiutata con successo"};
  } catch (error) {
    return {
      error: "Si è verificato un errore durante il rifiuto della socia*.",
    };
  }
});

exports.setRoleMember = functions.https.onCall(async (data, context) => {
  const memberId = data.memberId;
  const role = data.role;
  const memberRef = db.collection("roles").doc(memberId);

  try {
    await memberRef.update({
      role: role,
    });

    return {result: "Ruolo della socia* modificato con successo"};
  } catch (error) {
    return {
      error:
      "Si è verificato un errore nella modifica del ruolo della socia*.",
    };
  }
});

exports.getSuspendedMembers = functions.https.onCall((data, context) => {
  return admin.firestore().collection("members")
      .where("isSuspended", "==", true)
      .get()
      .then((snapshot) => {
        const members = [];
        snapshot.forEach((doc) => {
          const member = doc.data();
          member.id = doc.id;
          members.push(member);
        });
        return members;
      })
      .catch((error) => {
        console.log(error);
        return {
          error: "Si è verificato un errore nel recupero delle socie* sospese",
        };
      });
});

exports.getRejectedMembers = functions.https.onCall((data, context) => {
  return admin.firestore().collection("members")
      .where("isRejected", "==", true)
      .get()
      .then((snapshot) => {
        const members = [];
        snapshot.forEach((doc) => {
          const member = doc.data();
          member.id = doc.id;
          members.push(member);
        });
        return members;
      })
      .catch((error) => {
        console.log(error);
        return {
          error:
           "Si è verificato un errore nel recupero delle socie* rifiutate",
        };
      });
});

exports.getRoleMember = functions.https.onCall(async (data, context) => {
  const memberId = data.memberId;
  const doc = await admin.firestore().collection("roles").doc(memberId).get();
  if (!doc.exists) {
    return {error: "Ruolo della socia* non trovato"};
  }
  return doc.data();
});

exports.deleteMember = functions.https.onCall(async (data, context) => {
  const memberId = data.memberId;
  await db.collection("members").doc(memberId).delete();
  return {
    message: "Socia* ${memberId} eliminata con successo",
  };
});

exports.createRoleMember = functions.https.onCall(async (data, context) => {
  const newRoleMember = data.newRoleMember;
  console.log("newRoleMember: ", newRoleMember);
  // Verifica che newRoleMember sia un oggetto e che abbia i campi necessari
  if (typeof newRoleMember !== "object" || !newRoleMember) {
    console.log("New role member must be an object: ", newRoleMember);
    throw new functions.https.HttpsError(
        "invalid-argument",
        "New role member must be an object",
    );
  }
  // Assicurati che newRoleMember abbia un campo memberId
  if (!newRoleMember.idUserRole) {
    console.log(
        "New role member must have a memberId: ",
        newRoleMember.idUserRole,
    );
    throw new functions.https.HttpsError(
        "invalid-argument",
        "New role member must have a memberId",
    );
  }
  const docRef = admin
      .firestore()
      .collection("roles")
      .doc(newRoleMember.idUserRole);
  try {
    await docRef.set(newRoleMember);
  } catch (error) {
    return {
      error:
        "Si è verificato un errore durante la creazione del ruolo della socia*",
    };
  }
  return {memberId: docRef.id};
});

exports.createClub = functions.https.onCall(async (data, context) => {
  const newClub = data.newClub;
  // Verifica che newClub sia un oggetto e che abbia i campi necessari
  if (typeof newClub !== "object" || !newClub) {
    return {
      error: "Nuovo circolo deve essere un oggetto",
    };
  }
  // Assicurati che newClub abbia un campo idClub
  if (!newClub.idClub) {
    return {
      error: "Nuovo circolo deve avere un idClub",
    };
  }
  const docRef = admin.firestore().collection("clubs").doc(newClub.idClub);
  try {
    await docRef.set(newClub);
  } catch (error) {
    return {
      error: "Si è verificato un errore durante la creazione del circolo.",
    };
  }
  return {idClub: docRef.id};
});

exports.updateClub = functions.https.onCall(async (data, context) => {
  // Verifica se l'utente è autenticato
  if (!context.auth) {
    throw new functions.https.HttpsError(
        "unauthenticated",
        "Devi essere autenticato per chiamare questa funzione",
    );
  }
  const idClub = data.idClub;
  const updatedClub = data.updatedClub;
  const clubRef = db.collection("clubs").doc(idClub);

  try {
    // Aggiorna il documento del membro con i dati forniti
    await clubRef.update(updatedClub);

    return {message: "Circolo aggiornato con successo"};
  } catch (error) {
    return {
      error: "Un errore si è verificato durante l'aggiornamento del circolo.",
    };
  }
});

exports.updateClubManager = functions.https.onCall(async (data, context) => {
  // Verifica se l'utente è autenticato
  if (!context.auth) {
    throw new functions.https.HttpsError(
        "unauthenticated",
        "Devi essere autenticato per chiamare questa funzione",
    );
  }
  const idClub = data.idClub;
  const idMemberManager = data.idMemberManager;
  const clubRef = db.collection("clubs").doc(idClub);

  try {
    // Aggiorna il campo idMemberManager del documento del club
    await clubRef.update({idMemberManager: idMemberManager});

    return {message: "Circolo aggiornato con successo"};
  } catch (error) {
    return {
      error: "Un errore si è verificato durante l'aggiornamento del circolo.",
    };
  }
});

exports.getClub = functions.https.onCall(async (data, context) => {
  const idClub = data.idClub;
  const doc = await admin.firestore().collection("clubs").doc(idClub).get();
  if (!doc.exists) {
    return {error: "Circolo non trovato"};
  }
  return doc.data();
});
