import React, { useState, useEffect, useRef } from 'react';
import { gsap } from 'gsap';
import { useTheme } from '../../context/ThemeContext';
import { useThemeStyles } from '../../hooks/useThemeStyles';
import PageHeader from '../../components/PageHeader';
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  BarElement,
  ArcElement,
  Title,
  Tooltip,
  Legend,
  Filler,
  LineController,
  PieController,
  BarController
} from 'chart.js';

ChartJS.register(
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  BarElement,
  ArcElement,
  Title,
  Tooltip,
  Legend,
  Filler,
  LineController,
  PieController,
  BarController
);

const Analytics: React.FC = () => {
  const { theme } = useTheme();
  const { 
    createCardStyle, 
    createButtonStyle, 
    createHeaderStyle, 
    createTextStyle,
    getStatusColor,
    createLayoutStyle,
    createMainContentStyle,
    createSimpleHeaderStyle
  } = useThemeStyles();
  
  const [selectedYear, setSelectedYear] = useState('2024');
  const [animatedValues, setAnimatedValues] = useState({
    totalIncidents: 0,
    resolutionRate: 0,
    responseTime: 0,
    propertySaved: ''
  });

  const chartsRef = useRef<any>({});
  const containerRef = useRef<HTMLDivElement>(null);


  useEffect(() => {
    setAnimatedValues({
      totalIncidents: 825,
      resolutionRate: 96.8,
      responseTime: 8.4,
      propertySaved: '₱2.4'
    });
  }, []);

  const animateValueGSAP = (id: string, start: number, end: number, duration: number, isDecimal = false, prefix = '') => {
    const obj = { value: start };
    
    gsap.to(obj, {
      value: end,
      duration: duration / 1000,
      ease: "power2.out",
      onUpdate: function() {
        setAnimatedValues(prev => ({
          ...prev,
          [id]: isDecimal ? prefix + obj.value.toFixed(1) : prefix + Math.floor(obj.value).toLocaleString()
        }));
      }
    });
  };

  const animateLineChart = (chart: any) => {
    if (!chart) return;
    
    console.log('Chart created successfully');
  };

  useEffect(() => {
  }, []);

  const incidentTrendsData = {
    labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
    datasets: [
      {
        label: 'Incidents',
        data: [65, 72, 68, 81, 76, 85, 92, 88, 79, 84, 78, 82],
        borderColor: '#dc2626',
        backgroundColor: 'rgba(220, 38, 38, 0.1)',
        borderWidth: 3,
        tension: 0.4,
        fill: true,
        pointBackgroundColor: '#dc2626',
        pointBorderColor: '#ffffff',
        pointBorderWidth: 2,
        pointRadius: 5,
        pointHoverRadius: 7
      },
      {
        label: 'Resolved',
        data: [58, 65, 62, 75, 70, 78, 85, 80, 72, 76, 71, 75],
        borderColor: '#10b981',
        backgroundColor: 'rgba(16, 185, 129, 0.1)',
        borderWidth: 3,
        tension: 0.4,
        fill: true,
        pointBackgroundColor: '#10b981',
        pointBorderColor: '#ffffff',
        pointBorderWidth: 2,
        pointRadius: 5,
        pointHoverRadius: 7
      }
    ]
  };

  const incidentsByTypeData = {
    labels: ['Residential', 'Commercial', 'Industrial', 'Vehicle', 'Others'],
    datasets: [
      {
        data: [35, 28, 18, 12, 7],
        backgroundColor: [
          '#dc2626',
          '#f59e0b',
          '#3b82f6',
          '#10b981',
          '#6b7280'
        ],
        borderColor: '#ffffff',
        borderWidth: 3,
        hoverOffset: 15
      }
    ]
  };

  const responseTimeData = {
    labels: ['0-5 min', '5-10 min', '10-15 min', '15-20 min', '20+ min'],
    datasets: [{
      label: 'Number of Incidents',
      data: [180, 120, 60, 30, 15],
      backgroundColor: '#dc2626',
      borderRadius: 8,
      borderWidth: 0
    }]
  };

  const incidentsByLocationData = {
    labels: ['Pagkakaisa', 'BagongSilang', 'San Jose', 'Sta. Monica', 'Sicsican', 'Others'],
    datasets: [{
      label: 'Number of Incidents',
      data: [85, 72, 68, 65, 58, 45],
      backgroundColor: '#dc2626',
      borderRadius: 8,
      borderWidth: 0
    }]
  };

  const chartOptions = {
    responsive: true,
    maintainAspectRatio: false,
    animation: {
      duration: 0
    },
    plugins: {
      legend: {
        display: true,
        position: 'top' as const,
        align: 'end' as const,
        labels: {
          usePointStyle: true,
          padding: 20,
          font: {
            size: 12,
            weight: 'normal' as const
          },
          color: '#1f293b'
        }
      },
      tooltip: {
        mode: 'index' as const,
        intersect: false,
        backgroundColor: '#ffffff',
        titleColor: '#1f293b',
        bodyColor: '#1f293b',
        borderColor: '#e5e7eb',
        borderWidth: 1,
        cornerRadius: 8,
        padding: 12
      }
    },
    scales: {
      y: {
        beginAtZero: true,
        grid: {
          color: '#f1f5f9',
          drawBorder: false
        },
        ticks: {
          font: {
            size: 12
          },
          color: '#64748b',
          padding: 10
        }
      },
      x: {
        grid: {
          display: false,
          drawBorder: false
        },
        ticks: {
          font: {
            size: 12
          },
          color: '#64748b',
          padding: 10
        }
      }
    }
  };

  const pieChartOptions = {
    responsive: true,
    maintainAspectRatio: false,
    animation: {
      duration: 0
    },
    plugins: {
      legend: {
        display: true,
        position: 'bottom' as const,
        labels: {
          usePointStyle: true,
          padding: 20,
          color: '#1f293b',
          font: {
            size: 12,
            weight: 'normal' as const
          },
          generateLabels: function(chart: any) {
            const data = chart.data;
            if (data.labels.length && data.datasets.length) {
              const dataset = data.datasets[0];
              const total = dataset.data.reduce((a: number, b: number) => a + b, 0);
              
              return data.labels.map((label: string, i: number) => {
                const value = dataset.data[i];
                const percentage = ((value / total) * 100).toFixed(1);
                return {
                  text: `${label} (${percentage}%)`,
                  fillStyle: dataset.backgroundColor[i],
                  hidden: false,
                  index: i
                };
              });
            }
            return [];
          }
        }
      },
      tooltip: {
        backgroundColor: '#ffffff',
        titleColor: '#1f293b',
        bodyColor: '#1f293b',
        borderColor: '#e5e7eb',
        borderWidth: 1,
        padding: 12,
        displayColors: true,
        callbacks: {
          label: function(context: any) {
            const label = context.label || '';
            const value = context.parsed;
            const total = context.dataset.data.reduce((a: number, b: number) => a + b, 0);
            const percentage = ((value / total) * 100).toFixed(1);
            return `${label}: ${value} (${percentage}%)`;
          }
        }
      }
    },
    layout: {
      padding: {
        top: 20,
        bottom: 20,
        left: 20,
        right: 20
      }
    }
  };

  const barChartOptions = {
    responsive: true,
    maintainAspectRatio: false,
    animation: {
      duration: 0
    },
    plugins: {
      legend: {
        display: false
      },
      tooltip: {
        backgroundColor: '#ffffff',
        titleColor: '#1f293b',
        bodyColor: '#1f293b',
        borderColor: '#e5e7eb',
        borderWidth: 1,
        cornerRadius: 8,
        padding: 12
      }
    },
    scales: {
      y: {
        beginAtZero: true,
        grid: {
          color: '#f1f5f9',
          drawBorder: false
        },
        ticks: {
          font: {
            size: 12
          },
          color: '#64748b',
          padding: 10
        }
      },
      x: {
        grid: {
          display: false,
          drawBorder: false
        },
        ticks: {
          font: {
            size: 12
          },
          color: '#64748b',
          padding: 10
        }
      }
    }
  };

  const horizontalBarChartOptions = {
    ...barChartOptions,
    indexAxis: 'y' as const,
    scales: {
      x: {
        beginAtZero: true,
        grid: {
          color: '#f1f5f9',
          drawBorder: false
        },
        ticks: {
          font: {
            size: 12
          },
          color: '#64748b',
          padding: 10
        }
      },
      y: {
        grid: {
          display: false,
          drawBorder: false
        },
        ticks: {
          font: {
            size: 12
          },
          color: '#64748b',
          padding: 10
        }
      }
    }
  };

  useEffect(() => {
  }, [selectedYear]);

  useEffect(() => {
    return () => {
      Object.values(chartsRef.current).forEach((chart: any) => {
        if (chart && typeof chart.destroy === 'function') {
          try {
            chart.destroy();
          } catch (error) {
            console.warn('Error destroying chart:', error);
          }
        }
      });
      chartsRef.current = {};
    };
  }, []);

  useEffect(() => {
    return () => {
    };
  }, [selectedYear]);

  const peakIncidentHours = [
    { timeRange: '12:00 PM - 3:00 PM', percentage: 28 },
    { timeRange: '3:00 PM - 6:00 PM', percentage: 24 },
    { timeRange: '9:00 AM - 12:00 PM', percentage: 22 },
  ];

  const casualtiesReport = [
    { type: 'No Casualties', count: 645, percentage: 78 },
    { type: 'Minor Injuries', count: 142, percentage: 17 },
    { type: 'Severe Injuries', count: 32, percentage: 4 },
    { type: 'Fatalities', count: 6, percentage: 0.7 },
  ];

  const propertyDamage = [
    { label: 'Total Damage', value: '₱1.2B', description: 'Estimated losses in 2024' },
    { label: 'Property Saved', value: '₱2.4B', description: 'Value of property protected' },
    { label: 'Avg per Incident', value: '₱1.45M', description: 'Average damage estimate' },
  ];

  return (
    <div style={{ padding: theme.spacing.xl }}>
      <PageHeader 
        title="Analytics & Reports"
        description="Comprehensive fire incident analytics and insights"
        actions={
          <div style={{ display: 'flex', gap: '12px' }}>
            <select
              value={selectedYear}
              onChange={(e) => setSelectedYear(e.target.value)}
              style={{
                padding: `${theme.spacing.sm} ${theme.spacing.md}`,
                border: `1px solid ${theme.colors.border}`,
                borderRadius: theme.borderRadius.md,
                backgroundColor: theme.colors.surface,
                color: theme.colors.text.primary,
                fontSize: '14px',
                cursor: 'pointer'
              }}
            >
              <option value="2024">2024</option>
              <option value="2023">2023</option>
              <option value="2022">2022</option>
            </select>
            <button style={createButtonStyle('primary')}>
              <span className="material-icons" style={{ fontSize: '18px', marginRight: '8px' }}>
                download
              </span>
              Export Report
            </button>
          </div>
        }
      />

      <main>
          <div style={{ 
            display: 'grid', 
            gridTemplateColumns: 'repeat(4, 1fr)', 
            gap: theme.spacing.lg, 
            marginBottom: theme.spacing.xl 
          }}>
            <div style={{
              ...createCardStyle(),
              display: 'flex',
              alignItems: 'flex-start',
              gap: theme.spacing.md
            }}>
              <div style={{
                width: '48px',
                height: '48px',
                borderRadius: '12px',
                background: '#fef2f2',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                flexShrink: 0
              }}>
                <span className="material-icons" style={{ fontSize: '24px', color: '#dc2626' }}>
                  local_fire_department
                </span>
              </div>
              <div style={{ flex: 1 }}>
                <div style={{ fontSize: '12px', fontWeight: '500', color: '#64748b', textTransform: 'uppercase', letterSpacing: '0.5px', marginBottom: '8px' }}>
                  Total Incidents (2024)
                </div>
                <div style={{ fontSize: '28px', fontWeight: '700', color: '#1e293b', marginBottom: '8px', lineHeight: 1 }}>
                  {animatedValues.totalIncidents}
                </div>
                <div style={{ display: 'flex', alignItems: 'center', gap: '4px', fontSize: '12px', fontWeight: '500', color: '#10b981' }}>
                  <span className="material-icons" style={{ fontSize: '16px' }}>trending_up</span>
                  <span>+8.5% from 2023</span>
                </div>
              </div>
            </div>

            <div style={{
              background: 'white',
              borderRadius: '16px',
              padding: '24px',
              boxShadow: '0 1px 3px rgba(0, 0, 0, 0.1)',
              display: 'flex',
              alignItems: 'flex-start',
              gap: '16px'
            }}>
              <div style={{
                width: '48px',
                height: '48px',
                borderRadius: '12px',
                background: '#f0fdf4',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                flexShrink: 0
              }}>
                <span className="material-icons" style={{ fontSize: '24px', color: '#10b981' }}>
                  check_circle
                </span>
              </div>
              <div style={{ flex: 1 }}>
                <div style={{ fontSize: '12px', fontWeight: '500', color: '#64748b', textTransform: 'uppercase', letterSpacing: '0.5px', marginBottom: '8px' }}>
                  Resolution Rate
                </div>
                <div style={{ fontSize: '28px', fontWeight: '700', color: '#1e293b', marginBottom: '8px', lineHeight: 1 }}>
                  {animatedValues.resolutionRate}%
                </div>
                <div style={{ display: 'flex', alignItems: 'center', gap: '4px', fontSize: '12px', fontWeight: '500', color: '#10b981' }}>
                  <span className="material-icons" style={{ fontSize: '16px' }}>trending_up</span>
                  <span>+2.3% improvement</span>
                </div>
              </div>
            </div>

            <div style={{
              background: 'white',
              borderRadius: '16px',
              padding: '24px',
              boxShadow: '0 1px 3px rgba(0, 0, 0, 0.1)',
              display: 'flex',
              alignItems: 'flex-start',
              gap: '16px'
            }}>
              <div style={{
                width: '48px',
                height: '48px',
                borderRadius: '12px',
                background: '#fef3c7',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                flexShrink: 0
              }}>
                <span className="material-icons" style={{ fontSize: '24px', color: '#f59e0b' }}>
                  timer
                </span>
              </div>
              <div style={{ flex: 1 }}>
                <div style={{ fontSize: '12px', fontWeight: '500', color: '#64748b', textTransform: 'uppercase', letterSpacing: '0.5px', marginBottom: '8px' }}>
                  Avg Response Time
                </div>
                <div style={{ fontSize: '28px', fontWeight: '700', color: '#1e293b', marginBottom: '8px', lineHeight: 1 }}>
                  {animatedValues.responseTime} min
                </div>
                <div style={{ display: 'flex', alignItems: 'center', gap: '4px', fontSize: '12px', fontWeight: '500', color: '#10b981' }}>
                  <span className="material-icons" style={{ fontSize: '16px' }}>trending_down</span>
                  <span>-1.2 min faster</span>
                </div>
              </div>
            </div>

            <div style={{
              background: 'white',
              borderRadius: '16px',
              padding: '24px',
              boxShadow: '0 1px 3px rgba(0, 0, 0, 0.1)',
              display: 'flex',
              alignItems: 'flex-start',
              gap: '16px'
            }}>
              <div style={{
                width: '48px',
                height: '48px',
                borderRadius: '12px',
                background: '#eff6ff',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                flexShrink: 0
              }}>
                <span className="material-icons" style={{ fontSize: '24px', color: '#3b82f6' }}>
                  home
                </span>
              </div>
              <div style={{ flex: 1 }}>
                <div style={{ fontSize: '12px', fontWeight: '500', color: '#64748b', textTransform: 'uppercase', letterSpacing: '0.5px', marginBottom: '8px' }}>
                  Property Saved
                </div>
                <div style={{ fontSize: '28px', fontWeight: '700', color: '#1e293b', marginBottom: '8px', lineHeight: 1 }}>
                  {animatedValues.propertySaved}B
                </div>
                <div style={{ display: 'flex', alignItems: 'center', gap: '4px', fontSize: '12px', fontWeight: '500', color: '#10b981' }}>
                  <span className="material-icons" style={{ fontSize: '16px' }}>trending_up</span>
                  <span>+15% increase</span>
                </div>
              </div>
            </div>
          </div>

          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '24px', marginBottom: '32px' }}>
            <div style={{ background: 'transparent', borderRadius: '16px', padding: '24px' }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '24px' }}>
                <h3 style={{ fontSize: '18px', fontWeight: '600', color: '#1e293b', margin: 0 }}>
                  Incident Trends
                </h3>
                <div>
                  <select
                    value={selectedYear}
                    onChange={(e) => setSelectedYear(e.target.value)}
                  >
                    <option value="2024">2024</option>
                    <option value="2023">2023</option>
                    <option value="2022">2022</option>
                  </select>
                </div>
              </div>
              <div style={{ position: 'relative', height: '350px' }}>
                <canvas 
                  ref={(el) => { 
                    if (el) {
                      const ctx = el.getContext('2d');
                      if (ctx) {
                        if (chartsRef.current.incidentTrends) {
                          chartsRef.current.incidentTrends.destroy();
                        }
                        chartsRef.current.incidentTrends = new ChartJS(ctx, {
                          type: 'line',
                          data: incidentTrendsData,
                          options: chartOptions
                        });
                        
                        console.log('Line chart created successfully');
                      }
                    }
                  }}
                />
              </div>
            </div>

            <div style={{ background: 'transparent', borderRadius: '16px', padding: '24px' }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '24px' }}>
                <h3 style={{ fontSize: '18px', fontWeight: '600', color: '#1e293b', margin: 0 }}>
                  Incidents by Type
                </h3>
                <div>
                  <select
                    value={selectedYear}
                    onChange={(e) => setSelectedYear(e.target.value)}
                  >
                    <option value="2024">2024</option>
                    <option value="2023">2023</option>
                  </select>
                </div>
              </div>
              <div style={{ position: 'relative', height: '350px' }}>
                <canvas 
                  ref={(el) => { 
                    if (el) {
                      const ctx = el.getContext('2d');
                      if (ctx) {
                        if (chartsRef.current.incidentsByType) {
                          chartsRef.current.incidentsByType.destroy();
                        }
                        chartsRef.current.incidentsByType = new ChartJS(ctx, {
                          type: 'pie',
                          data: incidentsByTypeData,
                          options: pieChartOptions
                        });
                      }
                    }
                  }}
                />
              </div>
            </div>
          </div>

          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '24px', marginBottom: '32px' }}>
            <div style={{ background: 'transparent', borderRadius: '16px', padding: '24px', minHeight: '450px' }}>
              <h3 style={{ fontSize: '18px', fontWeight: '600', color: '#1e293b', margin: '0 0 24px 0' }}>
                Response Time Distribution
              </h3>
              <div style={{ position: 'relative', height: '300px' }}>
                <canvas 
                  ref={(el) => { 
                    if (el) {
                      const ctx = el.getContext('2d');
                      if (ctx) {
                        if (chartsRef.current.responseTime) {
                          chartsRef.current.responseTime.destroy();
                        }
                        chartsRef.current.responseTime = new ChartJS(ctx, {
                          type: 'bar',
                          data: responseTimeData,
                          options: barChartOptions
                        });
                      }
                    }
                  }}
                />
              </div>
              <div style={{ display: 'flex', alignItems: 'center', gap: '8px', marginTop: '16px', padding: '12px', background: 'transparent', border: 'none' }}>
                <span className="material-icons" style={{ fontSize: '16px', color: '#10b981' }}>trending_up</span>
                <span style={{ fontSize: '12px', color: '#64748b', fontWeight: '500' }}>
                  Average response time has improved by 12% this year
                </span>
              </div>
            </div>

            <div style={{ background: 'transparent', borderRadius: '16px', padding: '24px', minHeight: '450px' }}>
              <h3 style={{ fontSize: '18px', fontWeight: '600', color: '#1e293b', margin: '0 0 24px 0' }}>
                Incidents by Location
              </h3>
              <div style={{ position: 'relative', height: '300px' }}>
                <canvas 
                  ref={(el) => { 
                    if (el) {
                      const ctx = el.getContext('2d');
                      if (ctx) {
                        if (chartsRef.current.incidentsByLocation) {
                          chartsRef.current.incidentsByLocation.destroy();
                        }
                        chartsRef.current.incidentsByLocation = new ChartJS(ctx, {
                          type: 'bar',
                          data: incidentsByLocationData,
                          options: horizontalBarChartOptions
                        });
                      }
                    }
                  }}
                />
              </div>
              <div style={{ display: 'flex', alignItems: 'center', gap: '8px', marginTop: '16px', padding: '12px', background: 'transparent', border: 'none' }}>
                <span className="material-icons" style={{ fontSize: '16px', color: '#10b981' }}>location_on</span>
                <span style={{ fontSize: '12px', color: '#64748b', fontWeight: '500' }}>
                  Quezon City leads with highest incident reports
                </span>
              </div>
            </div>
          </div>

          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: '24px', marginBottom: '32px' }}>
            <div style={{
              background: 'white',
              borderRadius: '16px',
              padding: '24px',
              boxShadow: '0 1px 3px rgba(0, 0, 0, 0.1)',
              display: 'flex',
              flexDirection: 'column',
              height: '100%'
            }}>
              <div style={{ marginBottom: '20px' }}>
                <h3 style={{ fontSize: '18px', fontWeight: '600', color: '#1e293b', margin: 0 }}>
                  Incident Hours
                </h3>
              </div>
              <div style={{ display: 'flex', flexDirection: 'column', gap: '16px', flex: 1 }}>
                {peakIncidentHours.map((hour, index) => (
                  <div key={index} style={{
                    display: 'flex',
                    justifyContent: 'space-between',
                    alignItems: 'center',
                    padding: '12px',
                    background: '#f8fafc',
                    borderRadius: '8px'
                  }}>
                    <div style={{ fontSize: '14px', fontWeight: '500', color: '#1e293b' }}>
                      {hour.timeRange}
                    </div>
                    <div style={{ fontSize: '16px', fontWeight: '700', color: '#dc2626' }}>
                      {hour.percentage}%
                    </div>
                  </div>
                ))}
              </div>
            </div>

            <div style={{
              background: 'white',
              borderRadius: '16px',
              padding: '24px',
              boxShadow: '0 1px 3px rgba(0, 0, 0, 0.1)',
              display: 'flex',
              flexDirection: 'column',
              height: '100%'
            }}>
              <div style={{ marginBottom: '20px' }}>
                <h3 style={{ fontSize: '18px', fontWeight: '600', color: '#1e293b', margin: 0 }}>
                  Casualties Report (2024)
                </h3>
              </div>
              <div style={{ display: 'flex', flexDirection: 'column', gap: '12px', flex: 1 }}>
                {casualtiesReport.map((casualty, index) => (
                  <div key={index} style={{
                    padding: '12px',
                    borderRadius: '8px',
                    transition: 'all 0.3s ease'
                  }}>
                    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', gap: '12px' }}>
                      <div>
                        <div style={{ fontSize: '14px', fontWeight: '500', color: '#1e293b', marginBottom: '4px' }}>
                          {casualty.type}
                        </div>
                        <div style={{ fontSize: '12px', color: '#64748b', fontWeight: '500' }}>
                          {casualty.percentage}% of incidents
                        </div>
                      </div>
                      <div style={{ fontSize: '16px', fontWeight: '700', color: '#1e293b' }}>
                        {casualty.count}
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            </div>

            <div style={{
              background: 'white',
              borderRadius: '16px',
              padding: '24px',
              boxShadow: '0 1px 3px rgba(0, 0, 0, 0.1)',
              display: 'flex',
              flexDirection: 'column',
              height: '100%'
            }}>
              <div style={{ marginBottom: '20px' }}>
                <h3 style={{ fontSize: '18px', fontWeight: '600', color: '#1e293b', margin: 0 }}>
                  Property Damage Analysis
                </h3>
              </div>
              <div style={{ display: 'flex', flexDirection: 'column', gap: '16px', flex: 1 }}>
                {propertyDamage.map((item, index) => (
                  <div key={index} style={{
                    padding: '16px',
                    borderRadius: '8px'
                  }}>
                    <div style={{ fontSize: '12px', fontWeight: '500', color: '#64748b', textTransform: 'uppercase', letterSpacing: '0.5px', marginBottom: '4px' }}>
                      {item.label}
                    </div>
                    <div style={{ fontSize: '20px', fontWeight: '700', color: '#1e293b', marginBottom: '4px' }}>
                      {item.value}
                    </div>
                    <div style={{ fontSize: '12px', color: '#64748b' }}>
                      {item.description}
                    </div>
                  </div>
                ))}
                <div style={{
                  display: 'flex',
                  alignItems: 'center',
                  gap: '8px',
                  padding: '12px',
                  borderRadius: '8px'
                }}>
                  <span className="material-icons" style={{ fontSize: '16px', color: '#3b82f6' }}>trending_down</span>
                  <span style={{ fontSize: '12px', color: '#64748b', fontWeight: '500' }}>
                    67% reduction vs. 2023
                  </span>
                </div>
              </div>
            </div>
          </div>
      </main>
    </div>
    
  );
};

export default Analytics;
