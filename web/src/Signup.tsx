import React, { useState } from 'react';
import { useAuth } from './context/AuthContext';

interface SignupProps {
  onToggleLogin: () => void;
}

const Signup: React.FC<SignupProps> = ({ onToggleLogin }) => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [name, setName] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const { signup } = useAuth();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');

    if (password !== confirmPassword) {
      setError('Passwords do not match');
      return;
    }

    setLoading(true);

    try {
      await signup(email, password, name);
    } catch (err) {
      setError('Signup failed. Please try again.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div style={{ 
      minHeight: '100vh', 
      display: 'flex', 
      alignItems: 'center', 
      justifyContent: 'center', 
      backgroundColor: '#f9fafb', 
      padding: '48px 16px'
    }}>
      <div style={{ maxWidth: '448px', width: '100%' }}>
        <div style={{ textAlign: 'center', marginBottom: '32px' }}>
          <h2 style={{ 
            marginTop: '24px', 
            fontSize: '30px', 
            fontWeight: '800', 
            color: '#1f2937', 
            margin: '0 0 8px 0' 
          }}>
            Fire Alert System
          </h2>
          <p style={{ 
            marginTop: '8px', 
            textAlign: 'center', 
            fontSize: '14px', 
            color: '#6b7280',
            margin: '0'
          }}>
            Create your account
          </p>
        </div>
        <form style={{ marginTop: '32px' }} onSubmit={handleSubmit}>
          {error && (
            <div style={{
              backgroundColor: '#fef2f2',
              border: '1px solid #f87171',
              color: '#dc2626',
              padding: '12px 16px',
              borderRadius: '8px',
              marginBottom: '24px'
            }}>
              {error}
            </div>
          )}
          <div style={{ marginBottom: '24px' }}>
            <div style={{ marginBottom: '16px' }}>
              <input
                id="name"
                name="name"
                type="text"
                required
                style={{
                  width: '100%',
                  padding: '12px',
                  border: '1px solid #d1d5db',
                  borderRadius: '8px',
                  fontSize: '14px',
                  color: '#1f2937',
                  outline: 'none',
                  boxSizing: 'border-box'
                }}
                placeholder="Full name"
                value={name}
                onChange={(e) => setName(e.target.value)}
              />
            </div>
            <div style={{ marginBottom: '16px' }}>
              <input
                id="email"
                name="email"
                type="email"
                required
                style={{
                  width: '100%',
                  padding: '12px',
                  border: '1px solid #d1d5db',
                  borderRadius: '8px',
                  fontSize: '14px',
                  color: '#1f2937',
                  outline: 'none',
                  boxSizing: 'border-box'
                }}
                placeholder="Email address"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
              />
            </div>
            <div style={{ marginBottom: '16px' }}>
              <input
                id="password"
                name="password"
                type="password"
                required
                style={{
                  width: '100%',
                  padding: '12px',
                  border: '1px solid #d1d5db',
                  borderRadius: '8px',
                  fontSize: '14px',
                  color: '#1f2937',
                  outline: 'none',
                  boxSizing: 'border-box'
                }}
                placeholder="Password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
              />
            </div>
            <div>
              <input
                id="confirmPassword"
                name="confirmPassword"
                type="password"
                required
                style={{
                  width: '100%',
                  padding: '12px',
                  border: '1px solid #d1d5db',
                  borderRadius: '8px',
                  fontSize: '14px',
                  color: '#1f2937',
                  outline: 'none',
                  boxSizing: 'border-box'
                }}
                placeholder="Confirm password"
                value={confirmPassword}
                onChange={(e) => setConfirmPassword(e.target.value)}
              />
            </div>
          </div>

          <div style={{ marginBottom: '24px' }}>
            <button
              type="submit"
              disabled={loading}
              style={{
                width: '100%',
                display: 'flex',
                justifyContent: 'center',
                padding: '12px 16px',
                border: 'none',
                fontSize: '14px',
                fontWeight: '500',
                borderRadius: '8px',
                color: 'white',
                backgroundColor: loading ? '#9ca3af' : '#dc2626',
                cursor: loading ? 'not-allowed' : 'pointer',
                opacity: loading ? 0.5 : 1
              }}
            >
              {loading ? 'Creating account...' : 'Sign up'}
            </button>
          </div>

          <div style={{ textAlign: 'center' }}>
            <button
              type="button"
              onClick={onToggleLogin}
              style={{
                color: '#dc2626',
                fontSize: '14px',
                background: 'none',
                border: 'none',
                cursor: 'pointer',
                textDecoration: 'underline'
              }}
            >
              Already have an account? Sign in
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};

export default Signup;
