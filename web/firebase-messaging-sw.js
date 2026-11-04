// Shows push notifications while the web app is closed (docs/backend.md,
// "Push notifications"). Registered only by the beta, when someone turns
// notifications on; the demo never loads it.
//
// These values identify the Firebase project and are public: every web
// app ships them. The version matches firebase_core_web's JS SDK.
importScripts("https://www.gstatic.com/firebasejs/13.1.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/13.1.0/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: "AIzaSyBcjIt3Jhk9SzeCTJ31D1Gk1sT0aZ21cwE",
  projectId: "icare-test-d385f",
  messagingSenderId: "432850498203",
  appId: "1:432850498203:web:829d95c1ad199c43e88c3e",
});

// Notification messages are shown by the SDK itself.
firebase.messaging();
