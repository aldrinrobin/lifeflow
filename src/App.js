import React, { useState } from 'react';
import Login from './components/Login';
import HospitalDashboard from './components/HospitalDashboard';

function App() {
  const [hospital, setHospital] = useState(null); // null = not logged in

  const handleLogin = (hospitalName) => {
    // This will trigger showing the HospitalDashboard
    setHospital(hospitalName);
  };

  return (
    <div>
      {hospital ? (
        <HospitalDashboard hospitalName={hospital} />
      ) : (
        <Login onLogin={handleLogin} />
      )}
    </div>
  );
}

export default App;
