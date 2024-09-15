importScripts("https://www.gstatic.com/firebasejs/9.22.1/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.22.1/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: "AIzaSyDKWyD0KXnLBr6jWrPkyMTdEo5GyliNFRQ",
  authDomain: "pbrathmesh.firebaseapp.com",
  projectId: "pbrathmesh",
  storageBucket: "pbrathmesh.appspot.com",
  messagingSenderId: "292196485875",
  appId: "1:292196485875:web:4d5675b78b750e51d68586",
  measurementId: "G-64CRKYSM96"
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  console.log('Received background message: ', payload);
  // Customize notification here
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});