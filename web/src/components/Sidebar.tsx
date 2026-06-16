import React, { useState, useEffect } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { useThemeStyles } from '../hooks/useThemeStyles';

interface SidebarProps {
  className?: string;
}

interface UserData {
  fullName?: string;
  email?: string;
  role?: 'firefighter' | 'dispatcher' | 'admin';
}

const Sidebar: React.FC<SidebarProps> = ({ className = '' }) => {
  const [userData, setUserData] = useState<UserData | null>(null);
  const [activeNav, setActiveNav] = useState('dashboard');
  const [isTransitioning, setIsTransitioning] = useState(false);
  const navigate = useNavigate();
  const location = useLocation();
  const { logout } = useAuth();
  const { theme, createCardStyle, createTextStyle, createButtonStyle } = useThemeStyles();

  const navItems = [
    { id: 'dashboard', label: 'Dashboard', icon: 'dashboard' },
    { id: 'livemap', label: 'Live Map', icon: 'map' },
    { id: 'incidents', label: 'Incidents Reports', icon: 'description' },
    { id: 'firetrucks', label: 'Fire Trucks', icon: 'fire_truck' },
    { id: 'analytics', label: 'Analytics', icon: 'analytics' },
    { id: 'users', label: 'Users', icon: 'people' },
    { id: 'settings', label: 'Settings', icon: 'settings' },
  ];

  useEffect(() => {
    loadUserData();
    const currentPath = location.pathname.replace('/', '');
    if (currentPath && navItems.find(item => item.id === currentPath)) {
      setActiveNav(currentPath);
    } else {
      setActiveNav('dashboard');
    }
  }, [location.pathname]);

  const loadUserData = () => {
    const savedUserData = localStorage.getItem('firealert_user');
    if (savedUserData) {
      try {
        const user = JSON.parse(savedUserData);
        setUserData(user);
      } catch (error) {
        console.error('Error parsing user data:', error);
      }
    }
  };

  const getCurrentPage = (): string => {
    const path = location.pathname;
    
    const pageMap: { [key: string]: string } = {
      '/dashboard': 'dashboard',
      '/livemap': 'live-map',
      '/incidents': 'incidents',
      '/firetrucks': 'firetrucks',
      '/analytics': 'analytics',
      '/users': 'users',
      '/settings': 'settings'
    };
    
    for (const [route, page] of Object.entries(pageMap)) {
      if (path === route || path.startsWith(route + '/')) {
        return page;
      }
    }
    
    return 'dashboard';
  };

  const isActive = (page: string): boolean => {
    return getCurrentPage() === page;
  };

  const handleNavClick = (navId: string) => {
    setIsTransitioning(true);
    setActiveNav(navId);
    
    setTimeout(() => {
      navigate(`/${navId}`);
      setIsTransitioning(false);
    }, 150);
  };

  const handleLogout = () => {
    logout();
    navigate('/');
  };

  return (
    <>
      <style>{`
        .sidebar-custom-logo {
          transition: all 0.3s ease;
        }
        
        .sidebar-nav-item {
          position: relative;
          overflow: hidden;
        }
        
        .sidebar-nav-item:hover {
          transform: translateX(2px);
        }
        
        .sidebar-nav-item.active {
          transform: translateX(4px);
        }
        
        .no-transition * {
          transition: none !important;
        }
        
        .sidebar-user-avatar {
          width: 40px;
          height: 40px;
          border-radius: 50%;
          background: linear-gradient(135deg, #dc2626 0%, #ef4444 100%);
          display: flex;
          align-items: center;
          justify-content: center;
          font-weight: 600;
          color: white;
          font-size: 16px;
          box-shadow: 0 2px 4px rgba(220, 38, 38, 0.2);
        }
      `}</style>
      
      <aside style={{
        width: '280px',
        backgroundColor: '#dc2626',
        color: 'white',
        display: 'flex',
        flexDirection: 'column',
        position: 'fixed',
        height: '100vh',
        zIndex: 50,
        boxShadow: '0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06)',
        transition: isTransitioning ? 'none' : 'all 0.3s ease'
      }}>
        <div style={{
          padding: '24px',
          borderBottom: '1px solid #b91c1c'
        }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
            <img 
              src="/52e5494a-bfed-4c18-8508-b030d78fe658.png" 
              alt="FireAlert System Logo" 
              style={{
                width: '40px',
                height: '40px',
                objectFit: 'contain',
                borderRadius: '8px'
              }}
            />
            <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'flex-start' }}>
              <span style={{
                fontSize: '18px',
                fontWeight: '600',
                color: 'white',
                marginBottom: '2px'
              }}>BFP</span>
              <span style={{
                fontSize: '12px',
                fontWeight: '400',
                color: '#fecaca'
              }}>Fire Incident System</span>
            </div>
          </div>
        </div>
        
        <nav style={{
          flex: 1,
          padding: '16px',
          overflowY: 'auto'
        }}>
          <ul style={{ listStyle: 'none', margin: 0, padding: 0, display: 'flex', flexDirection: 'column', gap: '4px' }}>
            {navItems.map((item) => (
              <li key={item.id}>
                <button
                  onClick={() => handleNavClick(item.id)}
                  style={{
                    width: '100%',
                    display: 'flex',
                    alignItems: 'center',
                    gap: '12px',
                    padding: '10px 12px',
                    borderRadius: '8px',
                    textAlign: 'left',
                    transition: 'all 0.2s ease',
                    backgroundColor: activeNav === item.id ? '#ffffff' : 'transparent',
                    color: activeNav === item.id ? '#dc2626' : 'white',
                    fontWeight: activeNav === item.id ? '600' : '400',
                    cursor: 'pointer',
                    border: 'none'
                  }}
                  onMouseEnter={(e) => {
                    if (activeNav !== item.id) {
                      e.currentTarget.style.backgroundColor = '#b91c1c';
                      e.currentTarget.style.color = 'white';
                    }
                  }}
                  onMouseLeave={(e) => {
                    if (activeNav !== item.id) {
                      e.currentTarget.style.backgroundColor = 'transparent';
                      e.currentTarget.style.color = 'white';
                    }
                  }}
                >
                  <span className="material-icons" style={{ 
                    fontSize: '20px',
                    color: activeNav === item.id ? '#dc2626' : '#fecaca'
                  }}>
                    {item.icon}
                  </span>
                  <span style={{ fontSize: '14px' }}>{item.label}</span>
                </button>
              </li>
            ))}
          </ul>
        </nav>
        
        <div style={{
          padding: '16px',
          borderTop: '1px solid #b91c1c'
        }}>
          <div style={{
            display: 'flex',
            alignItems: 'center',
            gap: '12px',
            padding: '12px',
            backgroundColor: '#b91c1c',
            borderRadius: '8px',
            marginBottom: '12px'
          }}>
            <div style={{
              width: '40px',
              height: '40px',
              borderRadius: '50%',
              backgroundColor: '#dc2626',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              fontSize: '16px',
              fontWeight: 'bold',
              color: 'white'
            }}>
              {userData?.fullName?.charAt(0).toUpperCase() || 'U'}
            </div>
            <div style={{ flex: 1, minWidth: 0 }}>
              <p style={{
                fontWeight: '500',
                color: 'white',
                margin: 0,
                fontSize: '14px',
                overflow: 'hidden',
                textOverflow: 'ellipsis',
                whiteSpace: 'nowrap'
              }}>
                {userData?.fullName || 'BFP Officer'}
              </p>
              <p style={{
                fontSize: '12px',
                color: '#fecaca',
                margin: '2px 0 0 0',
                overflow: 'hidden',
                textOverflow: 'ellipsis',
                whiteSpace: 'nowrap'
              }}>
                {userData?.email || 'officer@bfp.gov.ph'}
              </p>
            </div>
          </div>
          
          <button
            onClick={handleLogout}
            style={{
              width: '100%',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              gap: '8px',
              padding: '10px 12px',
              backgroundColor: 'transparent',
              color: 'white',
              borderRadius: '8px',
              transition: 'all 0.2s ease',
              fontWeight: '400',
              cursor: 'pointer',
              border: '1px solid #b91c1c',
              fontSize: '14px'
            }}
            onMouseEnter={(e) => {
              e.currentTarget.style.backgroundColor = '#b91c1c';
            }}
            onMouseLeave={(e) => {
              e.currentTarget.style.backgroundColor = 'transparent';
            }}
          >
            <span className="material-icons" style={{ fontSize: '18px' }}>logout</span>
            <span>Logout</span>
          </button>
        </div>
      </aside>
    </>
  );
};

export default Sidebar;
