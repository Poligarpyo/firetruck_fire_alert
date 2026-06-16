import React, { useState } from 'react';
import { useTheme } from '../../context/ThemeContext';
import { useThemeStyles } from '../../hooks/useThemeStyles';
import PageHeader from '../../components/PageHeader';

const Users: React.FC = () => {
  const { theme } = useTheme();
  const { createCardStyle, createButtonStyle, createSimpleHeaderStyle, createTextStyle, getStatusColor, createLayoutStyle, createMainContentStyle } = useThemeStyles();
  const [searchTerm, setSearchTerm] = useState('');
  const [roleFilter, setRoleFilter] = useState('all');

  const users = [
    {
      id: '1',
      name: 'John Smith',
      email: 'john.smith@firedept.gov',
      role: 'Administrator',
      department: 'Command',
      status: 'Active',
      lastLogin: '2024-03-18 09:15 AM',
      phone: '+1-555-0101',
      joined: '2022-01-15',
    },
    {
      id: '2',
      name: 'Mike Johnson',
      email: 'mike.johnson@firedept.gov',
      role: 'Fire Chief',
      department: 'Operations',
      status: 'Active',
      lastLogin: '2024-03-18 08:30 AM',
      phone: '+1-555-0102',
      joined: '2021-03-20',
    },
    {
      id: '3',
      name: 'Sarah Williams',
      email: 'sarah.williams@firedept.gov',
      role: 'Operator',
      department: 'Dispatch',
      status: 'Active',
      lastLogin: '2024-03-18 10:45 AM',
      phone: '+1-555-0103',
      joined: '2023-06-10',
    },
    {
      id: '4',
      name: 'Tom Brown',
      email: 'tom.brown@firedept.gov',
      role: 'Captain',
      department: 'Operations',
      status: 'On Duty',
      lastLogin: '2024-03-18 07:00 AM',
      phone: '+1-555-0104',
      joined: '2020-11-05',
    },
    {
      id: '5',
      name: 'Lisa Davis',
      email: 'lisa.davis@firedept.gov',
      role: 'Operator',
      department: 'Dispatch',
      status: 'Off Duty',
      lastLogin: '2024-03-17 06:30 PM',
      phone: '+1-555-0105',
      joined: '2023-02-14',
    },
    {
      id: '6',
      name: 'David Wilson',
      email: 'david.wilson@firedept.gov',
      role: 'Viewer',
      department: 'Analytics',
      status: 'Active',
      lastLogin: '2024-03-18 11:20 AM',
      phone: '+1-555-0106',
      joined: '2023-09-01',
    },
  ];

  const getRoleColor = (role: string) => {
    switch (role) {
      case 'Administrator': return '#8b5cf6';
      case 'Fire Chief': return '#dc2626';
      case 'Captain': return '#3b82f6';
      case 'Operator': return '#22c55e';
      case 'Viewer': return '#6b7280';
      default: return '#6b7280';
    }
  };

  const filteredUsers = users.filter(user => {
    const matchesSearch = user.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         user.email.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         user.department.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesRole = roleFilter === 'all' || user.role === roleFilter;
    return matchesSearch && matchesRole;
  });

  return (
    <div style={{ padding: theme.spacing.xl }}>
      <PageHeader 
        title="User Management"
        description="Manage system users and permissions"
        actions={
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
            Add User
          </button>
        }
      />

      <main style={{ padding: '32px' }}>
        <div style={{ display: 'flex', flexDirection: 'column', gap: '16px' }}>
          <div style={{ display: 'flex', gap: '16px', alignItems: 'center', marginBottom: '24px' }}>
            <div style={{ flex: 1 }}>
              <input
                    type="text"
                    placeholder="Search users..."
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
                  value={roleFilter}
                  onChange={(e) => setRoleFilter(e.target.value)}
                >
                  <option value="all">All Roles</option>
                  <option value="Administrator">Administrator</option>
                  <option value="Fire Chief">Fire Chief</option>
                  <option value="Captain">Captain</option>
                  <option value="Operator">Operator</option>
                  <option value="Viewer">Viewer</option>
                </select>
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
                  <span className="material-icons" style={{ fontSize: '18px' }}>download</span>
                  Export
                </button>
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
                  <p style={{ fontSize: '14px', color: '#6b7280', margin: 0 }}>Total Users</p>
                  <p style={{ fontSize: '32px', fontWeight: 'bold', color: '#1f2937', margin: '8px 0 0 0' }}>
                    {users.length}
                  </p>
                </div>
                <div style={{
                  width: '48px',
                  height: '48px',
                  backgroundColor: '#3b82f6',
                  borderRadius: '12px',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center'
                }}>
                  <span className="material-icons" style={{ fontSize: '24px', color: 'white' }}>
                    people
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
                  <p style={{ fontSize: '14px', color: '#6b7280', margin: 0 }}>Active Users</p>
                  <p style={{ fontSize: '32px', fontWeight: 'bold', color: '#1f2937', margin: '8px 0 0 0' }}>
                    {users.filter(u => u.status === 'Active').length}
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
                  <p style={{ fontSize: '14px', color: '#6b7280', margin: 0 }}>On Duty</p>
                  <p style={{ fontSize: '32px', fontWeight: 'bold', color: '#1f2937', margin: '8px 0 0 0' }}>
                    {users.filter(u => u.status === 'On Duty').length}
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
                    schedule
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
                      User
                    </th>
                    <th style={{ padding: '12px', textAlign: 'left', fontSize: '12px', fontWeight: '600', color: '#6b7280', textTransform: 'uppercase' }}>
                      Role
                    </th>
                    <th style={{ padding: '12px', textAlign: 'left', fontSize: '12px', fontWeight: '600', color: '#6b7280', textTransform: 'uppercase' }}>
                      Department
                    </th>
                    <th style={{ padding: '12px', textAlign: 'left', fontSize: '12px', fontWeight: '600', color: '#6b7280', textTransform: 'uppercase' }}>
                      Status
                    </th>
                    <th style={{ padding: '12px', textAlign: 'left', fontSize: '12px', fontWeight: '600', color: '#6b7280', textTransform: 'uppercase' }}>
                      Last Login
                    </th>
                    <th style={{ padding: '12px', textAlign: 'left', fontSize: '12px', fontWeight: '600', color: '#6b7280', textTransform: 'uppercase' }}>
                      Contact
                    </th>
                    <th style={{ padding: '12px', textAlign: 'left', fontSize: '12px', fontWeight: '600', color: '#6b7280', textTransform: 'uppercase' }}>
                      Actions
                    </th>
                  </tr>
                </thead>
                <tbody>
                  {filteredUsers.map((user) => (
                    <tr key={user.id} style={{ borderBottom: '1px solid #f3f4f6' }}>
                      <td style={{ padding: '16px 12px' }}>
                        <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
                          <div style={{
                            width: '40px',
                            height: '40px',
                            backgroundColor: '#3b82f6',
                            borderRadius: '50%',
                            display: 'flex',
                            alignItems: 'center',
                            justifyContent: 'center',
                            color: 'white',
                            fontWeight: '600',
                            fontSize: '16px'
                          }}>
                            {user.name.split(' ').map(n => n[0]).join('')}
                          </div>
                          <div>
                            <div style={{ fontSize: '14px', fontWeight: '500', color: '#1f2937' }}>
                              {user.name}
                            </div>
                            <div style={{ fontSize: '12px', color: '#6b7280' }}>
                              {user.email}
                            </div>
                          </div>
                        </div>
                      </td>
                      <td style={{ padding: '16px 12px' }}>
                        <span style={{
                          padding: '4px 8px',
                          borderRadius: '4px',
                          fontSize: '11px',
                          fontWeight: '600',
                          backgroundColor: `${getRoleColor(user.role)}20`,
                          color: getRoleColor(user.role)
                        }}>
                          {user.role}
                        </span>
                      </td>
                      <td style={{ padding: '16px 12px', fontSize: '14px', color: '#1f2937' }}>
                        {user.department}
                      </td>
                      <td style={{ padding: '16px 12px' }}>
                        <span style={{
                          padding: '4px 8px',
                          borderRadius: '4px',
                          fontSize: '11px',
                          fontWeight: '600',
                          backgroundColor: `${getStatusColor(user.status)}20`,
                          color: getStatusColor(user.status)
                        }}>
                          {user.status}
                        </span>
                      </td>
                      <td style={{ padding: '16px 12px', fontSize: '14px', color: '#6b7280' }}>
                        {user.lastLogin}
                      </td>
                      <td style={{ padding: '16px 12px', fontSize: '14px', color: '#6b7280' }}>
                        <div>{user.phone}</div>
                        <div style={{ fontSize: '11px', color: '#9ca3af' }}>
                          Joined {user.joined}
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
                            Edit
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
                            View
                          </button>
                        </div>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        </div>
        </main>
    </div>
  );
};

export default Users;
