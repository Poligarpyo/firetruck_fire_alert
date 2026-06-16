import React, { useState } from 'react';
import { useTheme } from '../../context/ThemeContext';
import { useThemeStyles } from '../../hooks/useThemeStyles';
import PageHeader from '../../components/PageHeader';

const Firetrucks: React.FC = () => {
  const { theme } = useTheme();
  const { createCardStyle, createButtonStyle, createTextStyle, getStatusColor, createLayoutStyle, createMainContentStyle } = useThemeStyles();
  const [selectedTruck, setSelectedTruck] = useState<string | null>(null);
  const [searchTerm, setSearchTerm] = useState('');
  const [statusFilter, setStatusFilter] = useState('all');

  const fireTrucks = [
    {
      id: 'FT-001',
      name: 'Firetruck Alpha',
      unit: 'FT-001',
      type: 'Pumper',
      status: 'RESPONDING',
      location: 'Pagkakaisa, Puerto Princesa City',
      crew: 4,
      captain: 'John Smith',
      equipment: ['Hoses', 'Pumps', 'Ladders'],
      lastMaintenance: '2024-01-15',
      nextMaintenance: '2024-04-15',
    },
    {
      id: 'FT-002',
      name: 'Firetruck Bravo',
      unit: 'FT-002',
      type: 'Pumper',
      status: 'ON-SCENE',
      location: 'Bagong Silang, Puerto Princesa City',
      crew: 4,
      captain: 'Mike Johnson',
      equipment: ['Hoses', 'Pumps', 'Rescue Tools'],
      lastMaintenance: '2024-02-01',
      nextMaintenance: '2024-05-01',
    },
    {
      id: 'FT-003',
      name: 'Firetruck Charlie',
      unit: 'FT-003',
      type: 'Aerial Ladder',
      status: 'AVAILABLE',
      location: 'Fire Station 1',
      crew: 0,
      captain: 'Dave Wilson',
      equipment: ['100ft Ladder', 'Rescue Basket', 'Hoses'],
      lastMaintenance: '2024-03-01',
      nextMaintenance: '2024-03-15',
    },
    {
      id: 'FT-004',
      name: 'Firetruck Delta',
      unit: 'FT-004',
      type: 'Heavy Rescue',
      status: 'MAINTENANCE',
      location: 'Repair Shop',
      crew: 0,
      captain: 'Tom Brown',
      equipment: ['Jaws of Life', 'Medical Kit', 'Rescue Tools'],
      lastMaintenance: '2024-02-15',
      nextMaintenance: '2024-05-15',
    },
  ];

  const getStatusDot = (status: string) => {
    switch (status) {
      case 'RESPONDING': return '#f59e0b';
      case 'ON-SCENE': return '#dc2626';
      case 'AVAILABLE': return '#22c55e';
      case 'OFF-DUTY': return '#6b7280';
      case 'MAINTENANCE': return '#6b7280';
      case 'OUT OF SERVICE': return '#dc2626';
      default: return '#6b7280';
    }
  };

  const selectedTruckData = fireTrucks.find(truck => truck.id === selectedTruck);

  const filteredFireTrucks = fireTrucks.filter(truck => {
    const matchesSearch = truck.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         truck.unit.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         truck.type.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         truck.location.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         truck.status.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesStatus = statusFilter === 'all' || truck.status.toLowerCase() === statusFilter.toLowerCase();
    return matchesSearch && matchesStatus;
  });

  return (
    <div style={{ padding: theme.spacing.xl }}>
      <PageHeader 
        title="Firetrucks"
        description="Manage and track all fire response vehicles"
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
            <div style={{ display: 'flex', gap: '16px', alignItems: 'center' }}>
              <div style={{ flex: 1 }}>
                <input
                  type="text"
                  placeholder="Search firetrucks..."
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
                value={statusFilter}
                onChange={(e) => setStatusFilter(e.target.value)}
              >
                <option value="all">All Status</option>
                <option value="available">Available</option>
                <option value="responding">Responding</option>
                <option value="on-scene">On Scene</option>
                <option value="off-duty">Off Duty</option>
                <option value="maintenance">Maintenance</option>
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
                Add Firetruck
              </button>
            </div>
          </div>

          <div style={{
            display: 'grid',
            gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))',
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
                  <p style={{ fontSize: '14px', color: '#6b7280', margin: 0 }}>Total Firetrucks</p>
                  <p style={{ fontSize: '32px', fontWeight: 'bold', color: '#1f2937', margin: '8px 0 0 0' }}>
                    4
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
                  <p style={{ fontSize: '14px', color: '#6b7280', margin: 0 }}>Available</p>
                  <p style={{ fontSize: '32px', fontWeight: 'bold', color: '#1f2937', margin: '8px 0 0 0' }}>
                    0
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
                    directions_car
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
                  <p style={{ fontSize: '14px', color: '#6b7280', margin: 0 }}>On Scene</p>
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
                    location_on
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
                  <p style={{ fontSize: '14px', color: '#6b7280', margin: 0 }}>Maintenance</p>
                  <p style={{ fontSize: '32px', fontWeight: 'bold', color: '#1f2937', margin: '8px 0 0 0' }}>
                    0
                  </p>
                </div>
                <div style={{
                  width: '48px',
                  height: '48px',
                  backgroundColor: '#6b7280',
                  borderRadius: '12px',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center'
                }}>
                  <span className="material-icons" style={{ fontSize: '24px', color: 'white' }}>
                    build
                  </span>
                </div>
              </div>
            </div>
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
              <div style={{ marginBottom: '20px' }}>
                <h3 style={{ fontSize: '18px', fontWeight: '600', color: '#1f2937', margin: 0 }}>
                  All Units
                </h3>
              </div>
              <div style={{ display: 'flex', flexDirection: 'column', gap: '16px' }}>
                {filteredFireTrucks.map((truck) => (
                  <div
                    key={truck.id}
                    onClick={() => setSelectedTruck(truck.id)}
                    style={{
                      padding: '16px',
                      borderRadius: '12px',
                      border: selectedTruck === truck.id ? '2px solid #dc2626' : '1px solid #e5e7eb',
                      backgroundColor: selectedTruck === truck.id ? '#fef2f2' : 'white',
                      cursor: 'pointer',
                      transition: 'all 0.2s ease'
                    }}
                    onMouseEnter={(e) => {
                      if (selectedTruck !== truck.id) {
                        e.currentTarget.style.backgroundColor = '#f9fafb';
                        e.currentTarget.style.borderColor = '#dc2626';
                      }
                    }}
                    onMouseLeave={(e) => {
                      if (selectedTruck !== truck.id) {
                        e.currentTarget.style.backgroundColor = 'white';
                        e.currentTarget.style.borderColor = '#e5e7eb';
                      }
                    }}
                  >
                    <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: '12px' }}>
                      <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
                        <div style={{
                          width: '12px',
                          height: '12px',
                          borderRadius: '50%',
                          backgroundColor: getStatusDot(truck.status)
                        }} />
                        <div>
                          <h4 style={{ fontSize: '16px', fontWeight: '600', color: '#1f2937', margin: 0 }}>
                            {truck.name}
                          </h4>
                          <p style={{ fontSize: '14px', color: '#6b7280', margin: '2px 0 0 0' }}>
                            {truck.type} • {truck.unit}
                          </p>
                        </div>
                      </div>
                      <div style={{ textAlign: 'right' }}>
                        <span style={{
                          padding: '4px 8px',
                          borderRadius: '4px',
                          fontSize: '11px',
                          fontWeight: '600',
                          backgroundColor: `${getStatusColor(truck.status)}20`,
                          color: getStatusColor(truck.status)
                        }}>
                          {truck.status}
                        </span>
                        <p style={{ fontSize: '12px', color: '#6b7280', margin: '4px 0 0 0' }}>
                          {truck.location}
                        </p>
                      </div>
                    </div>
                    <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '12px', color: '#6b7280' }}>
                      <span>Crew: {truck.crew}/4</span>
                      <span>Next Maintenance: {truck.nextMaintenance}</span>
                    </div>
                  </div>
                ))}
              </div>
            </div>

            <div style={{ display: 'flex', flexDirection: 'column', gap: '24px' }}>
              {selectedTruckData ? (
                <div style={{
                  backgroundColor: 'white',
                  borderRadius: '12px',
                  padding: '24px',
                  boxShadow: '0 1px 3px rgba(0, 0, 0, 0.1)',
                  border: '1px solid #e5e7eb'
                }}>
                  <div style={{ marginBottom: '20px' }}>
                    <h3 style={{ fontSize: '18px', fontWeight: '600', color: '#1f2937', margin: 0 }}>
                      {selectedTruckData.name} Details
                    </h3>
                  </div>
                  <div style={{ display: 'flex', flexDirection: 'column', gap: '16px' }}>
                    <div>
                      <p style={{ fontSize: '12px', fontWeight: '500', color: '#6b7280', margin: 0 }}>Type</p>
                      <p style={{ fontSize: '14px', color: '#1f2937', margin: '4px 0 0 0' }}>{selectedTruckData.type}</p>
                    </div>
                    <div>
                      <p style={{ fontSize: '12px', fontWeight: '500', color: '#6b7280', margin: 0 }}>Status</p>
                      <span style={{
                        padding: '4px 8px',
                        borderRadius: '4px',
                        fontSize: '11px',
                        fontWeight: '600',
                        backgroundColor: `${getStatusColor(selectedTruckData.status)}20`,
                        color: getStatusColor(selectedTruckData.status)
                      }}>
                        {selectedTruckData.status}
                      </span>
                    </div>
                    <div>
                      <p style={{ fontSize: '12px', fontWeight: '500', color: '#6b7280', margin: 0 }}>Current Location</p>
                      <p style={{ fontSize: '14px', color: '#1f2937', margin: '4px 0 0 0' }}>{selectedTruckData.location}</p>
                    </div>
                    <div>
                      <p style={{ fontSize: '12px', fontWeight: '500', color: '#6b7280', margin: 0 }}>Captain</p>
                      <p style={{ fontSize: '14px', color: '#1f2937', margin: '4px 0 0 0' }}>{selectedTruckData.captain}</p>
                    </div>
                    <div>
                      <p style={{ fontSize: '12px', fontWeight: '500', color: '#6b7280', margin: 0 }}>Crew Size</p>
                      <p style={{ fontSize: '14px', color: '#1f2937', margin: '4px 0 0 0' }}>{selectedTruckData.crew}/4</p>
                    </div>
                    <div>
                      <p style={{ fontSize: '12px', fontWeight: '500', color: '#6b7280', margin: 0 }}>Equipment</p>
                      <div style={{ display: 'flex', flexWrap: 'wrap', gap: '4px', marginTop: '4px' }}>
                        {selectedTruckData.equipment.map((item, index) => (
                          <span key={index} style={{
                            padding: '2px 6px',
                            backgroundColor: '#f3f4f6',
                            color: '#4b5563',
                            fontSize: '10px',
                            fontWeight: '500',
                            borderRadius: '4px'
                          }}>
                            {item}
                          </span>
                        ))}
                      </div>
                    </div>
                    <div>
                      <p style={{ fontSize: '12px', fontWeight: '500', color: '#6b7280', margin: 0 }}>Last Maintenance</p>
                      <p style={{ fontSize: '14px', color: '#1f2937', margin: '4px 0 0 0' }}>{selectedTruckData.lastMaintenance}</p>
                    </div>
                    <div>
                      <p style={{ fontSize: '12px', fontWeight: '500', color: '#6b7280', margin: 0 }}>Next Maintenance</p>
                      <p style={{ fontSize: '14px', color: '#1f2937', margin: '4px 0 0 0' }}>{selectedTruckData.nextMaintenance}</p>
                    </div>
                  </div>
                </div>
              ) : (
                <div style={{
                  backgroundColor: 'white',
                  borderRadius: '12px',
                  padding: '24px',
                  boxShadow: '0 1px 3px rgba(0, 0, 0, 0.1)',
                  border: '1px solid #e5e7eb'
                }}>
                  <div style={{ textAlign: 'center', padding: '40px 20px' }}>
                    <span className="material-icons" style={{ fontSize: '48px', color: '#9ca3af', marginBottom: '16px', display: 'block' }}>
                      local_fire_department
                    </span>
                    <p style={{ fontSize: '16px', color: '#6b7280', margin: 0 }}>
                      Select a fire truck to view details
                    </p>
                  </div>
                </div>
              )}
            </div>
          </div>
        </main>
    </div>
  );
};

export default Firetrucks;
