import React, { useState } from "react";
import { db } from "../firebase";
import { collection, addDoc } from "firebase/firestore";
import { useParams } from "react-router-dom";

const Office = () => {
  const { hospitalId } = useParams();
  const [name, setName] = useState("");
  const [department, setDepartment] = useState("");
  const [message, setMessage] = useState("");

  const handleAddDoctor = async () => {
    try {
      await addDoc(collection(db, "hospitals", hospitalId, "doctors"), {
        name,
        department,
      });
      setMessage("Doctor added successfully!");
      setName("");
      setDepartment("");
    } catch (err) {
      console.error(err);
      setMessage("Error adding doctor!");
    }
  };

  return (
    <div style={{ padding: 50 }}>
      <h2>Office - Add Doctor</h2>
      <div>
        <input
          type="text"
          placeholder="Doctor Name"
          value={name}
          onChange={(e) => setName(e.target.value)}
        />
      </div>
      <div style={{ marginTop: 10 }}>
        <input
          type="text"
          placeholder="Department"
          value={department}
          onChange={(e) => setDepartment(e.target.value)}
        />
      </div>
      <button onClick={handleAddDoctor} style={{ marginTop: 20 }}>
        Add Doctor
      </button>
      {message && <p>{message}</p>}
    </div>
  );
};

export default Office;
