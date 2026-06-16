import React, { useState } from 'react';
import { useTheme } from '../../context/ThemeContext';
import { useThemeStyles } from '../../hooks/useThemeStyles';
import PageHeader from '../../components/PageHeader';

const Settings: React.FC = () => {
  const { theme } = useTheme();
  const { 
    createCardStyle, 
    createButtonStyle, 
    createHeaderStyle, 
    createTextStyle,
    createInputStyle,
    createLayoutStyle,
    createMainContentStyle,
    createSimpleHeaderStyle
  } = useThemeStyles();
  const [settings, setSettings] = useState({
    systemName: 'BFP Fire Incident System',
    timeZone: 'Asia/Manila (GMT+8)',
    dateFormat: 'YYYY-MM-DD HH:mm',
    emailNotifications: true,
    smsAlerts: true,
    desktopNotifications: false,
    soundAlerts: true,
    mapCenter: '14.5995° N, 120.9842° E',
    zoomLevel: 8,
    autoRefreshMap: true,
    showTrafficLayer: false,
    theme: 'Light',
    primaryColor: '#DC2626',
    compactMode: false,
    dataRetentionPeriod: '1 Year',
    autoArchiveOldIncidents: true,
    twoFactorAuth: false,
    sessionTimeout: 15,
    activityLogging: true,
  });

  const handleSettingChange = (key: keyof typeof settings, value: any) => {
    setSettings(prev => ({
      ...prev,
      [key]: value
    }));
  };

  return (
    <div style={{ padding: theme.spacing.xl }}>
      <PageHeader 
        title="Settings"
        description="Configure system preferences and options"
        level={2}
      />

      <main>
        <div style={{ display: 'flex', flexDirection: 'column', gap: theme.spacing.lg }}>
        
        <div style={createCardStyle()}>
              <h3 style={createHeaderStyle(3)}>
                General Settings
              </h3>
              <div style={{ display: 'flex', flexDirection: 'column', gap: theme.spacing.lg }}>
                <div>
                  <label style={createTextStyle('primary')}>
                    System Name
                  </label>
                  <input
                    type="text"
                    style={createInputStyle()}
                    value={settings.systemName}
                    onChange={(e) => handleSettingChange('systemName', e.target.value)}
                  />
                </div>
                <div>
                  <label style={createTextStyle('primary')}>
                    Time Zone
                  </label>
                  <select
                    style={{
                      ...createInputStyle(),
                      cursor: 'pointer'
                    }}
                    value={settings.timeZone}
                    onChange={(e) => handleSettingChange('timeZone', e.target.value)}
                  >
                    <option>Asia/Manila (GMT+8)</option>
                    <option>UTC</option>
                    <option>US/Eastern</option>
                    <option>Europe/London</option>
                  </select>
                </div>
                <div>
                  <label style={createTextStyle('primary')}>
                    Date Format
                  </label>
                  <select
                    style={{
                      ...createInputStyle(),
                      cursor: 'pointer'
                    }}
                    value={settings.dateFormat}
                    onChange={(e) => handleSettingChange('dateFormat', e.target.value)}
                  >
                    <option>YYYY-MM-DD HH:mm</option>
                    <option>MM/DD/YYYY HH:mm</option>
                    <option>DD/MM/YYYY HH:mm</option>
                  </select>
                </div>
              </div>
            </div>

            <div style={{
              background: 'white',
              borderRadius: '16px',
              padding: '24px',
              boxShadow: '0 1px 3px rgba(0, 0, 0, 0.1)'
            }}>
              <h3 style={{ fontSize: '18px', fontWeight: '600', color: '#1e293b', marginBottom: '20px' }}>
                Notification Settings
              </h3>
              <div style={{ display: 'flex', flexDirection: 'column', gap: '20px' }}>
                <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                  <div style={{ flex: 1 }}>
                    <p style={{ fontSize: '14px', fontWeight: '600', color: '#1e293b', marginBottom: '4px' }}>
                      Email Notifications
                    </p>
                    <p style={{ fontSize: '12px', color: '#6b7280' }}>
                      Receive incident updates via email
                    </p>
                  </div>
                  <button
                    onClick={() => handleSettingChange('emailNotifications', !settings.emailNotifications)}
                    style={{
                      position: 'relative',
                      display: 'inline-flex',
                      width: '44px',
                      height: '24px',
                      alignItems: 'center',
                      borderRadius: '12px',
                      backgroundColor: settings.emailNotifications ? '#dc2626' : '#d1d5db',
                      border: 'none',
                      cursor: 'pointer',
                      transition: 'background-color 0.2s'
                    }}
                  >
                    <span
                      style={{
                        display: 'inline-block',
                        width: '20px',
                        height: '20px',
                        borderRadius: '50%',
                        backgroundColor: 'white',
                        transform: settings.emailNotifications ? 'translateX(20px)' : 'translateX(2px)',
                        transition: 'transform 0.2s',
                        boxShadow: '0 2px 4px rgba(0, 0, 0, 0.2)'
                      }}
                    />
                  </button>
                </div>
                <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                  <div style={{ flex: 1 }}>
                    <p style={{ fontSize: '14px', fontWeight: '600', color: '#1e293b', marginBottom: '4px' }}>
                      SMS Alerts
                    </p>
                    <p style={{ fontSize: '12px', color: '#6b7280' }}>
                      Send SMS for high-priority incidents
                    </p>
                  </div>
                  <button
                    onClick={() => handleSettingChange('smsAlerts', !settings.smsAlerts)}
                    style={{
                      position: 'relative',
                      display: 'inline-flex',
                      width: '44px',
                      height: '24px',
                      alignItems: 'center',
                      borderRadius: '12px',
                      backgroundColor: settings.smsAlerts ? '#dc2626' : '#d1d5db',
                      border: 'none',
                      cursor: 'pointer',
                      transition: 'background-color 0.2s'
                    }}
                  >
                    <span
                      style={{
                        display: 'inline-block',
                        width: '20px',
                        height: '20px',
                        borderRadius: '50%',
                        backgroundColor: 'white',
                        transform: settings.smsAlerts ? 'translateX(20px)' : 'translateX(2px)',
                        transition: 'transform 0.2s',
                        boxShadow: '0 2px 4px rgba(0, 0, 0, 0.2)'
                      }}
                    />
                  </button>
                </div>
                <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                  <div style={{ flex: 1 }}>
                    <p style={{ fontSize: '14px', fontWeight: '600', color: '#1e293b', marginBottom: '4px' }}>
                      Desktop Notifications
                    </p>
                    <p style={{ fontSize: '12px', color: '#6b7280' }}>
                      Show browser notifications
                    </p>
                  </div>
                  <button
                    onClick={() => handleSettingChange('desktopNotifications', !settings.desktopNotifications)}
                    style={{
                      position: 'relative',
                      display: 'inline-flex',
                      width: '44px',
                      height: '24px',
                      alignItems: 'center',
                      borderRadius: '12px',
                      backgroundColor: settings.desktopNotifications ? '#dc2626' : '#d1d5db',
                      border: 'none',
                      cursor: 'pointer',
                      transition: 'background-color 0.2s'
                    }}
                  >
                    <span
                      style={{
                        display: 'inline-block',
                        width: '20px',
                        height: '20px',
                        borderRadius: '50%',
                        backgroundColor: 'white',
                        transform: settings.desktopNotifications ? 'translateX(20px)' : 'translateX(2px)',
                        transition: 'transform 0.2s',
                        boxShadow: '0 2px 4px rgba(0, 0, 0, 0.2)'
                      }}
                    />
                  </button>
                </div>
                <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                  <div style={{ flex: 1 }}>
                    <p style={{ fontSize: '14px', fontWeight: '600', color: '#1e293b', marginBottom: '4px' }}>
                      Sound Alerts
                    </p>
                    <p style={{ fontSize: '12px', color: '#6b7280' }}>
                      Play sound for new incidents
                    </p>
                  </div>
                  <button
                    onClick={() => handleSettingChange('soundAlerts', !settings.soundAlerts)}
                    style={{
                      position: 'relative',
                      display: 'inline-flex',
                      width: '44px',
                      height: '24px',
                      alignItems: 'center',
                      borderRadius: '12px',
                      backgroundColor: settings.soundAlerts ? '#dc2626' : '#d1d5db',
                      border: 'none',
                      cursor: 'pointer',
                      transition: 'background-color 0.2s'
                    }}
                  >
                    <span
                      style={{
                        display: 'inline-block',
                        width: '20px',
                        height: '20px',
                        borderRadius: '50%',
                        backgroundColor: 'white',
                        transform: settings.soundAlerts ? 'translateX(20px)' : 'translateX(2px)',
                        transition: 'transform 0.2s',
                        boxShadow: '0 2px 4px rgba(0, 0, 0, 0.2)'
                      }}
                    />
                  </button>
                </div>
              </div>
            </div>

            <div style={{
              background: 'white',
              borderRadius: '16px',
              padding: '24px',
              boxShadow: '0 1px 3px rgba(0, 0, 0, 0.1)'
            }}>
              <h3 style={{ fontSize: '18px', fontWeight: '600', color: '#1e293b', marginBottom: '20px' }}>
                Map Settings
              </h3>
              <div style={{ display: 'flex', flexDirection: 'column', gap: '20px' }}>
                <div>
                  <label style={{ display: 'block', fontSize: '14px', fontWeight: '500', color: '#374151', marginBottom: '8px' }}>
                    Default Map Center
                  </label>
                  <input
                    type="text"
                    style={{
                      width: '100%',
                      padding: '12px 16px',
                      border: '1px solid #d1d5db',
                      borderRadius: '8px',
                      fontSize: '14px',
                      outline: 'none',
                      boxSizing: 'border-box'
                    }}
                    value={settings.mapCenter}
                    onChange={(e) => handleSettingChange('mapCenter', e.target.value)}
                  />
                </div>
                <div>
                  <label style={{ display: 'block', fontSize: '14px', fontWeight: '500', color: '#374151', marginBottom: '8px' }}>
                    Default Zoom Level
                  </label>
                  <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
                    <input
                      type="range"
                      min="8"
                      max="18"
                      style={{
                        flex: 1,
                        height: '6px',
                        borderRadius: '3px',
                        background: '#d1d5db',
                        outline: 'none'
                      }}
                      value={settings.zoomLevel}
                      onChange={(e) => handleSettingChange('zoomLevel', parseInt(e.target.value))}
                    />
                    <span style={{ fontSize: '14px', color: '#374151', minWidth: '80px' }}>
                      {settings.zoomLevel} ({settings.zoomLevel <= 10 ? 'Zoomed Out' : 'Zoomed In'})
                    </span>
                  </div>
                </div>
                <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                  <div style={{ flex: 1 }}>
                    <p style={{ fontSize: '14px', fontWeight: '600', color: '#1e293b', marginBottom: '4px' }}>
                      Auto-refresh Map
                    </p>
                    <p style={{ fontSize: '12px', color: '#6b7280' }}>
                      Update map every 30 seconds
                    </p>
                  </div>
                  <button
                    onClick={() => handleSettingChange('autoRefreshMap', !settings.autoRefreshMap)}
                    style={{
                      position: 'relative',
                      display: 'inline-flex',
                      width: '44px',
                      height: '24px',
                      alignItems: 'center',
                      borderRadius: '12px',
                      backgroundColor: settings.autoRefreshMap ? '#dc2626' : '#d1d5db',
                      border: 'none',
                      cursor: 'pointer',
                      transition: 'background-color 0.2s'
                    }}
                  >
                    <span
                      style={{
                        display: 'inline-block',
                        width: '20px',
                        height: '20px',
                        borderRadius: '50%',
                        backgroundColor: 'white',
                        transform: settings.autoRefreshMap ? 'translateX(20px)' : 'translateX(2px)',
                        transition: 'transform 0.2s',
                        boxShadow: '0 2px 4px rgba(0, 0, 0, 0.2)'
                      }}
                    />
                  </button>
                </div>
                <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                  <div style={{ flex: 1 }}>
                    <p style={{ fontSize: '14px', fontWeight: '600', color: '#1e293b', marginBottom: '4px' }}>
                      Show Traffic Layer
                    </p>
                    <p style={{ fontSize: '12px', color: '#6b7280' }}>
                      Display traffic conditions on map
                    </p>
                  </div>
                  <button
                    onClick={() => handleSettingChange('showTrafficLayer', !settings.showTrafficLayer)}
                    style={{
                      position: 'relative',
                      display: 'inline-flex',
                      width: '44px',
                      height: '24px',
                      alignItems: 'center',
                      borderRadius: '12px',
                      backgroundColor: settings.showTrafficLayer ? '#dc2626' : '#d1d5db',
                      border: 'none',
                      cursor: 'pointer',
                      transition: 'background-color 0.2s'
                    }}
                  >
                    <span
                      style={{
                        display: 'inline-block',
                        width: '20px',
                        height: '20px',
                        borderRadius: '50%',
                        backgroundColor: 'white',
                        transform: settings.showTrafficLayer ? 'translateX(20px)' : 'translateX(2px)',
                        transition: 'transform 0.2s',
                        boxShadow: '0 2px 4px rgba(0, 0, 0, 0.2)'
                      }}
                    />
                  </button>
                </div>
              </div>
            </div>

            <div style={{
              background: 'white',
              borderRadius: '16px',
              padding: '24px',
              boxShadow: '0 1px 3px rgba(0, 0, 0, 0.1)'
            }}>
              <h3 style={{ fontSize: '18px', fontWeight: '600', color: '#1e293b', marginBottom: '20px' }}>
                Appearance
              </h3>
              <div style={{ display: 'flex', flexDirection: 'column', gap: '20px' }}>
                <div>
                  <label style={{ display: 'block', fontSize: '14px', fontWeight: '500', color: '#374151', marginBottom: '8px' }}>
                    Theme
                  </label>
                  <select
                    style={{
                      width: '100%',
                      padding: '12px 16px',
                      border: '1px solid #d1d5db',
                      borderRadius: '8px',
                      fontSize: '14px',
                      backgroundColor: 'white',
                      outline: 'none',
                      boxSizing: 'border-box'
                    }}
                    value={settings.theme}
                    onChange={(e) => handleSettingChange('theme', e.target.value)}
                  >
                    <option>Light</option>
                    <option>Dark</option>
                    <option>Auto</option>
                  </select>
                </div>
                <div>
                  <label style={{ display: 'block', fontSize: '14px', fontWeight: '500', color: '#374151', marginBottom: '8px' }}>
                    Primary Color
                  </label>
                  <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
                    <input
                      type="color"
                      style={{
                        width: '50px',
                        height: '40px',
                        border: '1px solid #d1d5db',
                        borderRadius: '8px',
                        cursor: 'pointer'
                      }}
                      value={settings.primaryColor}
                      onChange={(e) => handleSettingChange('primaryColor', e.target.value)}
                    />
                    <input
                      type="text"
                      style={{
                        flex: 1,
                        padding: '12px 16px',
                        border: '1px solid #d1d5db',
                        borderRadius: '8px',
                        fontSize: '14px',
                        outline: 'none',
                        boxSizing: 'border-box'
                      }}
                      value={settings.primaryColor}
                      onChange={(e) => handleSettingChange('primaryColor', e.target.value)}
                    />
                    <span style={{ fontSize: '12px', color: '#6b7280' }}>
                      (Red)
                    </span>
                  </div>
                </div>
                <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                  <div style={{ flex: 1 }}>
                    <p style={{ fontSize: '14px', fontWeight: '600', color: '#1e293b', marginBottom: '4px' }}>
                      Compact Mode
                    </p>
                    <p style={{ fontSize: '12px', color: '#6b7280' }}>
                      Reduce spacing and padding
                    </p>
                  </div>
                  <button
                    onClick={() => handleSettingChange('compactMode', !settings.compactMode)}
                    style={{
                      position: 'relative',
                      display: 'inline-flex',
                      width: '44px',
                      height: '24px',
                      alignItems: 'center',
                      borderRadius: '12px',
                      backgroundColor: settings.compactMode ? '#dc2626' : '#d1d5db',
                      border: 'none',
                      cursor: 'pointer',
                      transition: 'background-color 0.2s'
                    }}
                  >
                    <span
                      style={{
                        display: 'inline-block',
                        width: '20px',
                        height: '20px',
                        borderRadius: '50%',
                        backgroundColor: 'white',
                        transform: settings.compactMode ? 'translateX(20px)' : 'translateX(2px)',
                        transition: 'transform 0.2s',
                        boxShadow: '0 2px 4px rgba(0, 0, 0, 0.2)'
                      }}
                    />
                  </button>
                </div>
              </div>
            </div>

            <div style={{
              background: 'white',
              borderRadius: '16px',
              padding: '24px',
              boxShadow: '0 1px 3px rgba(0, 0, 0, 0.1)'
            }}>
              <h3 style={{ fontSize: '18px', fontWeight: '600', color: '#1e293b', marginBottom: '20px' }}>
                Data Management
              </h3>
              <div style={{ display: 'flex', flexDirection: 'column', gap: '20px' }}>
                <div>
                  <label style={{ display: 'block', fontSize: '14px', fontWeight: '500', color: '#374151', marginBottom: '8px' }}>
                    Data Retention Period
                  </label>
                  <select
                    style={{
                      width: '100%',
                      padding: '12px 16px',
                      border: '1px solid #d1d5db',
                      borderRadius: '8px',
                      fontSize: '14px',
                      backgroundColor: 'white',
                      outline: 'none',
                      boxSizing: 'border-box'
                    }}
                    value={settings.dataRetentionPeriod}
                    onChange={(e) => handleSettingChange('dataRetentionPeriod', e.target.value)}
                  >
                    <option>1 Year</option>
                    <option>2 Years</option>
                    <option>5 Years</option>
                    <option>Forever</option>
                  </select>
                </div>
                <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                  <div style={{ flex: 1 }}>
                    <p style={{ fontSize: '14px', fontWeight: '600', color: '#1e293b', marginBottom: '4px' }}>
                      Auto-archive Old Incidents
                    </p>
                    <p style={{ fontSize: '12px', color: '#6b7280' }}>
                      Archive resolved incidents after 90 days
                    </p>
                  </div>
                  <button
                    onClick={() => handleSettingChange('autoArchiveOldIncidents', !settings.autoArchiveOldIncidents)}
                    style={{
                      position: 'relative',
                      display: 'inline-flex',
                      width: '44px',
                      height: '24px',
                      alignItems: 'center',
                      borderRadius: '12px',
                      backgroundColor: settings.autoArchiveOldIncidents ? '#dc2626' : '#d1d5db',
                      border: 'none',
                      cursor: 'pointer',
                      transition: 'background-color 0.2s'
                    }}
                  >
                    <span
                      style={{
                        display: 'inline-block',
                        width: '20px',
                        height: '20px',
                        borderRadius: '50%',
                        backgroundColor: 'white',
                        transform: settings.autoArchiveOldIncidents ? 'translateX(20px)' : 'translateX(2px)',
                        transition: 'transform 0.2s',
                        boxShadow: '0 2px 4px rgba(0, 0, 0, 0.2)'
                      }}
                    />
                  </button>
                </div>
                <div style={{ display: 'flex', gap: '12px' }}>
                  <button
                    style={{
                      padding: '12px 24px',
                      backgroundColor: '#dc2626',
                      color: 'white',
                      border: 'none',
                      borderRadius: '8px',
                      fontSize: '14px',
                      fontWeight: '500',
                      cursor: 'pointer',
                      transition: 'all 0.3s ease'
                    }}
                    onMouseOver={(e) => {
                      e.currentTarget.style.backgroundColor = '#b91c1c';
                    }}
                    onMouseOut={(e) => {
                      e.currentTarget.style.backgroundColor = '#dc2626';
                    }}
                  >
                    Export All Data
                  </button>
                  <button
                    style={{
                      padding: '12px 24px',
                      backgroundColor: 'white',
                      color: '#dc2626',
                      border: '1px solid #dc2626',
                      borderRadius: '8px',
                      fontSize: '14px',
                      fontWeight: '500',
                      cursor: 'pointer',
                      transition: 'all 0.3s ease'
                    }}
                    onMouseOver={(e) => {
                      e.currentTarget.style.backgroundColor = '#fef2f2';
                    }}
                    onMouseOut={(e) => {
                      e.currentTarget.style.backgroundColor = 'white';
                    }}
                  >
                    Import Data
                  </button>
                </div>
              </div>
            </div>

            <div style={{
              background: 'white',
              borderRadius: '16px',
              padding: '24px',
              boxShadow: '0 1px 3px rgba(0, 0, 0, 0.1)'
            }}>
              <h3 style={{ fontSize: '18px', fontWeight: '600', color: '#1e293b', marginBottom: '20px' }}>
                Security
              </h3>
              <div style={{ display: 'flex', flexDirection: 'column', gap: '20px' }}>
                <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                  <div style={{ flex: 1 }}>
                    <p style={{ fontSize: '14px', fontWeight: '600', color: '#1e293b', marginBottom: '4px' }}>
                      Two-Factor Authentication
                    </p>
                    <p style={{ fontSize: '12px', color: '#6b7280' }}>
                      Require 2FA for all users
                    </p>
                  </div>
                  <button
                    onClick={() => handleSettingChange('twoFactorAuth', !settings.twoFactorAuth)}
                    style={{
                      position: 'relative',
                      display: 'inline-flex',
                      width: '44px',
                      height: '24px',
                      alignItems: 'center',
                      borderRadius: '12px',
                      backgroundColor: settings.twoFactorAuth ? '#dc2626' : '#d1d5db',
                      border: 'none',
                      cursor: 'pointer',
                      transition: 'background-color 0.2s'
                    }}
                  >
                    <span
                      style={{
                        display: 'inline-block',
                        width: '20px',
                        height: '20px',
                        borderRadius: '50%',
                        backgroundColor: 'white',
                        transform: settings.twoFactorAuth ? 'translateX(20px)' : 'translateX(2px)',
                        transition: 'transform 0.2s',
                        boxShadow: '0 2px 4px rgba(0, 0, 0, 0.2)'
                      }}
                    />
                  </button>
                </div>
                <div>
                  <label style={{ display: 'block', fontSize: '14px', fontWeight: '500', color: '#374151', marginBottom: '8px' }}>
                    Session Timeout
                  </label>
                  <p style={{ fontSize: '12px', color: '#6b7280', marginBottom: '8px' }}>
                    Auto-logout after inactivity
                  </p>
                  <select
                    style={{
                      width: '100%',
                      padding: '12px 16px',
                      border: '1px solid #d1d5db',
                      borderRadius: '8px',
                      fontSize: '14px',
                      backgroundColor: 'white',
                      outline: 'none',
                      boxSizing: 'border-box'
                    }}
                    value={settings.sessionTimeout}
                    onChange={(e) => handleSettingChange('sessionTimeout', parseInt(e.target.value))}
                  >
                    <option value={5}>5 minutes</option>
                    <option value={15}>15 minutes</option>
                    <option value={30}>30 minutes</option>
                    <option value={60}>1 hour</option>
                  </select>
                </div>
                <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                  <div style={{ flex: 1 }}>
                    <p style={{ fontSize: '14px', fontWeight: '600', color: '#1e293b', marginBottom: '4px' }}>
                      Activity Logging
                    </p>
                    <p style={{ fontSize: '12px', color: '#6b7280' }}>
                      Track all user actions
                    </p>
                  </div>
                  <button
                    onClick={() => handleSettingChange('activityLogging', !settings.activityLogging)}
                    style={{
                      position: 'relative',
                      display: 'inline-flex',
                      width: '44px',
                      height: '24px',
                      alignItems: 'center',
                      borderRadius: '12px',
                      backgroundColor: settings.activityLogging ? '#dc2626' : '#d1d5db',
                      border: 'none',
                      cursor: 'pointer',
                      transition: 'background-color 0.2s'
                    }}
                  >
                    <span
                      style={{
                        display: 'inline-block',
                        width: '20px',
                        height: '20px',
                        borderRadius: '50%',
                        backgroundColor: 'white',
                        transform: settings.activityLogging ? 'translateX(20px)' : 'translateX(2px)',
                        transition: 'transform 0.2s',
                        boxShadow: '0 2px 4px rgba(0, 0, 0, 0.2)'
                      }}
                    />
                  </button>
                </div>
              </div>
            </div>

            <div style={{
              background: 'white',
              borderRadius: '16px',
              padding: '24px',
              boxShadow: '0 1px 3px rgba(0, 0, 0, 0.1)'
            }}>
              <div style={{ display: 'flex', gap: '12px', justifyContent: 'flex-end' }}>
                <button
                  style={{
                    padding: '12px 24px',
                    backgroundColor: 'white',
                    color: '#6b7280',
                    border: '1px solid #d1d5db',
                    borderRadius: '8px',
                    fontSize: '14px',
                    fontWeight: '500',
                    cursor: 'pointer',
                    transition: 'all 0.3s ease'
                  }}
                  onMouseOver={(e) => {
                    e.currentTarget.style.backgroundColor = '#f9fafb';
                  }}
                  onMouseOut={(e) => {
                    e.currentTarget.style.backgroundColor = 'white';
                  }}
                >
                  Reset to Defaults
                </button>
                <button
                  style={{
                    padding: '12px 24px',
                    backgroundColor: '#dc2626',
                    color: 'white',
                    border: 'none',
                    borderRadius: '8px',
                    fontSize: '14px',
                    fontWeight: '500',
                    cursor: 'pointer',
                    transition: 'all 0.3s ease'
                  }}
                  onMouseOver={(e) => {
                    e.currentTarget.style.backgroundColor = '#b91c1c';
                  }}
                  onMouseOut={(e) => {
                    e.currentTarget.style.backgroundColor = '#dc2626';
                  }}
                >
                  Save Changes
                </button>
              </div>
            </div>

          </div>
      </main>
    </div>
  );
};

export default Settings;
