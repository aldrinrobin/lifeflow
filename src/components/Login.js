import React, { useState } from 'react';
import { collection, query, where, getDocs } from 'firebase/firestore';
import { db } from '../firebase';
import DebugSetup from './DebugSetup';

const Login = ({ onLogin }) => {
  const [hospitalName, setHospitalName] = useState('');
  const [password, setPassword] = useState('');
  const [showDebug, setShowDebug] = useState(false);

  const SECRET_DEBUG_PASSWORD = 'sixseven';

  const handleLogin = async () => {
    // Debug mode
    if (password === SECRET_DEBUG_PASSWORD) {
      setShowDebug(true);
      return;
    }

    if (!hospitalName || !password) {
      alert('Please fill out both fields.');
      return;
    }

    try {
      console.log('Checking login for:', hospitalName);

      const hospitalsRef = collection(db, 'hospitals');
      const q = query(
        hospitalsRef,
        where('name', '==', hospitalName),
        where('password', '==', password)
      );

      const querySnapshot = await getDocs(q);

      if (!querySnapshot.empty) {
        // Login successful
        console.log('QuerySnapshot:', querySnapshot.docs.map(doc => doc.data()));
        alert('Login successful!');

        // Safe call to onLogin
        if (onLogin && typeof onLogin === 'function') {
          onLogin(hospitalName); // Pass the hospital name
        }
      } else {
        console.warn('No matching hospital found.');
        alert('Login failed. Hospital name or password is incorrect.');
      }
    } catch (err) {
      console.error('Login error caught:', err);
      alert('Login failed due to an error. Check console for details.');
    }
  };

  if (showDebug) {
    return <DebugSetup onClose={() => setShowDebug(false)} />;
  }

  return (
    <div style={styles.container}>
      <h2>Hospital Login</h2>
      <input
        type="text"
        placeholder="Hospital Name"
        value={hospitalName}
        onChange={(e) => setHospitalName(e.target.value)}
        style={styles.input}
      />
      <input
        type="password"
        placeholder="Password"
        value={password}
        onChange={(e) => setPassword(e.target.value)}
        style={styles.input}
      />
      <button onClick={handleLogin} style={styles.button}>Login</button>
    </div>
  );
};

const styles = {
  container: {
    display: 'flex',
    flexDirection: 'column',
    justifyContent: 'center',
    alignItems: 'center',
    height: '100vh',
    background: '#f5f5f5',
  },
  input: {
    marginBottom: '15px',
    padding: '10px',
    width: '250px',
    fontSize: '16px',
    borderRadius: '5px',
    border: '1px solid #ccc',
  },
  button: {
    padding: '10px 20px',
    fontSize: '16px',
    borderRadius: '5px',
    border: 'none',
    background: '#007bff',
    color: '#fff',
    cursor: 'pointer',
  },
};

export default Login;
