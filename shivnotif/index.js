/* eslint-disable max-len */
const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendPersonalizedNotification = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated", "User must be authenticated to send notifications.");
  }

  const userId = data.userId;

  try {
    const userDoc = await admin.firestore().collection("users").doc(userId).get();
    const userData = userDoc.data();

    if (!userData) {
      throw new functions.https.HttpsError("not-found", "User not found.");
    }

    const title = `Hello ${userData.name}!`;
    const body = "This is a personalized notification just for you.";

    const message = {
      notification: {title, body},
      token: userData.fcmToken,
    };

    await admin.messaging().send(message);

    await admin.firestore().collection("users").doc(userId).collection("notifications").add({
      title,
      body,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
    });

    return {success: true, message: "Personalized notification sent successfully"};
  } catch (error) {
    console.error("Error sending personalized notification:", error);
    throw new functions.https.HttpsError("internal", "Error sending notification", error);
  }
});

exports.sendPromotionalNotification = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated", "User must be authenticated to send notifications.");
  }

  const userId = data.userId;

  try {
    const userDoc = await admin.firestore().collection("users").doc(userId).get();
    const userData = userDoc.data();

    if (!userData || !userData.receivePromotions) {
      return {success: false, message: "User does not want to receive promotions"};
    }

    const title = "Special Offer!";
    const body = `${userData.name}, check out our latest promotion just for you!`;

    const message = {
      notification: {title, body},
      token: userData.fcmToken,
    };

    await admin.messaging().send(message);

    await admin.firestore().collection("users").doc(userId).collection("notifications").add({
      title,
      body,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
    });

    return {success: true, message: "Promotional notification sent successfully"};
  } catch (error) {
    console.error("Error sending promotional notification:", error);
    throw new functions.https.HttpsError("internal", "Error sending notification", error);
  }
});

exports.sendUpdateNotification = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated", "User must be authenticated to send notifications.");
  }

  const userId = data.userId;

  try {
    const userDoc = await admin.firestore().collection("users").doc(userId).get();
    const userData = userDoc.data();

    if (!userData || !userData.receiveUpdates) {
      return {success: false, message: "User does not want to receive updates"};
    }

    const title = "New Update Available";
    const body = `${userData.name}, we have some exciting updates for you!`;

    const message = {
      notification: {title, body},
      token: userData.fcmToken,
    };

    await admin.messaging().send(message);

    await admin.firestore().collection("users").doc(userId).collection("notifications").add({
      title,
      body,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
    });

    return {success: true, message: "Update notification sent successfully"};
  } catch (error) {
    console.error("Error sending update notification:", error);
    throw new functions.https.HttpsError("internal", "Error sending notification", error);
  }
});
