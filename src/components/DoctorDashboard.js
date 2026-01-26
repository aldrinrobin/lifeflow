import { useState } from "react";
import { collection, query, where, getDocs, addDoc } from "firebase/firestore";
import { db, auth } from "../firebase";

function DoctorDashboard({ hospitalName }) {
  // hospitalName is passed from login
  const [searchName, setSearchName] = useState("");
  const [userResults, setUserResults] = useState([]);
  const [selectedUser, setSelectedUser] = useState(null);
  const [consultationData, setConsultationData] = useState({
    doctorName: "",
    bp: "",
    sugarLevel: "",
    medicines: "",
    tests: "",
    procedures: "",
  });

  // Search users by name
  const handleSearch = async () => {
    if (!searchName) return alert("Enter a name to search");

    const q = query(collection(db, "users"), where("name", "==", searchName));
    const snapshot = await getDocs(q);
    const results = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
    setUserResults(results);
  };

  // Handle input changes in consultation form
  const handleChange = (e) => {
    setConsultationData(prev => ({
      ...prev,
      [e.target.name]: e.target.value
    }));
  };

  // Add consultation
  const addConsultation = async () => {
    if (!selectedUser) return alert("Select a user first");
    if (!consultationData.doctorName) return alert("Enter doctor name");

    try {
      const consultationsRef = collection(db, "users", selectedUser.id, "consultations");
      await addDoc(consultationsRef, {
        doctorName: consultationData.doctorName,
        hospitalName: hospitalName || "Unknown Hospital", // fallback
        date: new Date().toISOString(), // system date and time
        bp: consultationData.bp,
        sugarLevel: consultationData.sugarLevel,
        medicines: consultationData.medicines.split(",").map(m => m.trim()), 
        tests: consultationData.tests.split(",").map(t => t.trim()), 
        procedures: consultationData.procedures.split(",").map(p => p.trim()), 
      });

      alert("Consultation added successfully!");
      setConsultationData({
        doctorName: "",
        bp: "",
        sugarLevel: "",
        medicines: "",
        tests: "",
        procedures: "",
      });
    } catch (err) {
      console.error(err);
      alert("Failed to add consultation");
    }
  };

  return (
    <div style={{ padding: "20px" }}>
      <h2>Doctor Dashboard - {hospitalName || "Unknown Hospital"}</h2>

      {/* Search User */}
      <div style={{ marginBottom: "20px" }}>
        <input
          type="text"
          value={searchName}
          placeholder="Search patient by name"
          onChange={(e) => setSearchName(e.target.value)}
        />
        <button onClick={handleSearch}>Search</button>
      </div>

      {/* Search Results */}
      {userResults.map(user => (
        <div key={user.id} style={{ border: "1px solid #ccc", padding: "10px", marginBottom: "10px" }}>
          <strong>{user.name}</strong> ({user.blood_group})
          <button onClick={() => setSelectedUser(user)} style={{ marginLeft: "10px" }}>
            Select
          </button>
        </div>
      ))}

      {/* Consultation Form */}
      {selectedUser && (
        <div style={{ border: "1px solid #000", padding: "15px", marginTop: "20px" }}>
          <h3>Add Consultation for {selectedUser.name}</h3>
          <input
            type="text"
            name="doctorName"
            placeholder="Doctor Name"
            value={consultationData.doctorName}
            onChange={handleChange}
          /><br /><br />
          <input
            type="text"
            name="bp"
            placeholder="Blood Pressure"
            value={consultationData.bp}
            onChange={handleChange}
          /><br /><br />
          <input
            type="text"
            name="sugarLevel"
            placeholder="Sugar Level"
            value={consultationData.sugarLevel}
            onChange={handleChange}
          /><br /><br />
          <input
            type="text"
            name="medicines"
            placeholder="Medicines (comma separated)"
            value={consultationData.medicines}
            onChange={handleChange}
          /><br /><br />
          <input
            type="text"
            name="tests"
            placeholder="Tests Conducted (comma separated)"
            value={consultationData.tests}
            onChange={handleChange}
          /><br /><br />
          <input
            type="text"
            name="procedures"
            placeholder="Procedures (comma separated)"
            value={consultationData.procedures}
            onChange={handleChange}
          /><br /><br />
          <button onClick={addConsultation}>Add Consultation</button>
        </div>
      )}
    </div>
  );
}

export default DoctorDashboard;
