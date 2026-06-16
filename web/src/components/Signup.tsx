import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { useTheme } from '../context/ThemeContext';
import { useThemeStyles } from '../hooks/useThemeStyles';

interface SignupProps {
  onToggleLogin?: () => void;
}

const Signup: React.FC<SignupProps> = ({ onToggleLogin }) => {
  const [formData, setFormData] = useState({
    fullName: '',
    email: '',
    phoneNumber: '',
    role: '',
    station: '',
    password: '',
    confirmPassword: '',
    agreeTerms: false
  });
  
  const [showPassword, setShowPassword] = useState({
    password: false,
    confirmPassword: false
  });
  
  const [isLoading, setIsLoading] = useState(false);
  const [errorMessage, setErrorMessage] = useState('');
  
  const navigate = useNavigate();
  const { signup } = useAuth();
  const { theme } = useTheme();
  const { createCardStyle, createButtonStyle, createInputStyle, createTextStyle, createHeaderStyle } = useThemeStyles();

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>) => {
    const { name, value, type } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: type === 'checkbox' ? (e.target as HTMLInputElement).checked : value
    }));
  };

  const togglePasswordVisibility = (field: 'password' | 'confirmPassword') => {
    setShowPassword(prev => ({
      ...prev,
      [field]: !prev[field]
    }));
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setErrorMessage('');

    if (formData.password !== formData.confirmPassword) {
      setErrorMessage('Passwords do not match');
      return;
    }

    if (formData.password.length < 6) {
      setErrorMessage('Password must be at least 6 characters long');
      return;
    }

    if (!formData.agreeTerms) {
      setErrorMessage('You must agree to terms and conditions');
      return;
    }

    setIsLoading(true);

    try {
      await signup(formData.email, formData.password, formData.fullName);
      
      navigate('/dashboard');
    } catch (error) {
      setErrorMessage('Registration failed. Please try again.');
    } finally {
      setIsLoading(false);
    }
  };

  const showTerms = (e: React.MouseEvent) => {
    e.preventDefault();
    alert('Terms and Conditions\n\n' +
          '1. Use this system only for official BFP business\n' +
          '2. Maintain confidentiality of all incident data\n' +
          '3. Report all fire incidents accurately and promptly\n' +
          '4. Follow proper protocols for emergency response\n' +
          '5. Respect privacy of individuals involved in incidents\n\n' +
          'Violation of these terms may result in disciplinary action.');
  };

  const showPrivacy = (e: React.MouseEvent) => {
    e.preventDefault();
    alert('Privacy Policy\n\n' +
          'BFP is committed to protecting your privacy:\n\n' +
          '• Personal information is collected only for official purposes\n' +
          '• Data is stored securely and accessed only by authorized personnel\n' +
          '• Information is shared only as required by law or emergency response\n' +
          '• You have the right to access and correct your personal data\n' +
          '• Data retention follows government regulations\n\n' +
          'For privacy concerns, contact privacy@bfp.gov.ph');
  };

  return (
    <div style={{ 
      minHeight: '100vh', 
      backgroundColor: theme.colors.background, 
      display: 'flex', 
      flexDirection: 'column', 
      alignItems: 'center', 
      justifyContent: 'center', 
      padding: '20px',
      fontFamily: theme.fonts.primary
    }}>
      
      <div style={{ textAlign: 'center', marginBottom: '32px' }}>
        <div style={{ width: '64px', height: '64px', display: 'flex', alignItems: 'center', justifyContent: 'center', margin: '0 auto 16px' }}>
          <img 
            src="/52e5494a-bfed-4c18-8508-b030d78fe658.png" 
            alt="FireAlert System Logo" 
            style={{ width: '64px', height: '64px', objectFit: 'contain' }}
          />
        </div>
        <h1 style={{ fontSize: '24px', fontWeight: 'bold', color: theme.colors.primary, marginBottom: '8px' }}>
          Bureau of Fire Protection
        </h1>
        <p style={{ ...createTextStyle('secondary'), margin: 0 }}>
          Fire Incident Reporting System
        </p>
      </div>
      
      <div style={{ 
        width: '100%', 
        maxWidth: '768px', 
        backgroundColor: 'white', 
        borderRadius: '16px', 
        boxShadow: '0 1px 3px rgba(0, 0, 0, 0.1)',
        overflow: 'hidden'
      }}>
        <div style={{ padding: '48px', display: 'flex', flexDirection: 'column', justifyContent: 'center' }}>
          <div style={{ marginBottom: '32px', textAlign: 'center' }}>
            <h1 style={{ ...createHeaderStyle(3), marginBottom: '8px', textAlign: 'center' }}>
              Create Your Account
            </h1>
            <p style={{ ...createTextStyle('secondary'), textAlign: 'center' }}>
              Join the BFP Fire Incident Reporting System
            </p>
          </div>

          {errorMessage && (
            <div style={{ 
              backgroundColor: `${theme.colors.error}10`, 
              border: `1px solid ${theme.colors.error}30`, 
              color: theme.colors.error, 
              padding: theme.spacing.md, 
              borderRadius: theme.borderRadius.md, 
              marginBottom: theme.spacing.lg, 
              fontSize: '14px'
            }}>
              {errorMessage}
            </div>
          )}

          <form onSubmit={handleSubmit}>
            <div style={{ display: 'flex', gap: '16px', marginBottom: '20px' }}>
              <div style={{ flex: 1, marginBottom: 0 }}>
                <label style={{ 
                  ...createTextStyle('primary'),
                  display: 'block', 
                  fontWeight: '500', 
                  marginBottom: theme.spacing.sm 
                }} htmlFor="fullName">
                  Full Name *
                </label>
                <input 
                  type="text" 
                  id="fullName" 
                  name="fullName" 
                  value={formData.fullName}
                  onChange={handleInputChange}
                  style={{
                    ...createInputStyle(),
                    width: '100%',
                    boxSizing: 'border-box'
                  }}
                  placeholder="Enter your full name"
                  required
                />
              </div>

              <div style={{ flex: 1, marginBottom: 0 }}>
                <label style={{ 
                  display: 'block', 
                  fontSize: '14px', 
                  fontWeight: '500', 
                  color: '#374151', 
                  marginBottom: '8px' 
                }} htmlFor="email">
                  Email Address *
                </label>
                <input 
                  type="email" 
                  id="email" 
                  name="email" 
                  value={formData.email}
                  onChange={handleInputChange}
                  style={{
                    width: '100%',
                    padding: '12px 16px',
                    border: '1px solid #d1d5db',
                    borderRadius: '8px',
                    fontSize: '14px',
                    outline: 'none',
                    backgroundColor: '#f9fafb',
                    boxSizing: 'border-box'
                  }}
                  placeholder="your.name@bfp.gov.ph"
                  required
                />
              </div>
            </div>

            <div style={{ display: 'flex', gap: '16px', marginBottom: '20px' }}>
              <div style={{ flex: 1, marginBottom: 0 }}>
                <label style={{ 
                  display: 'block', 
                  fontSize: '14px', 
                  fontWeight: '500', 
                  color: '#374151', 
                  marginBottom: '8px' 
                }} htmlFor="phoneNumber">
                  Phone Number
                </label>
                <input 
                  type="tel" 
                  id="phoneNumber" 
                  name="phoneNumber" 
                  value={formData.phoneNumber}
                  onChange={handleInputChange}
                  style={{
                    width: '100%',
                    padding: '12px 16px',
                    border: '1px solid #d1d5db',
                    borderRadius: '8px',
                    fontSize: '14px',
                    outline: 'none',
                    backgroundColor: '#f9fafb',
                    boxSizing: 'border-box'
                  }}
                  placeholder="+63 917 123 4567"
                />
              </div>

              <div style={{ flex: 1, marginBottom: 0 }}>
                <label style={{ 
                  display: 'block', 
                  fontSize: '14px', 
                  fontWeight: '500', 
                  color: '#374151', 
                  marginBottom: '8px' 
                }} htmlFor="role">
                  Role *
                </label>
                <select 
                  id="role" 
                  name="role" 
                  value={formData.role}
                  onChange={handleInputChange}
                  style={{
                    width: '100%',
                    padding: '12px 16px',
                    border: '1px solid #d1d5db',
                    borderRadius: '8px',
                    fontSize: '14px',
                    outline: 'none',
                    backgroundColor: '#f9fafb',
                    boxSizing: 'border-box'
                  }}
                  required
                >
                  <option value="">Select your role</option>
                  <option value="firefighter">Firefighter</option>
                  <option value="dispatcher">Dispatcher</option>
                  <option value="admin">Admin</option>
                </select>
              </div>
            </div>

            <div style={{ marginBottom: '20px' }}>
              <label style={{ 
                display: 'block', 
                fontSize: '14px', 
                fontWeight: '500', 
                color: '#374151', 
                marginBottom: '8px' 
              }} htmlFor="station">
                Station Assigned *
              </label>
              <select 
                id="station" 
                name="station" 
                value={formData.station}
                onChange={handleInputChange}
                style={{
                  width: '100%',
                  padding: '12px 16px',
                  border: '1px solid #d1d5db',
                  borderRadius: '8px',
                  fontSize: '14px',
                  outline: 'none',
                  backgroundColor: '#f9fafb',
                  boxSizing: 'border-box'
                }}
                required
              >
                <option value="">Select your station</option>
                <option value="puerto-princesa">1-Puerto Princesa City</option>
                <option value="bancao-bancao">2- Barangay Bancao Bancao</option>
              </select>
            </div>

            <div style={{ display: 'flex', gap: '16px', marginBottom: '20px' }}>
              <div style={{ flex: 1, marginBottom: 0 }}>
                <label style={{ 
                  display: 'block', 
                  fontSize: '14px', 
                  fontWeight: '500', 
                  color: '#374151', 
                  marginBottom: '8px' 
                }} htmlFor="password">
                  Password *
                </label>
                <div style={{ position: 'relative', display: 'flex', alignItems: 'center', width: '100%' }}>
                  <input 
                    type={showPassword.password ? "text" : "password"} 
                    id="password" 
                    name="password" 
                    value={formData.password}
                    onChange={handleInputChange}
                    style={{
                      width: '100%',
                      padding: '12px 16px',
                      paddingRight: '48px',
                      border: '1px solid #d1d5db',
                      borderRadius: '8px',
                      fontSize: '14px',
                      outline: 'none',
                      backgroundColor: '#f9fafb',
                      boxSizing: 'border-box'
                    }}
                    placeholder="At least 6 character"
                    required
                  />
                  <button 
                    type="button" 
                    style={{
                      position: 'absolute',
                      right: '12px',
                      backgroundColor: 'transparent',
                      border: 'none',
                      cursor: 'pointer',
                      padding: '4px',
                      borderRadius: '4px',
                      display: 'flex',
                      alignItems: 'center',
                      justifyContent: 'center',
                      color: '#6b7280'
                    }}
                    onClick={() => togglePasswordVisibility('password')}
                  >
                    <span className="material-icons" style={{ fontSize: '18px' }}>
                      {showPassword.password ? 'visibility' : 'visibility_off'}
                    </span>
                  </button>
                </div>
              </div>

              <div style={{ flex: 1, marginBottom: 0 }}>
                <label style={{ 
                  display: 'block', 
                  fontSize: '14px', 
                  fontWeight: '500', 
                  color: '#374151', 
                  marginBottom: '8px' 
                }} htmlFor="confirmPassword">
                  Confirm Password *
                </label>
                <div style={{ position: 'relative', display: 'flex', alignItems: 'center', width: '100%' }}>
                  <input 
                    type={showPassword.confirmPassword ? "text" : "password"} 
                    id="confirmPassword" 
                    name="confirmPassword" 
                    value={formData.confirmPassword}
                    onChange={handleInputChange}
                    style={{
                      width: '100%',
                      padding: '12px 16px',
                      paddingRight: '48px',
                      border: '1px solid #d1d5db',
                      borderRadius: '8px',
                      fontSize: '14px',
                      outline: 'none',
                      backgroundColor: '#f9fafb',
                      boxSizing: 'border-box'
                    }}
                    placeholder="Re-enter password"
                    required
                  />
                  <button 
                    type="button" 
                    style={{
                      position: 'absolute',
                      right: '12px',
                      backgroundColor: 'transparent',
                      border: 'none',
                      cursor: 'pointer',
                      padding: '4px',
                      borderRadius: '4px',
                      display: 'flex',
                      alignItems: 'center',
                      justifyContent: 'center',
                      color: '#6b7280'
                    }}
                    onClick={() => togglePasswordVisibility('confirmPassword')}
                  >
                    <span className="material-icons" style={{ fontSize: '18px' }}>
                      {showPassword.confirmPassword ? 'visibility' : 'visibility_off'}
                    </span>
                  </button>
                </div>
              </div>
            </div>

            <div style={{ 
              display: 'flex', 
              alignItems: 'flex-start', 
              marginBottom: '24px' 
            }}>
              <input 
                type="checkbox" 
                id="agreeTerms" 
                name="agreeTerms" 
                checked={formData.agreeTerms}
                onChange={handleInputChange}
                style={{ marginRight: '8px', marginTop: '2px' }}
                required
              />
              <label style={{ 
                fontSize: '14px', 
                color: '#374151', 
                cursor: 'pointer',
                lineHeight: '1.4'
              }} htmlFor="agreeTerms">
                I agree to the <a href="#" style={{ color: '#dc2626', textDecoration: 'none' }} onClick={showTerms}>Terms and Conditions</a> and <a href="#" style={{ color: '#dc2626', textDecoration: 'none' }} onClick={showPrivacy}>Privacy Policy</a>
              </label>
            </div>

            <button 
              type="submit" 
              style={{
                width: '100%',
                padding: '12px',
                backgroundColor: '#dc2626',
                color: 'white',
                border: 'none',
                borderRadius: '8px',
                fontSize: '14px',
                fontWeight: '600',
                cursor: 'pointer',
                marginBottom: '24px',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                gap: '8px'
              }} 
              disabled={isLoading}
            >
              {isLoading ? (
                <>
                  <div style={{ 
                    width: '16px', 
                    height: '16px', 
                    border: '2px solid white', 
                    borderTop: '2px solid transparent', 
                    borderRadius: '50%',
                    animation: 'spin 1s linear infinite'
                  }}></div>
                  Creating Account...
                </>
              ) : (
                <>
                  <span className="material-icons" style={{ fontSize: '16px' }}>person_add</span>
                  Create Account
                </>
              )}
            </button>
          </form>

          <p style={{ textAlign: 'center', fontSize: '14px', color: '#6b7280' }}>
            Already have an account?{' '}
            <button 
              onClick={onToggleLogin}
              style={{ 
                color: '#dc2626', 
                textDecoration: 'none', 
                fontWeight: '600', 
                background: 'none',
                border: 'none',
                cursor: 'pointer',
                padding: 0
              }}
            >
              Sign in
            </button>
          </p>
        </div>
      </div>

      <footer style={{ textAlign: 'center', padding: '24px', color: '#6b7280', fontSize: '14px', marginTop: '32px' }}>
        <p style={{ margin: 0 }}>&copy; 2024 Bureau of Fire Protection. All rights reserved.</p>
      </footer>

      <style>{`
        @keyframes spin {
          0% { transform: rotate(0deg); }
          100% { transform: rotate(360deg); }
        }
      `}</style>
    </div>
  );
};

export default Signup;
