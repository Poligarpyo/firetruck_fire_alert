import React, { useState } from 'react';
import { useTheme } from '../../context/ThemeContext';
import { useThemeStyles } from '../../hooks/useThemeStyles';
import PageHeader from '../../components/PageHeader';

const Incidents: React.FC = () => {
  const { theme } = useTheme();
  const { createCardStyle, createButtonStyle, createSimpleHeaderStyle, createTextStyle, getStatusColor, createLayoutStyle, createMainContentStyle } = useThemeStyles();
  const [filter, setFilter] = useState('all');
  const [searchTerm, setSearchTerm] = useState('');

  const incidents = [
    {
      id: 'INC-2024-1234',
      type: 'Residential Fire',
      severity: 'HIGH',
      status: 'ACTIVE',
      location: 'Pagkakaisa, Puerto Princesa City',
      reported: '2024-03-18 10:23 AM',
      reportedBy: 'John Doe',
      assignedUnits: ['1'],
      casualties: 0,
      injuries: 2,
      estimatedDamage: '$50,000',
      description: 'Fire reported on 3rd floor of residential building',
    },
    {
      id: 'INC-2024-1233',
      type: 'Vehicle Fire',
      severity: 'MEDIUM',
      status: 'RESPONDING',
      location: 'Bagong Silang, Puerto Princesa City',
      reported: '2024-03-18 09:45 AM',
      reportedBy: 'Traffic Officer',
      assignedUnits: ['2'],
      casualties: 0,
      injuries: 0,
      estimatedDamage: '$25,000',
      description: 'Car fire on highway, traffic blocked',
    },
    {
      id: 'INC-2024-1232',
      type: 'Commercial Fire',
      severity: 'HIGH',
      status: 'ACTIVE',
      location: 'San Jose, Puerto Princesa City',
      reported: '2024-03-18 08:30 AM',
      reportedBy: 'Store Owner',
      assignedUnits: ['3'],
      casualties: 0,
      injuries: 3,
      estimatedDamage: '$200,000',
      description: 'Fire in commercial shopping center',
    },
    {
      id: 'INC-2024-1231',
      type: 'Wildfire',
      severity: 'MEDIUM',
      status: 'CONTAINED',
      location: 'Mount Victoria, Puerto Princesa City',
      reported: '2024-03-18 07:15 AM',
      reportedBy: 'Forest Ranger',
      assignedUnits: ['4'],
      casualties: 0,
      injuries: 1,
      estimatedDamage: '$15,000',
      description: 'Wildfire spreading through forest area',
    },
  ];

  const getSeverityColor = (severity: string) => {
    switch (severity) {
      case 'HIGH': return '#dc2626';
      case 'MEDIUM': return '#f59e0b';
      case 'LOW': return '#22c55e';
      default: return '#6b7280';
    }
  };

  const filteredIncidents = incidents.filter(incident => {
    const matchesFilter = filter === 'all' || incident.status.toLowerCase() === filter.toLowerCase();
    const matchesSearch = incident.location.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         incident.type.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         incident.id.toLowerCase().includes(searchTerm.toLowerCase());
    return matchesFilter && matchesSearch;
  });

  return (
    <div style={{ padding: theme.spacing.xl }}>
      <PageHeader 
        title="Incident Reports"
        description="Manage and track all fire incidents"
      />

      <main style={{ padding: '32px' }}>
          <div style={{
            backgroundColor: 'white',
            borderRadius: '12px',
            padding: '24px',
            boxShadow: '0 1px 3px rgba(0, 0, 0, 0.1)',
            border: '1px solid #e5e7eb',
            marginBottom: '24px'
          }}>
            <div style={{ display: 'flex', flexDirection: 'column', gap: '16px' }}>
              <div style={{ display: 'flex', gap: '16px', alignItems: 'center' }}>
                <div style={{ flex: 1 }}>
                  <input
                    type="text"
                    placeholder="Search incidents..."
                    style={{
                      width: '100%',
                      padding: '10px 12px',
                      border: '1px solid #e5e7eb',
                      borderRadius: '8px',
                      fontSize: '14px',
                      outline: 'none',
                      transition: 'border-color 0.2s ease'
                    }}
                    onFocus={(e) => {
                      e.currentTarget.style.borderColor = '#dc2626';
                    }}
                    onBlur={(e) => {
                      e.currentTarget.style.borderColor = '#e5e7eb';
                    }}
                    value={searchTerm}
                    onChange={(e) => setSearchTerm(e.target.value)}
                  />
                </div>
                <select
                  style={{
                    padding: '10px 12px',
                    border: '1px solid #e5e7eb',
                    borderRadius: '8px',
                    fontSize: '14px',
                    outline: 'none',
                    cursor: 'pointer',
                    backgroundColor: 'white'
                  }}
                  value={filter}
                  onChange={(e) => setFilter(e.target.value)}
                >
                  <option value="all">All Status</option>
                  <option value="active">Active</option>
                  <option value="responding">Responding</option>
                  <option value="contained">Contained</option>
                  <option value="resolved">Resolved</option>
                </select>
                <button style={{
                  padding: '10px 16px',
                  backgroundColor: '#dc2626',
                  color: 'white',
                  border: 'none',
                  borderRadius: '8px',
                  fontSize: '14px',
                  fontWeight: '500',
                  cursor: 'pointer',
                  display: 'flex',
                  alignItems: 'center',
                  gap: '8px'
                }}>
                  <span className="material-icons" style={{ fontSize: '18px' }}>add</span>
                  New Incident Report
                </button>
              </div>
            </div>
          </div>

          <div style={{
            display: 'grid',
            gridTemplateColumns: 'repeat(auto-fit, minmax(250px, 1fr))',
            gap: '24px',
            marginBottom: '24px'
          }}>
            <div style={{
              backgroundColor: 'white',
              borderRadius: '12px',
              padding: '24px',
              boxShadow: '0 1px 3px rgba(0, 0, 0, 0.1)',
              border: '1px solid #e5e7eb'
            }}>
              <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                <div>
                  <p style={{ fontSize: '14px', color: '#6b7280', margin: 0 }}>Total Incidents</p>
                  <p style={{ fontSize: '32px', fontWeight: 'bold', color: '#1f2937', margin: '8px 0 0 0' }}>
                    5
                  </p>
                </div>
                <div style={{
                  width: '48px',
                  height: '48px',
                  backgroundColor: '#dc2626',
                  borderRadius: '12px',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center'
                }}>
                  <span className="material-icons" style={{ fontSize: '24px', color: 'white' }}>
                    local_fire_department
                  </span>
                </div>
              </div>
            </div>
            
            <div style={{
              backgroundColor: 'white',
              borderRadius: '12px',
              padding: '24px',
              boxShadow: '0 1px 3px rgba(0, 0, 0, 0.1)',
              border: '1px solid #e5e7eb'
            }}>
              <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                <div>
                  <p style={{ fontSize: '14px', color: '#6b7280', margin: 0 }}>Active</p>
                  <p style={{ fontSize: '32px', fontWeight: 'bold', color: '#1f2937', margin: '8px 0 0 0' }}>
                    1
                  </p>
                </div>
                <div style={{
                  width: '48px',
                  height: '48px',
                  backgroundColor: '#dc2626',
                  borderRadius: '12px',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center'
                }}>
                  <span className="material-icons" style={{ fontSize: '24px', color: 'white' }}>
                    warning
                  </span>
                </div>
              </div>
            </div>
            
            <div style={{
              backgroundColor: 'white',
              borderRadius: '12px',
              padding: '24px',
              boxShadow: '0 1px 3px rgba(0, 0, 0, 0.1)',
              border: '1px solid #e5e7eb'
            }}>
              <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                <div>
                  <p style={{ fontSize: '14px', color: '#6b7280', margin: 0 }}>Responding</p>
                  <p style={{ fontSize: '32px', fontWeight: 'bold', color: '#1f2937', margin: '8px 0 0 0' }}>
                    1
                  </p>
                </div>
                <div style={{
                  width: '48px',
                  height: '48px',
                  backgroundColor: '#f59e0b',
                  borderRadius: '12px',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center'
                }}>
                  <span className="material-icons" style={{ fontSize: '24px', color: 'white' }}>
                    fire_truck
                  </span>
                </div>
              </div>
            </div>
            
            <div style={{
              backgroundColor: 'white',
              borderRadius: '12px',
              padding: '24px',
              boxShadow: '0 1px 3px rgba(0, 0, 0, 0.1)',
              border: '1px solid #e5e7eb'
            }}>
              <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                <div>
                  <p style={{ fontSize: '14px', color: '#6b7280', margin: 0 }}>Resolved</p>
                  <p style={{ fontSize: '32px', fontWeight: 'bold', color: '#1f2937', margin: '8px 0 0 0' }}>
                    2
                  </p>
                </div>
                <div style={{
                  width: '48px',
                  height: '48px',
                  backgroundColor: '#22c55e',
                  borderRadius: '12px',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center'
                }}>
                  <span className="material-icons" style={{ fontSize: '24px', color: 'white' }}>
                    check_circle
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
            border: '1px solid #e5e7eb'
          }}>
            <div style={{ overflowX: 'auto' }}>
              <table style={{ width: '100%', borderCollapse: 'collapse' }}>
                <thead>
                  <tr style={{ borderBottom: '1px solid #e5e7eb' }}>
                    <th style={{ padding: '12px', textAlign: 'left', fontSize: '12px', fontWeight: '600', color: '#6b7280', textTransform: 'uppercase' }}>
                      ID
                    </th>
                    <th style={{ padding: '12px', textAlign: 'left', fontSize: '12px', fontWeight: '600', color: '#6b7280', textTransform: 'uppercase' }}>
                      Type
                    </th>
                    <th style={{ padding: '12px', textAlign: 'left', fontSize: '12px', fontWeight: '600', color: '#6b7280', textTransform: 'uppercase' }}>
                      Location
                    </th>
                    <th style={{ padding: '12px', textAlign: 'left', fontSize: '12px', fontWeight: '600', color: '#6b7280', textTransform: 'uppercase' }}>
                      Severity
                    </th>
                    <th style={{ padding: '12px', textAlign: 'left', fontSize: '12px', fontWeight: '600', color: '#6b7280', textTransform: 'uppercase' }}>
                      Status
                    </th>
                    <th style={{ padding: '12px', textAlign: 'left', fontSize: '12px', fontWeight: '600', color: '#6b7280', textTransform: 'uppercase' }}>
                      Reported
                    </th>
                    <th style={{ padding: '12px', textAlign: 'left', fontSize: '12px', fontWeight: '600', color: '#6b7280', textTransform: 'uppercase' }}>
                      Units
                    </th>
                    <th style={{ padding: '12px', textAlign: 'left', fontSize: '12px', fontWeight: '600', color: '#6b7280', textTransform: 'uppercase' }}>
                      Actions
                    </th>
                  </tr>
                </thead>
                <tbody>
                  {filteredIncidents.map((incident) => (
                    <tr key={incident.id} style={{ borderBottom: '1px solid #f3f4f6' }}>
                      <td style={{ padding: '16px 12px', fontSize: '14px', fontWeight: '500', color: '#1f2937' }}>
                        {incident.id}
                      </td>
                      <td style={{ padding: '16px 12px', fontSize: '14px', color: '#1f2937' }}>
                        {incident.type}
                      </td>
                      <td style={{ padding: '16px 12px', fontSize: '14px', color: '#6b7280', maxWidth: '200px' }}>
                        <div style={{ overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
                          {incident.location}
                        </div>
                      </td>
                      <td style={{ padding: '16px 12px' }}>
                        <span style={{
                          padding: '4px 8px',
                          borderRadius: '4px',
                          fontSize: '11px',
                          fontWeight: '600',
                          backgroundColor: getSeverityColor(incident.severity) + '20',
                          color: getSeverityColor(incident.severity)
                        }}>
                          {incident.severity}
                        </span>
                      </td>
                      <td style={{ padding: '16px 12px' }}>
                        <span style={{
                          padding: '4px 8px',
                          borderRadius: '4px',
                          fontSize: '11px',
                          fontWeight: '600',
                          backgroundColor: getStatusColor(incident.status) + '20',
                          color: getStatusColor(incident.status)
                        }}>
                          {incident.status}
                        </span>
                      </td>
                      <td style={{ padding: '16px 12px', fontSize: '14px', color: '#6b7280' }}>
                        {incident.reported}
                      </td>
                      <td style={{ padding: '16px 12px' }}>
                        <div style={{ display: 'flex', flexWrap: 'wrap', gap: '4px' }}>
                          {incident.assignedUnits.map((unit, index) => (
                            <span key={index} style={{
                              padding: '2px 6px',
                              backgroundColor: '#e0f2fe',
                              color: '#0369a1',
                              fontSize: '10px',
                              fontWeight: '500',
                              borderRadius: '4px'
                            }}>
                              {unit}
                            </span>
                          ))}
                        </div>
                      </td>
                      <td style={{ padding: '16px 12px' }}>
                        <div style={{ display: 'flex', gap: '8px' }}>
                          <button style={{
                            padding: '6px 12px',
                            backgroundColor: 'transparent',
                            color: '#dc2626',
                            border: '1px solid #dc2626',
                            borderRadius: '6px',
                            fontSize: '12px',
                            fontWeight: '500',
                            cursor: 'pointer'
                          }}>
                            View
                          </button>
                          <button style={{
                            padding: '6px 12px',
                            backgroundColor: 'transparent',
                            color: '#6b7280',
                            border: '1px solid #e5e7eb',
                            borderRadius: '6px',
                            fontSize: '12px',
                            fontWeight: '500',
                            cursor: 'pointer'
                          }}>
                            Edit
                          </button>
                        </div>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        </main>
    </div>
  );
};

export default Incidents;
