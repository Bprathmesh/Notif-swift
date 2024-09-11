const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendTestNotification = functions.https.onRequest(async (req, res) => {
  try {
    const message = {
      notification: {
        title: 'Test Notification',
        body: 'This is a test notification from Firebase Cloud Functions!',
      },
      topic: 'test_notifications',
    };

    const response = await admin.messaging().send(message);
    console.log('Successfully sent message:', response);
    res.json({success: true, message: 'Notification sent successfully'});
  } catch (error) {
    console.log('Error sending message:', error);
    res.status(500).send(error);
  }
});