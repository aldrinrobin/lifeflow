import React from 'react';
import DoctorDashboard from './DoctorDashboard';

const HospitalDashboard = ({ hospitalName }) => {
  return (
    <div style={{ padding: '20px' }}>
      <h2>Welcome, {hospitalName}</h2>
      <DoctorDashboard hospitalName={hospitalName} />
    </div>
  );
};

export default HospitalDashboard;
