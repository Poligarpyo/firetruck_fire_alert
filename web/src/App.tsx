import React, { useState, useEffect } from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider, useAuth } from './context/AuthContext';
import { ThemeProvider } from './context/ThemeContext';
import Login from './components/Login';
import Signup from './components/Signup';
import Layout from './components/Layout';
import Dashboard from './pages/Dashboard';
import LiveMap from './pages/LiveMap';
import Firetrucks from './pages/Firetrucks';
import Incidents from './pages/Incidents';
import Analytics from './pages/Analytics';
import Users from './pages/Users';
import Settings from './pages/Settings';

const AuthenticatedApp: React.FC = () => {
  const { user, login } = useAuth();
  const [showSignup, setShowSignup] = useState(false);
  const [isInitialized, setIsInitialized] = useState(false);

  useEffect(() => {
    const savedUser = localStorage.getItem('firealert_user');
    if (savedUser) {
      try {
        const userData = JSON.parse(savedUser);
        if (userData.email) {
          login(userData.email, 'password');
        }
      } catch (error) {
        console.error('Error parsing saved user data:', error);
        localStorage.removeItem('firealert_user');
      }
    }
    setIsInitialized(true);
  }, []);

  if (!isInitialized) {
    return (
      <div style={{ 
        display: 'flex', 
        justifyContent: 'center', 
        alignItems: 'center', 
        minHeight: '100vh',
        backgroundColor: '#f9fafb'
      }}>
        <div style={{ textAlign: 'center' }}>
          <div style={{ 
            width: '40px', 
            height: '40px', 
            border: '4px solid #dc2626', 
            borderTop: '4px solid transparent', 
            borderRadius: '50%',
            animation: 'spin 1s linear infinite',
            margin: '0 auto 16px'
          }}></div>
          <p style={{ color: '#6b7280', fontSize: '14px' }}>Loading...</p>
        </div>
      </div>
    );
  }

  if (!user) {
    return showSignup ? (
      <Signup onToggleLogin={() => setShowSignup(false)} />
    ) : (
      <Login onToggleSignup={() => setShowSignup(true)} />
    );
  }

  return (
    <Layout>
      <Routes>
        <Route path="/" element={<Navigate to="/dashboard" replace />} />
        <Route path="/dashboard" element={<Dashboard />} />
        <Route path="/livemap" element={<LiveMap />} />
        <Route path="/incident-reports" element={<Incidents />} />
        <Route path="/firetrucks" element={<Firetrucks />} />
        <Route path="/incidents" element={<Incidents />} />
        <Route path="/analytics" element={<Analytics />} />
        <Route path="/users" element={<Users />} />
        <Route path="/settings" element={<Settings />} />
        <Route path="*" element={<Navigate to="/dashboard" replace />} />
      </Routes>
    </Layout>
  );
};

function App() {
  return (
    <>
      <style>{`
        @keyframes spin {
          0% { transform: rotate(0deg); }
          100% { transform: rotate(360deg); }
        }
      `}</style>
      <Router>
        <ThemeProvider>
          <AuthProvider>
            <AuthenticatedApp />
          </AuthProvider>
        </ThemeProvider>
      </Router>
    </>
  );
}

export default App;
