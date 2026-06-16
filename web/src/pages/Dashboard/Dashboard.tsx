import React, { useState, useEffect } from 'react';
import { useTheme } from '../../context/ThemeContext';
import { useThemeStyles } from '../../hooks/useThemeStyles';
import PageHeader from '../../components/PageHeader';

const Dashboard: React.FC = () => {
  const { theme } = useTheme();
  const { createCardStyle, createButtonStyle, createHeaderStyle, createTextStyle, getStatusColor, createLayoutStyle, createMainContentStyle, createSimpleHeaderStyle } = useThemeStyles();
  const [selectedPeriod, setSelectedPeriod] = useState('week');
  const [incidents, setIncidents] = useState([
    { id: 1, type: 'Residential Fire', location: 'Puerto Princesa City', time: '2 hours ago', status: 'resolved', severity: 'high' },
    { id: 2, type: 'Vehicle Fire', location: 'Barangay Bancao Bancao', time: '4 hours ago', status: 'active', severity: 'medium' },
    { id: 3, type: 'Grass Fire', location: 'Highway Area', time: '6 hours ago', status: 'resolved', severity: 'low' },
    { id: 4, type: 'Commercial Fire', location: 'Downtown Area', time: '1 day ago', status: 'investigating', severity: 'high' },
  ]);

  const stats = [
    { label: 'Active Incidents', value: '12', change: '+3 from yesterday', trend: 'up', color: theme.colors.primary },
    { label: 'Available Firetrucks', value: '24', change: '8 on route', trend: 'down', color: theme.colors.warning },
    { label: 'Pending Reports', value: '8', change: '3 high priority', trend: 'down', color: theme.colors.success },
    { label: 'Resolved Today', value: '45', change: '+12% from average', trend: 'up', color: theme.colors.secondary },
  ];

  const chartData = {
    week: [12, 19, 8, 15, 22, 18, 25],
    month: [45, 52, 38, 65, 48, 72, 58, 81, 69, 92, 78, 85],
    year: [280, 320, 290, 350, 310, 380, 360, 420, 390, 440, 410, 460]
  };

  const getSeverityColor = (severity: string) => {
    switch (severity) {
      case 'high': return '#dc2626';
      case 'medium': return '#f59e0b';
      case 'low': return '#10b981';
      default: return '#6b7280';
    }
  };

  return (
    <div style={{ padding: theme.spacing.xl }}>
      <PageHeader 
        title="Dashboard Overview"
        description="Real-time fire incident monitoring and response system"
      />

      <main style={{ padding: theme.spacing.xl }}>
        <div style={{ display: 'grid', 
          gridTemplateColumns: 'repeat(auto-fit, minmax(250px, 1fr))', 
          gap: theme.spacing.lg, 
          marginBottom: theme.spacing.xl 
        }}>
          {stats.map((stat, index) => (
            <div key={index} style={createCardStyle()}>
              <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: theme.spacing.md }}>
                <div>
                  <p style={createTextStyle('muted')}>
                    {stat.label}
                  </p>
                </div>
                <div style={{
                  width: '48px',
                  height: '48px',
                  backgroundColor: `${stat.color}20`,
                  borderRadius: theme.borderRadius.lg,
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center'
                }}>
                  <span className="material-icons" style={{ fontSize: '20px', color: stat.color }}>
                    {index === 0 ? 'local_fire_department' : 
                     index === 1 ? 'warning' : 
                     index === 2 ? 'schedule' : 'people'}
                  </span>
                </div>
              </div>
              <div style={{ display: 'flex', alignItems: 'baseline', gap: theme.spacing.sm, marginBottom: theme.spacing.sm }}>
                <span style={{ fontSize: '32px', fontWeight: 'bold', color: theme.colors.text.primary }}>
                  {stat.value}
                </span>
                <span style={{
                  fontSize: '12px',
                  color: stat.trend === 'up' ? theme.colors.success : theme.colors.error,
                  fontWeight: '500',
                  display: 'flex',
                  alignItems: 'center',
                  gap: '2px'
                }}>
                  <span className="material-icons" style={{ fontSize: '14px' }}>
                    {stat.trend === 'up' ? 'trending_up' : 'trending_down'}
                  </span>
                  {stat.change}
                </span>
              </div>
            </div>
          ))}
        </div>

        <div style={{
          display: 'grid',
          gridTemplateColumns: '2fr 1fr',
          gap: '24px'
        }}>
          <div style={{
            backgroundColor: 'white',
            borderRadius: '12px',
            padding: '24px',
            boxShadow: '0 1px 3px rgba(0, 0, 0, 0.1)',
            border: '1px solid #e5e7eb'
          }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '20px' }}>
              <h2 style={{ fontSize: '18px', fontWeight: '600', color: '#1f2937', margin: 0 }}>
                Recent Incidents
              </h2>
              <button style={{
                color: '#dc2626',
                backgroundColor: 'transparent',
                border: 'none',
                fontSize: '14px',
                fontWeight: '500',
                cursor: 'pointer',
                textDecoration: 'underline'
              }}>
                View All
              </button>
            </div>
            
            <div style={{ overflowX: 'auto' }}>
              <table style={{ width: '100%', borderCollapse: 'collapse' }}>
                <thead>
                  <tr style={{ borderBottom: '1px solid #e5e7eb' }}>
                    <th style={{ padding: '12px', textAlign: 'left', fontSize: '12px', fontWeight: '600', color: '#6b7280', textTransform: 'uppercase' }}>
                      Incident Type
                    </th>
                    <th style={{ padding: '12px', textAlign: 'left', fontSize: '12px', fontWeight: '600', color: '#6b7280', textTransform: 'uppercase' }}>
                      Location
                    </th>
                    <th style={{ padding: '12px', textAlign: 'left', fontSize: '12px', fontWeight: '600', color: '#6b7280', textTransform: 'uppercase' }}>
                      Time
                    </th>
                    <th style={{ padding: '12px', textAlign: 'left', fontSize: '12px', fontWeight: '600', color: '#6b7280', textTransform: 'uppercase' }}>
                      Status
                    </th>
                    <th style={{ padding: '12px', textAlign: 'left', fontSize: '12px', fontWeight: '600', color: '#6b7280', textTransform: 'uppercase' }}>
                      Severity
                    </th>
                    <th style={{ padding: '12px', textAlign: 'left', fontSize: '12px', fontWeight: '600', color: '#6b7280', textTransform: 'uppercase' }}>
                      Actions
                    </th>
                  </tr>
                </thead>
                <tbody>
                  {incidents.map((incident) => (
                    <tr key={incident.id} style={{ borderBottom: '1px solid #f3f4f6' }}>
                      <td style={{ padding: '16px 12px' }}>
                        <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                          <span className="material-icons" style={{ fontSize: '16px', color: '#dc2626' }}>
                            local_fire_department
                          </span>
                          <span style={{ fontSize: '14px', fontWeight: '500', color: '#1f2937' }}>
                            {incident.type}
                          </span>
                        </div>
                      </td>
                      <td style={{ padding: '16px 12px', fontSize: '14px', color: '#6b7280' }}>
                        {incident.location}
                      </td>
                      <td style={{ padding: '16px 12px', fontSize: '14px', color: '#6b7280' }}>
                        {incident.time}
                      </td>
                      <td style={{ padding: '16px 12px' }}>
                        <span style={{
                          padding: '4px 8px',
                          borderRadius: '4px',
                          fontSize: '12px',
                          fontWeight: '500',
                          backgroundColor: `${getStatusColor(incident.status)}20`,
                          color: getStatusColor(incident.status)
                        }}>
                          {incident.status}
                        </span>
                      </td>
                      <td style={{ padding: '16px 12px' }}>
                        <span style={{
                          padding: '4px 8px',
                          borderRadius: '4px',
                          fontSize: '12px',
                          fontWeight: '500',
                          backgroundColor: `${getSeverityColor(incident.severity)}20`,
                          color: getSeverityColor(incident.severity)
                        }}>
                          {incident.severity}
                        </span>
                      </td>
                      <td style={{ padding: '16px 12px' }}>
                        <button style={{
                          backgroundColor: 'transparent',
                          border: 'none',
                          cursor: 'pointer',
                          padding: '4px',
                          borderRadius: '4px',
                          display: 'flex',
                          alignItems: 'center',
                          gap: '4px'
                        }}>
                          <span className="material-icons" style={{ fontSize: '16px', color: '#6b7280' }}>
                            visibility
                          </span>
                          <span className="material-icons" style={{ fontSize: '16px', color: '#6b7280' }}>
                            edit
                          </span>
                        </button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
          
          <div style={{
            backgroundColor: 'white',
            borderRadius: '12px',
            padding: '24px',
            boxShadow: '0 1px 3px rgba(0, 0, 0, 0.1)',
            border: '1px solid #e5e7eb'
          }}>
            <div style={{
              display: 'flex',
              alignItems: 'center',
              gap: '8px',
              marginBottom: '16px'
            }}>
              <span className="material-icons" style={{ 
                fontSize: '20px',
                color: '#dc2626'
              }}>
                notifications_active
              </span>
              <h3 style={{
                fontSize: '16px',
                fontWeight: '600',
                color: '#1f2937',
                margin: 0
              }}>
                Alerts & Notifications
              </h3>
            </div>
            
            <div style={{
              display: 'flex',
              flexDirection: 'column',
              gap: '12px'
            }}>
              <div style={{
                padding: '12px',
                backgroundColor: '#fef2f2',
                borderRadius: '8px',
                borderLeft: '4px solid #dc2626'
              }}>
                <div style={{
                  display: 'flex',
                  alignItems: 'center',
                  gap: '8px',
                  marginBottom: '6px'
                }}>
                  <span className="material-icons" style={{ 
                    fontSize: '16px',
                    color: '#dc2626'
                  }}>
                    warning
                  </span>
                  <span style={{
                    fontSize: '13px',
                    fontWeight: '600',
                    color: '#dc2626'
                  }}>
                    High Priority Alert
                  </span>
                </div>
                <p style={{
                  fontSize: '12px',
                  color: '#6b7280',
                  margin: '0 0 4px 0',
                  lineHeight: '1.4'
                }}>
                  New fire incident reported in Downtown Area
                </p>
                <span style={{
                  fontSize: '11px',
                  color: '#9ca3af'
                }}>
                  2 min ago
                </span>
              </div>
              
              <div style={{
                padding: '12px',
                backgroundColor: '#fef3c7',
                borderRadius: '8px',
                borderLeft: '4px solid #f59e0b'
              }}>
                <div style={{
                  display: 'flex',
                  alignItems: 'center',
                  gap: '8px',
                  marginBottom: '6px'
                }}>
                  <span className="material-icons" style={{ 
                    fontSize: '16px',
                    color: '#f59e0b'
                  }}>
                    info
                  </span>
                  <span style={{
                    fontSize: '13px',
                    fontWeight: '600',
                    color: '#92400e'
                  }}>
                    System Update
                  </span>
                </div>
                <p style={{
                  fontSize: '12px',
                  color: '#6b7280',
                  margin: '0 0 4px 0',
                  lineHeight: '1.4'
                }}>
                  Fire truck #2 maintenance completed
                </p>
                <span style={{
                  fontSize: '11px',
                  color: '#9ca3af'
                }}>
                  15 min ago
                </span>
              </div>
              
              <div style={{
                padding: '12px',
                backgroundColor: '#f0f9ff',
                borderRadius: '8px',
                borderLeft: '4px solid #3b82f6'
              }}>
                <div style={{
                  display: 'flex',
                  alignItems: 'center',
                  gap: '8px',
                  marginBottom: '6px'
                }}>
                  <span className="material-icons" style={{ 
                    fontSize: '16px',
                    color: '#3b82f6'
                  }}>
                    check_circle
                  </span>
                  <span style={{
                    fontSize: '13px',
                    fontWeight: '600',
                    color: '#1e40af'
                  }}>
                    Task Completed
                  </span>
                </div>
                <p style={{
                  fontSize: '12px',
                  color: '#6b7280',
                  margin: '0 0 4px 0',
                  lineHeight: '1.4'
                }}>
                  All personnel accounted for at Station 1
                </p>
                <span style={{
                  fontSize: '11px',
                  color: '#9ca3af'
                }}>
                  1 hour ago
                </span>
              </div>
            </div>
          </div>
        </div>

        <div style={{
          backgroundColor: 'white',
          borderRadius: '12px',
          padding: '24px',
          boxShadow: '0 1px 3px rgba(0, 0, 0, 0.1)',
          border: '1px solid #e5e7eb',
          marginTop: '24px'
        }}>
          <div style={{
            display: 'grid',
            gridTemplateColumns: 'repeat(3, 1fr)',
            gap: '16px'
          }}>
            <button style={{
              padding: '20px',
              backgroundColor: '#dc2626',
              border: 'none',
              borderRadius: '12px',
              cursor: 'pointer',
              transition: 'all 0.2s ease',
              display: 'flex',
              flexDirection: 'column',
              alignItems: 'center',
              justifyContent: 'center',
              gap: '8px'
            }}
            onMouseEnter={(e) => {
              e.currentTarget.style.backgroundColor = '#b91c1c';
              e.currentTarget.style.transform = 'translateY(-2px)';
              e.currentTarget.style.boxShadow = '0 4px 12px rgba(220, 38, 38, 0.15)';
            }}
            onMouseLeave={(e) => {
              e.currentTarget.style.backgroundColor = '#dc2626';
              e.currentTarget.style.transform = 'translateY(0)';
              e.currentTarget.style.boxShadow = 'none';
            }}
            >
              <div style={{ textAlign: 'center' }}>
                <div style={{ fontSize: '16px', fontWeight: '600', color: 'white' }}>
                  View Live Map
                </div>
              </div>
            </button>
            
            <button style={{
              padding: '20px',
              backgroundColor: '#dc2626',
              border: 'none',
              borderRadius: '12px',
              cursor: 'pointer',
              transition: 'all 0.2s ease',
              display: 'flex',
              flexDirection: 'column',
              alignItems: 'center',
              justifyContent: 'center',
              gap: '8px'
            }}
            onMouseEnter={(e) => {
              e.currentTarget.style.backgroundColor = '#b91c1c';
              e.currentTarget.style.transform = 'translateY(-2px)';
              e.currentTarget.style.boxShadow = '0 4px 12px rgba(220, 38, 38, 0.15)';
            }}
            onMouseLeave={(e) => {
              e.currentTarget.style.backgroundColor = '#dc2626';
              e.currentTarget.style.transform = 'translateY(0)';
              e.currentTarget.style.boxShadow = 'none';
            }}
            >
              <div style={{ textAlign: 'center' }}>
                <div style={{ fontSize: '16px', fontWeight: '600', color: 'white' }}>
                  Dispatch Firetruck
                </div>
              </div>
            </button>
            
            <button style={{
              padding: '20px',
              backgroundColor: '#dc2626',
              border: 'none',
              borderRadius: '12px',
              cursor: 'pointer',
              transition: 'all 0.2s ease',
              display: 'flex',
              flexDirection: 'column',
              alignItems: 'center',
              justifyContent: 'center',
              gap: '8px'
            }}
            onMouseEnter={(e) => {
              e.currentTarget.style.backgroundColor = '#b91c1c';
              e.currentTarget.style.transform = 'translateY(-2px)';
              e.currentTarget.style.boxShadow = '0 4px 12px rgba(220, 38, 38, 0.15)';
            }}
            onMouseLeave={(e) => {
              e.currentTarget.style.backgroundColor = '#dc2626';
              e.currentTarget.style.transform = 'translateY(0)';
              e.currentTarget.style.boxShadow = 'none';
            }}
            >
              <div style={{ textAlign: 'center' }}>
                <div style={{ fontSize: '16px', fontWeight: '600', color: 'white' }}>
                  Create Incident Report
                </div>
              </div>
            </button>
          </div>
        </div>
      </main>
    </div>
  );
};

export default Dashboard;
