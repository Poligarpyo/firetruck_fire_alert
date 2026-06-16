import React, { createContext, useContext, useState, useEffect, ReactNode } from 'react';

interface ThemeColors {
  primary: string;
  secondary: string;
  background: string;
  surface: string;
  text: {
    primary: string;
    secondary: string;
    muted: string;
  };
  border: string;
  success: string;
  warning: string;
  error: string;
  info: string;
}

interface Theme {
  name: string;
  colors: ThemeColors;
  fonts: {
    primary: string;
    secondary: string;
  };
  spacing: {
    xs: string;
    sm: string;
    md: string;
    lg: string;
    xl: string;
    xxl: string;
  };
  borderRadius: {
    sm: string;
    md: string;
    lg: string;
    xl: string;
  };
  shadows: {
    sm: string;
    md: string;
    lg: string;
  };
}

const lightTheme: Theme = {
  name: 'light',
  colors: {
    primary: '#dc2626',
    secondary: '#3b82f6',
    background: '#f9fafb',
    surface: '#ffffff',
    text: {
      primary: '#1f2937',
      secondary: '#374151',
      muted: '#6b7280',
    },
    border: '#e5e7eb',
    success: '#22c55e',
    warning: '#f59e0b',
    error: '#dc2626',
    info: '#3b82f6',
  },
  fonts: {
    primary: 'Inter, sans-serif',
    secondary: 'Roboto, sans-serif',
  },
  spacing: {
    xs: '4px',
    sm: '8px',
    md: '16px',
    lg: '24px',
    xl: '32px',
    xxl: '48px',
  },
  borderRadius: {
    sm: '6px',
    md: '8px',
    lg: '12px',
    xl: '16px',
  },
  shadows: {
    sm: '0 1px 2px rgba(0, 0, 0, 0.05)',
    md: '0 1px 3px rgba(0, 0, 0, 0.1)',
    lg: '0 4px 6px rgba(0, 0, 0, 0.1)',
  },
};

interface ThemeContextType {
  theme: Theme;
}

const ThemeContext = createContext<ThemeContextType | undefined>(undefined);

interface ThemeProviderProps {
  children: ReactNode;
}

export const ThemeProvider: React.FC<ThemeProviderProps> = ({ children }) => {
  const theme = lightTheme;

  return (
    <ThemeContext.Provider value={{ theme }}>
      {children}
    </ThemeContext.Provider>
  );
};

export const useTheme = (): ThemeContextType => {
  const context = useContext(ThemeContext);
  if (context === undefined) {
    throw new Error('useTheme must be used within a ThemeProvider');
  }
  return context;
};

// Helper function to create styled components with theme
export const createThemedStyle = <T extends Record<string, any>>(styles: T) => {
  return (theme: Theme) => {
    const processStyles = (obj: any): any => {
      if (typeof obj === 'string' && obj.startsWith('$')) {
        const key = obj.substring(1);
        const keys = key.split('.');
        let value: any = theme;
        for (const k of keys) {
          value = value?.[k];
        }
        return value || obj;
      }
      if (typeof obj === 'object' && obj !== null) {
        const result: any = {};
        for (const [k, v] of Object.entries(obj)) {
          result[k] = processStyles(v);
        }
        return result;
      }
      return obj;
    };
    return processStyles(styles);
  };
};

// Predefined common styles that can be used across components
export const commonStyles = {
  card: {
    backgroundColor: '$colors.surface',
    borderRadius: '$borderRadius.lg',
    padding: '$spacing.lg',
    boxShadow: '$shadows.md',
    border: `1px solid $colors.border`,
  },
  button: {
    backgroundColor: '$colors.primary',
    color: '$colors.surface',
    border: 'none',
    borderRadius: '$borderRadius.md',
    padding: '$spacing.sm $spacing.md',
    fontSize: '14px',
    fontWeight: '500',
    cursor: 'pointer',
    transition: 'all 0.2s ease',
  },
  input: {
    backgroundColor: '$colors.surface',
    border: `1px solid $colors.border`,
    borderRadius: '$borderRadius.md',
    padding: '$spacing.sm $spacing.md',
    fontSize: '14px',
    outline: 'none',
    transition: 'border-color 0.2s ease',
  },
  text: {
    primary: {
      color: '$colors.text.primary',
      fontSize: '14px',
    },
    secondary: {
      color: '$colors.text.secondary',
      fontSize: '12px',
    },
    muted: {
      color: '$colors.text.muted',
      fontSize: '12px',
    },
  },
};
