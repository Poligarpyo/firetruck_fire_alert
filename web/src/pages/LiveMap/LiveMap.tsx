import React from 'react';
import { useTheme } from '../../context/ThemeContext';
import { useThemeStyles } from '../../hooks/useThemeStyles';
import PageHeader from '../../components/PageHeader';

const LiveMap: React.FC = () => {
  const { theme } = useTheme();
  const { createCardStyle, createButtonStyle, createHeaderStyle, createSimpleHeaderStyle, createTextStyle, getStatusColor, createLayoutStyle, createMainContentStyle } = useThemeStyles();
  const incidents = [
    { 
      id: 'INC-2024-1234', 
      type: 'Residential Fire', 
      severity: 'HIGH', 
      address: 'Pagkakaisa, Puerto Princesa City',
      status: 'ACTIVE',
      lat: 40.7128, 
      lng: -74.0060 
    },
    { 
      id: 'INC-2024-1233', 
      type: 'Vehicle Fire', 
      severity: 'MEDIUM', 
      address: 'Bagong Silang, Puerto Princesa City',
      status: 'RESPONDING',
      lat: 40.7580, 
      lng: -73.9855 
    },
    { 
      id: 'INC-2024-1232', 
      type: 'Commercial Fire', 
      severity: 'HIGH', 
      address: 'San Jose, Puerto Princesa City',
      status: 'ACTIVE',
      lat: 40.7489, 
      lng: -73.9680 
    },
  ];

  const fireTrucks = [
    { 
      id: 'FT-001', 
      name: 'Firetruck Alpha', 
      unit: 'FT-001',
      status: 'RESPONDING',
      lat: 40.7128, 
      lng: -74.0060 
    },
    { 
      id: 'FT-002', 
      name: 'Firetruck Bravo', 
      unit: 'FT-002',
      status: 'ON-SCENE',
      lat: 40.7580, 
      lng: -73.9855 
    },
    { 
      id: 'FT-003', 
      name: 'Firetruck Charlie', 
      unit: 'FT-003',
      status: 'AVAILABLE',
      lat: 40.7489, 
      lng: -73.9680 
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

  const getIncidentStatusColor = (status: string) => {
    switch (status) {
      case 'ACTIVE': return '#dc2626';
      case 'RESPONDING': return '#f59e0b';
      default: return '#6b7280';
    }
  };

  return (
    <div style={{ padding: theme.spacing.xl }}>
      <PageHeader 
        title="Live Map"
        description="Real-time incident tracking and fire truck monitoring"
        actions={
          <div style={{ display: 'flex', gap: '12px' }}>
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
              <span className="material-icons" style={{ fontSize: '18px' }}>layers</span>
              Layers
            </button>
            <button style={{
              padding: '10px 16px',
              backgroundColor: 'white',
              color: '#374151',
              border: '1px solid #e5e7eb',
              borderRadius: '8px',
              fontSize: '14px',
              fontWeight: '500',
              cursor: 'pointer',
              display: 'flex',
              alignItems: 'center',
              gap: '8px'
            }}>
              <span className="material-icons" style={{ fontSize: '18px' }}>center_focus_strong</span>
              Center Map
            </button>
          </div>
        }
      />

      <main style={{ padding: '32px' }}>
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
              <div style={{
                backgroundColor: '#f3f4f6',
                borderRadius: '8px',
                height: '500px',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                position: 'relative',
                overflow: 'hidden'
              }}>
                <div style={{ textAlign: 'center', zIndex: 1 }}>
                  <span className="material-icons" style={{ fontSize: '48px', color: '#6b7280', marginBottom: '16px', display: 'block' }}>
                    map
                  </span>
                  <p style={{ color: '#6b7280', fontSize: '16px', margin: 0 }}>
                    Interactive map would be rendered here
                  </p>
                  <p style={{ color: '#9ca3af', fontSize: '14px', margin: '8px 0 0 0' }}>
                    Integrate with Leaflet or Google Maps API
                  </p>
                </div>
                
                <div style={{
                  position: 'absolute',
                  top: '16px',
                  right: '16px',
                  display: 'flex',
                  flexDirection: 'column',
                  gap: '8px',
                  zIndex: 10
                }}>
                  <button style={{
                    width: '40px',
                    height: '40px',
                    backgroundColor: 'white',
                    border: '1px solid #e5e7eb',
                    borderRadius: '8px',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    cursor: 'pointer',
                    boxShadow: '0 2px 4px rgba(0, 0, 0, 0.1)',
                    fontSize: '20px',
                    fontWeight: 'bold',
                    color: '#374151'
                  }}>
                    +
                  </button>
                  <button style={{
                    width: '40px',
                    height: '40px',
                    backgroundColor: 'white',
                    border: '1px solid #e5e7eb',
                    borderRadius: '8px',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    cursor: 'pointer',
                    boxShadow: '0 2px 4px rgba(0, 0, 0, 0.1)',
                    fontSize: '20px',
                    fontWeight: 'bold',
                    color: '#374151'
                  }}>
                    −
                  </button>
                </div>
                
                <div style={{
                  position: 'absolute',
                  top: '30%',
                  left: '25%',
                  width: '24px',
                  height: '24px',
                  backgroundColor: '#dc2626',
                  borderRadius: '50%',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  boxShadow: '0 2px 4px rgba(0, 0, 0, 0.2)'
                }}>
                  <span className="material-icons" style={{ fontSize: '14px', color: 'white' }}>
                    local_fire_department
                  </span>
                </div>
                
                <div style={{
                  position: 'absolute',
                  top: '50%',
                  left: '60%',
                  width: '24px',
                  height: '24px',
                  backgroundColor: '#f59e0b',
                  borderRadius: '50%',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  boxShadow: '0 2px 4px rgba(0, 0, 0, 0.2)'
                }}>
                  <span className="material-icons" style={{ fontSize: '14px', color: 'white' }}>
                    local_fire_department
                  </span>
                </div>
                
                <div style={{
                  position: 'absolute',
                  top: '70%',
                  left: '40%',
                  width: '24px',
                  height: '24px',
                  backgroundColor: '#22c55e',
                  borderRadius: '50%',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  boxShadow: '0 2px 4px rgba(0, 0, 0, 0.2)'
                }}>
                  <span className="material-icons" style={{ fontSize: '14px', color: 'white' }}>
                    local_fire_department
                  </span>
                </div>
              </div>
            </div>

            <div style={{ display: 'flex', flexDirection: 'column', gap: '24px' }}>
              <div style={{
                backgroundColor: 'white',
                borderRadius: '12px',
                padding: '24px',
                boxShadow: '0 1px 3px rgba(0, 0, 0, 0.1)',
                border: '1px solid #e5e7eb'
              }}>
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '20px' }}>
                  <h3 style={{ fontSize: '18px', fontWeight: '600', color: '#1f2937', margin: 0 }}>
                    Active Incidents
                  </h3>
                  <span style={{
                    backgroundColor: '#dc2626',
                    color: 'white',
                    padding: '4px 8px',
                    borderRadius: '12px',
                    fontSize: '12px',
                    fontWeight: '600'
                  }}>
                    {incidents.length}
                  </span>
                </div>
                
                <div style={{ marginBottom: '16px', padding: '12px', backgroundColor: '#f9fafb', borderRadius: '8px', border: '1px solid #e5e7eb' }}>
                  <h4 style={{ fontSize: '12px', fontWeight: '600', color: '#6b7280', margin: '0 0 8px 0', textTransform: 'uppercase' }}>
                    Legend
                  </h4>
                  <div style={{ display: 'flex', flexDirection: 'column', gap: '6px' }}>
                    <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                      <div style={{ width: '12px', height: '12px', borderRadius: '50%', backgroundColor: '#dc2626' }} />
                      <span style={{ fontSize: '11px', color: '#4b5563' }}>High Priority Incident</span>
                    </div>
                    <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                      <div style={{ width: '12px', height: '12px', borderRadius: '50%', backgroundColor: '#f59e0b' }} />
                      <span style={{ fontSize: '11px', color: '#4b5563' }}>Medium Priority Incident</span>
                    </div>
                    <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                      <div style={{ width: '12px', height: '12px', borderRadius: '50%', backgroundColor: '#f59e0b' }} />
                      <span style={{ fontSize: '11px', color: '#4b5563' }}>Firetruck Responding</span>
                    </div>
                    <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                      <div style={{ width: '12px', height: '12px', borderRadius: '50%', backgroundColor: '#22c55e' }} />
                      <span style={{ fontSize: '11px', color: '#4b5563' }}>Firetruck Available</span>
                    </div>
                  </div>
                </div>
                
                <div style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
                  {incidents.map((incident) => (
                    <div key={incident.id} style={{
                      display: 'flex',
                      flexDirection: 'column',
                      padding: '12px',
                      backgroundColor: '#f9fafb',
                      borderRadius: '8px',
                      border: '1px solid #e5e7eb'
                    }}>
                      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: '8px' }}>
                        <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                          <div style={{
                            width: '12px',
                            height: '12px',
                            borderRadius: '50%',
                            backgroundColor: getSeverityColor(incident.severity)
                          }} />
                          <span style={{ fontSize: '12px', fontWeight: '600', color: '#1f2937' }}>
                            {incident.severity}
                          </span>
                        </div>
                        <span style={{
                          padding: '4px 8px',
                          borderRadius: '4px',
                          fontSize: '10px',
                          fontWeight: '600',
                          backgroundColor: `${getIncidentStatusColor(incident.status)}20`,
                          color: getIncidentStatusColor(incident.status)
                        }}>
                          {incident.status}
                        </span>
                      </div>
                      <div style={{ fontSize: '13px', fontWeight: '500', color: '#1f2937', marginBottom: '4px' }}>
                        {incident.type}
                      </div>
                      <div style={{ fontSize: '12px', color: '#6b7280', marginBottom: '4px' }}>
                        {incident.address}
                      </div>
                      <div style={{ fontSize: '11px', color: '#9ca3af', fontWeight: '500' }}>
                        {incident.id}
                      </div>
                    </div>
                  ))}
                </div>
              </div>

              <div style={{
                backgroundColor: 'white',
                borderRadius: '12px',
                padding: '24px',
                boxShadow: '0 1px 3px rgba(0, 0, 0, 0.1)',
                border: '1px solid #e5e7eb'
              }}>
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '20px' }}>
                  <h3 style={{ fontSize: '18px', fontWeight: '600', color: '#1f2937', margin: 0 }}>
                    Firetruck Locations
                  </h3>
                  <span style={{
                    backgroundColor: '#3b82f6',
                    color: 'white',
                    padding: '4px 8px',
                    borderRadius: '12px',
                    fontSize: '12px',
                    fontWeight: '600'
                  }}>
                    {fireTrucks.length}
                  </span>
                </div>
                <div style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
                  {fireTrucks.map((truck) => (
                    <div key={truck.id} style={{
                      display: 'flex',
                      alignItems: 'center',
                      justifyContent: 'space-between',
                      padding: '12px',
                      backgroundColor: '#f9fafb',
                      borderRadius: '8px',
                      border: '1px solid #e5e7eb'
                    }}>
                      <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
                        <div style={{
                          width: '12px',
                          height: '12px',
                          borderRadius: '50%',
                          backgroundColor: getStatusColor(truck.status)
                        }} />
                        <div>
                          <p style={{ fontSize: '14px', fontWeight: '500', color: '#1f2937', margin: 0 }}>
                            {truck.name}
                          </p>
                          <p style={{ fontSize: '12px', color: '#6b7280', margin: '2px 0 0 0' }}>
                            {truck.unit}
                          </p>
                        </div>
                      </div>
                      <button style={{
                        padding: '6px 12px',
                        backgroundColor: '#3b82f6',
                        color: 'white',
                        border: 'none',
                        borderRadius: '6px',
                        fontSize: '12px',
                        fontWeight: '500',
                        cursor: 'pointer'
                      }}>
                        Track
                      </button>
                    </div>
                  ))}
                </div>
              </div>
            </div>
          </div>
        </main>
    </div>
  );
};

export default LiveMap;
