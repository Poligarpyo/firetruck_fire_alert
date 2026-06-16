import { useTheme } from '../context/ThemeContext';

export const useThemeStyles = () => {
  const { theme } = useTheme();

  // Helper function to get theme values
  const get = (path: string) => {
    const keys = path.split('.');
    let value: any = theme;
    for (const key of keys) {
      value = value?.[key];
    }
    return value;
  };

  // Common style generators
  const createCardStyle = (overrides = {}) => ({
    backgroundColor: theme.colors.surface,
    borderRadius: theme.borderRadius.lg,
    padding: theme.spacing.lg,
    boxShadow: theme.shadows.md,
    border: `1px solid ${theme.colors.border}`,
    ...overrides,
  });

  const createButtonStyle = (variant: 'primary' | 'secondary' | 'danger' = 'primary', overrides = {}) => {
    const baseStyle = {
      borderRadius: theme.borderRadius.md,
      padding: `${theme.spacing.sm} ${theme.spacing.md}`,
      fontSize: '14px',
      fontWeight: '500',
      cursor: 'pointer',
      transition: 'all 0.2s ease',
      border: 'none',
      fontFamily: theme.fonts.primary,
      ...overrides,
    };

    switch (variant) {
      case 'primary':
        return {
          ...baseStyle,
          backgroundColor: theme.colors.primary,
          color: theme.colors.surface,
        };
      case 'secondary':
        return {
          ...baseStyle,
          backgroundColor: 'transparent',
          color: theme.colors.primary,
          border: `1px solid ${theme.colors.primary}`,
        };
      case 'danger':
        return {
          ...baseStyle,
          backgroundColor: theme.colors.error,
          color: theme.colors.surface,
        };
      default:
        return baseStyle;
    }
  };

  const createInputStyle = (overrides = {}) => ({
    backgroundColor: theme.colors.surface,
    border: `1px solid ${theme.colors.border}`,
    borderRadius: theme.borderRadius.md,
    padding: `${theme.spacing.sm} ${theme.spacing.md}`,
    fontSize: '14px',
    outline: 'none',
    transition: 'border-color 0.2s ease',
    fontFamily: theme.fonts.primary,
    color: theme.colors.text.primary,
    ...overrides,
  });

  const createTextStyle = (variant: 'primary' | 'secondary' | 'muted' = 'primary', overrides = {}) => {
    const baseStyle = {
      fontFamily: theme.fonts.primary,
      ...overrides,
    };

    switch (variant) {
      case 'primary':
        return {
          ...baseStyle,
          color: theme.colors.text.primary,
          fontSize: '14px',
        };
      case 'secondary':
        return {
          ...baseStyle,
          color: theme.colors.text.secondary,
          fontSize: '12px',
        };
      case 'muted':
        return {
          ...baseStyle,
          color: theme.colors.text.muted,
          fontSize: '12px',
        };
      default:
        return baseStyle;
    }
  };

  const createHeaderStyle = (level: 1 | 2 | 3 | 4 | 5 | 6 = 1, overrides = {}) => {
    const sizes = {
      1: { fontSize: '28px', fontWeight: 'bold' },
      2: { fontSize: '24px', fontWeight: 'bold' },
      3: { fontSize: '20px', fontWeight: '600' },
      4: { fontSize: '18px', fontWeight: '600' },
      5: { fontSize: '16px', fontWeight: '500' },
      6: { fontSize: '14px', fontWeight: '500' },
    };

    return {
      color: theme.colors.text.primary,
      fontFamily: theme.fonts.primary,
      margin: 0,
      ...sizes[level],
      ...overrides,
    };
  };

  // Status color helpers
  const getStatusColor = (status: string) => {
    switch (status.toLowerCase()) {
      case 'active':
      case 'high':
      case 'error':
        return theme.colors.error;
      case 'responding':
      case 'medium':
      case 'warning':
        return theme.colors.warning;
      case 'available':
      case 'resolved':
      case 'success':
      case 'low':
        return theme.colors.success;
      case 'contained':
      case 'info':
        return theme.colors.info;
      default:
        return theme.colors.text.muted;
    }
  };

  // Layout helpers
  const createLayoutStyle = () => ({
    minHeight: '100vh',
    backgroundColor: theme.colors.background,
    fontFamily: theme.fonts.primary,
  });

  const createMainContentStyle = () => ({
    marginLeft: '280px',
    minHeight: '100vh',
  });

  const createPageHeaderStyle = () => ({
    backgroundColor: theme.colors.surface,
    borderBottom: `1px solid ${theme.colors.border}`,
    padding: `${theme.spacing.lg} ${theme.spacing.xl}`,
    position: 'sticky' as const,
    top: 0,
    zIndex: 30,
  });

  const createSimpleHeaderStyle = () => ({
    borderBottom: `1px solid ${theme.colors.border}`,
    padding: `${theme.spacing.lg} ${theme.spacing.xl}`,
    marginBottom: theme.spacing.xl,
  });

  return {
    theme,
    get,
    createCardStyle,
    createButtonStyle,
    createInputStyle,
    createTextStyle,
    createHeaderStyle,
    getStatusColor,
    createLayoutStyle,
    createMainContentStyle,
    createPageHeaderStyle,
    createSimpleHeaderStyle,
  };
};
