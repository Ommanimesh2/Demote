// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyBR3ZLJB_qCY0hWBE_-lwSUFZKSHVeiL5U",
  authDomain: "demote-91d58.firebaseapp.com",
  databaseURL: "https://demote-91d58-default-rtdb.firebaseio.com",
  projectId: "demote-91d58",
  storageBucket: "demote-91d58.appspot.com",
  messagingSenderId: "1021231368408",
  appId: "1:1021231368408:web:d0eb88b95a39b0a99f2fad",
  measurementId: "G-8QT865YCMW"
};

// Initialize Firebase
export const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);

