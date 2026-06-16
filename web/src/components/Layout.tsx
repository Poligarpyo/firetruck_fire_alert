import React from 'react';
import { useAuth } from '../context/AuthContext';
import { useThemeStyles } from '../hooks/useThemeStyles';
import Sidebar from './Sidebar';


interface LayoutProps {
  children: React.ReactNode;
}

const Layout: React.FC<LayoutProps> = ({ children }) => {
  const { user, logout } = useAuth();
  const { createLayoutStyle, createMainContentStyle } = useThemeStyles();

  return (
    <div style={createLayoutStyle()}>
      <Sidebar />
      <main style={createMainContentStyle()}>
        {children}
      </main>
    </div>
  );
};

export default Layout;
