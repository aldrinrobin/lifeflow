import React, { useState } from 'react';
import { db } from '../firebase';
import { collection, addDoc, serverTimestamp } from 'firebase/firestore'; // ✅ import serverTimestamp

export default function ConsultationForm({ userName, doctorName, department, hospitalName, onAdd }) {
  const [bp, setBp] = useState('');
  const [sugar, setSugar] = useState('');
  const [medicines, setMedicines] = useState('');
  const [tests, setTests] = useState('');
  const [notes, setNotes] = useState('');

  const handleSubmit = async (e) => {
    e.preventDefault();

    try {
      await addDoc(
  collection(db, "users", userId, "consultations"),
  {
    doctorName,
    hospitalName,
    bp,
    sugarLevel: sugar,
    medicines: medicines.split(",").map(m => m.trim()),
    procedures: procedures.split(",").map(p => p.trim()),
    tests: tests.split(",").map(t => t.trim()),
    notes,
    date: serverTimestamp(), // ✅ REAL Firestore timestamp
  }
);


      setBp('');
      setSugar('');
      setMedicines('');
      setTests('');
      setNotes('');

      if (onAdd) onAdd(); // refresh the list
      alert('Consultation added successfully!');
    } catch (error) {
      console.error('Error adding consultation:', error);
      alert('Failed to add consultation.');
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      <h3>Add Consultation for {userName}</h3>
      <input placeholder="BP" value={bp} onChange={e => setBp(e.target.value)} required />
      <input placeholder="Sugar" value={sugar} onChange={e => setSugar(e.target.value)} required />
      <input placeholder="Medicines" value={medicines} onChange={e => setMedicines(e.target.value)} required />
      <input placeholder="Tests" value={tests} onChange={e => setTests(e.target.value)} />
      <textarea placeholder="Notes" value={notes} onChange={e => setNotes(e.target.value)} />
      <button type="submit">Add Consultation</button>
    </form>
  );
}
