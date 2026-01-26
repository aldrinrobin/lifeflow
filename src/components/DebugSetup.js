import React, { useState } from 'react';
import { doc, setDoc } from 'firebase/firestore';
import { db } from '../firebase'; // Make sure your firebase.js exports 'db'

const DebugSetup = ({ onClose }) => {
  const [hospitalName, setHospitalName] = useState('');
  const [password, setPassword] = useState('');

  const handleAddHospital = async () => {
    if (!hospitalName || !password) {
      alert('Please fill out both fields.');
      return;
    }

    try {
      // Create a document with ID = hospitalName
      await setDoc(doc(db, 'hospitals', hospitalName), {
        name: hospitalName,
        password: password,
      });
      alert('Hospital added successfully!');
      setHospitalName('');
      setPassword('');
    } catch (err) {
      console.error('Error adding hospital:', err);
      alert('Failed to add hospital. Check console.');
    }
  };

  return (
    <div style={styles.container}>
      <h2>Debug: Add Hospital</h2>
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
      <button onClick={handleAddHospital} style={styles.button}>Add Hospital</button>
      <button onClick={onClose} style={{ ...styles.button, marginTop: '10px', background: '#777' }}>
        Close Debug
      </button>
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

export default DebugSetup;
