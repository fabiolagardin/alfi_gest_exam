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
  try {
    const userRecord = await admin.auth().createUser({email, password});
    return {uid: userRecord.uid};
  } catch (error) {
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

exports.getMember = functions.https.onCall(async (data, context) => {
  const memberId = data.memberId;
  const doc = await admin.firestore().collection("members").doc(memberId).get();
  if (!doc.exists) {
    return {error: "Socia* non trovata"};
  }
  return doc.data();
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
