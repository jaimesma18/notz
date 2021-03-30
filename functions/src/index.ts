import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
admin.initializeApp();
// Start writing Firebase Functions
// https://firebase.google.com/docs/functions/typescript

export const helloWorld = functions.https.onRequest((request, response) => {
  functions.logger.info("Hello logs!", {structuredData: true});
  response.send("Hello from Firebasem!");
});

export const createUser = functions.https.onCall((data) => {
  return admin.auth().createUser({
    email: data.email,
    password: data.password,
    disabled: false,
  }).then(function(userRecord) {
    // See the UserRecord reference doc for the contents of userRecord.
    console.log("Successfully created new user:", userRecord.uid);
    return userRecord.uid;
  })
      .catch(function(error) {
        console.log("Error creating new user:", error);
      });
});

export const enableDisableUser = functions.https.onCall((data) => {
  admin.auth().updateUser(data.uid, {
    disabled: data.disabled,
  }).then((userRecord) => {
    const email=userRecord.email;
    const statsDocumentReference = admin.firestore().doc("users/"+email);
    return statsDocumentReference.update({disabled: data.disabled});
    // See the UserRecord reference doc for the contents of userRecord.
    // console.log("Successfully updated user", userRecord.toJSON());
    // console.log(email);
  })
      .catch((error) => {
        console.log("Error updating user:", error);
      });
});
