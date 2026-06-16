import React from 'react';
import { useThemeStyles } from '../hooks/useThemeStyles';

interface PageHeaderProps {
  title: string;
  description: string;
  level?: 1 | 2 | 3 | 4 | 5 | 6;
  actions?: React.ReactNode;
}

const PageHeader: React.FC<PageHeaderProps> = ({ 
  title, 
  description, 
  level = 1,
  actions 
}) => {
  const { createHeaderStyle, createTextStyle, theme } = useThemeStyles();

  return (
    <section style={{ marginBottom: theme.spacing.xl }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <div>
          <h1 style={createHeaderStyle(level)}>
            {title}
          </h1>
          <p style={createTextStyle('secondary')}>
            {description}
          </p>
        </div>
        {actions && (
          <div style={{ display: 'flex', gap: '12px' }}>
            {actions}
          </div>
        )}
      </div>
    </section>
  );
};

export default PageHeader;
