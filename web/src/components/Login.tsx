import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { useTheme } from '../context/ThemeContext';
import { useThemeStyles } from '../hooks/useThemeStyles';

interface LoginProps {
  onToggleSignup?: () => void;
}

const Login: React.FC<LoginProps> = ({ onToggleSignup }) => {
  const [formData, setFormData] = useState({
    email: '',
    password: '',
    rememberMe: false
  });
  
  const [showPassword, setShowPassword] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const [errorMessage, setErrorMessage] = useState('');
  
  const navigate = useNavigate();
  const { login } = useAuth();
  const { theme } = useTheme();
  const { createCardStyle, createButtonStyle, createInputStyle, createTextStyle, createHeaderStyle } = useThemeStyles();

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value, type } = e.target;
    
    if (type === 'checkbox') {
      const checkbox = e.target as HTMLInputElement;
      setFormData(prev => ({
        ...prev,
        [name]: checkbox.checked
      }));
    } else {
      setFormData(prev => ({
        ...prev,
        [name]: value
      }));
    }
    
    if (errorMessage) {
      setErrorMessage('');
    }
  };

  const validateForm = (): boolean => {
    const { email, password } = formData;
    
    if (!email || !password) {
      setErrorMessage('Please enter both email and password to continue.');
      return false;
    }
    
    if (!validateEmail(email)) {
      setErrorMessage('Please enter a valid email address.');
      return false;
    }
    
    if (password.length < 6) {
      setErrorMessage('Password must be at least 6 characters long.');
      return false;
    }
    
    return true;
  };

  const validateEmail = (email: string): boolean => {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    if (!validateForm()) {
      return;
    }
    
    setIsLoading(true);
    
    try {
      await login(formData.email, formData.password);
      
      navigate('/dashboard');
      
    } catch (error) {
      setErrorMessage('Invalid email or password. Please try again.');
    } finally {
      setIsLoading(false);
    }
  };

  const togglePasswordVisibility = () => {
    setShowPassword(!showPassword);
  };

  const showForgotPassword = (e: React.MouseEvent) => {
    e.preventDefault();
    alert('Password Reset\n\n' +
          'To reset your password, please contact your system administrator or:\n\n' +
          '1. Visit the BFP IT department\n' +
          '2. Call the helpdesk at (123) 456-7890\n' +
          '3. Email support@bfp.gov.ph\n\n' +
          'For security purposes, password resets must be verified in person.');
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
        <h1 style={{ fontSize: '24px', fontWeight: 'bold', color: '#dc2626', marginBottom: '8px' }}>
          Bureau of Fire Protection
        </h1>
        <p style={{ fontSize: '14px', color: '#6b7280', margin: 0 }}>
          Fire Incident Reporting System
        </p>
      </div>
      
      <div style={{ 
        width: '100%', 
        maxWidth: '768px',
        ...createCardStyle()
      }}>
        <div style={{ padding: '48px', display: 'flex', flexDirection: 'column', justifyContent: 'center' }}>
          <div style={{ marginBottom: '32px', textAlign: 'center' }}>
            <h1 style={{ ...createHeaderStyle(3), marginBottom: '8px', textAlign: 'center' }}>
              Sign In to Your Account
            </h1>
            <p style={{ ...createTextStyle('secondary'), textAlign: 'center' }}>
              Welcome back! Please enter your credentials
            </p>
          </div>

          {errorMessage && (
            <div style={{ 
              backgroundColor: `${theme.colors.error}10`, 
              border: `1px solid ${theme.colors.error}20`, 
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
            <div style={{ marginBottom: theme.spacing.lg }}>
              <label style={{ 
                ...createTextStyle('primary'),
                display: 'block', 
                fontWeight: '500', 
                marginBottom: theme.spacing.sm 
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
                  ...createInputStyle(),
                  width: '100%',
                  boxSizing: 'border-box'
                }}
                placeholder="your.name@bfp.gov.ph"
                required
              />
            </div>

            <div style={{ marginBottom: '20px' }}>
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
                  type={showPassword ? "text" : "password"} 
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
                  placeholder="Enter your password"
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
                  onClick={togglePasswordVisibility}
                >
                  <span className="material-icons" style={{ fontSize: '18px' }}>
                    {showPassword ? 'visibility' : 'visibility_off'}
                  </span>
                </button>
              </div>
            </div>

            <div style={{ 
              display: 'flex', 
              alignItems: 'center', 
              justifyContent: 'space-between', 
              marginBottom: '24px' 
            }}>
              <label style={{ 
                display: 'flex', 
                alignItems: 'center', 
                fontSize: '14px', 
                color: '#374151', 
                cursor: 'pointer' 
              }}>
                <input 
                  type="checkbox" 
                  id="rememberMe" 
                  name="rememberMe" 
                  checked={formData.rememberMe}
                  onChange={handleInputChange}
                  style={{ marginRight: '8px' }}
                />
                <span>Remember me</span>
              </label>
              
              <a 
                href="#" 
                style={{ 
                  fontSize: '14px', 
                  color: '#dc2626', 
                  textDecoration: 'none', 
                  fontWeight: '500' 
                }}
                onClick={showForgotPassword}
              >
                Forgot password?
              </a>
            </div>

            <button 
              type="submit" 
              style={{
                ...createButtonStyle('primary'),
                width: '100%',
                padding: theme.spacing.md,
                marginBottom: theme.spacing.lg,
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                gap: theme.spacing.sm
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
                  Signing In...
                </>
              ) : (
                <>
                  <span className="material-icons" style={{ fontSize: '16px' }}>login</span>
                  Sign In
                </>
              )}
            </button>
          </form>

          <p style={{ textAlign: 'center', fontSize: '14px', color: '#6b7280' }}>
            Don't have an account?{' '}
            <button 
              onClick={onToggleSignup}
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
              Create account
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

export default Login;
