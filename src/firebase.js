import { initializeApp } from "firebase/app";
import { getAuth } from "firebase/auth";
import { getFirestore } from "firebase/firestore";

const firebaseConfig = {
  apiKey: "AIzaSyDHkLhi_FU_LCYxdNrHQk4g63PEvFkVJGo",
  authDomain: "lifeflow-416bc.firebaseapp.com",
  projectId: "lifeflow-416bc",
  storageBucket: "lifeflow-416bc.firebasestorage.app",
  messagingSenderId: "762633227838",
  appId: "1:762633227838:web:c142044b647c0343bdcb6f"
};

const app = initializeApp(firebaseConfig);
export const auth = getAuth(app);
export const db = getFirestore(app);
