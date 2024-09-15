const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendNotificationToUser = functions.https.onCall(async (data, context) => {
  const { userId, title, body } = data;
  
  try {
    const user = await admin.firestore().collection('users').doc(userId).get();
    const fcmToken = user.data().fcmToken;

    if (!fcmToken) {
      throw new functions.https.HttpsError('not-found', 'FCM token not found for user');
    }

    const message = {
      notification: {
        title: title,
        body: body,
      },
      token: fcmToken,
    };

    const response = await admin.messaging().send(message);
    console.log('Successfully sent message:', response);
    return { success: true };
  } catch (error) {
    console.error('Error sending message:', error);
    throw new functions.https.HttpsError('internal', 'Error sending notification');
  }
});