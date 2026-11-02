/**
 * CivicConnect - Chart.js Dynamic Analytics Initializer
 */

function initAdminCharts(categoryData, statusData, monthlyData, departmentData) {
    // 1. Complaints by Category (Doughnut Chart)
    const categoryCtx = document.getElementById('categoryChart');
    if (categoryCtx && categoryData) {
        const labels = Object.keys(categoryData);
        const values = Object.values(categoryData);

        new Chart(categoryCtx, {
            type: 'doughnut',
            data: {
                labels: labels,
                datasets: [{
                    data: values,
                    backgroundColor: [
                        '#3b82f6', '#10b981', '#f59e0b', '#ef4444',
                        '#8b5cf6', '#06b6d4', '#ec4899', '#64748b'
                    ],
                    borderWidth: 2,
                    borderColor: '#ffffff'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { position: 'bottom' }
                },
                cutout: '65%'
            }
        });
    }

    // 2. Complaints by Status (Bar Chart)
    const statusCtx = document.getElementById('statusChart');
    if (statusCtx && statusData) {
        const labels = Object.keys(statusData);
        const values = Object.values(statusData);

        const statusColors = {
            'SUBMITTED': '#3b82f6',
            'UNDER_REVIEW': '#f59e0b',
            'ASSIGNED': '#8b5cf6',
            'IN_PROGRESS': '#0284c7',
            'RESOLVED': '#10b981',
            'REJECTED': '#ef4444'
        };

        const bgColors = labels.map(st => statusColors[st] || '#64748b');

        new Chart(statusCtx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Complaints',
                    data: values,
                    backgroundColor: bgColors,
                    borderRadius: 6
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: { stepSize: 1 }
                    }
                }
            }
        });
    }

    // 3. Monthly Trends (Line Chart)
    const monthlyCtx = document.getElementById('monthlyChart');
    if (monthlyCtx && monthlyData) {
        const labels = Object.keys(monthlyData);
        const values = Object.values(monthlyData);

        new Chart(monthlyCtx, {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Reported Issues',
                    data: values,
                    borderColor: '#0e2a47',
                    backgroundColor: 'rgba(14, 42, 71, 0.08)',
                    fill: true,
                    tension: 0.3,
                    pointRadius: 5,
                    pointHoverRadius: 7
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: { stepSize: 1 }
                    }
                }
            }
        });
    }

    // 4. Department Workload (Horizontal Bar Chart)
    const deptCtx = document.getElementById('departmentChart');
    if (deptCtx && departmentData) {
        const labels = Object.keys(departmentData);
        const values = Object.values(departmentData);

        new Chart(deptCtx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Assigned Complaints',
                    data: values,
                    backgroundColor: '#059669',
                    borderRadius: 6
                }]
            },
            options: {
                indexAxis: 'y',
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false }
                },
                scales: {
                    x: {
                        beginAtZero: true,
                        ticks: { stepSize: 1 }
                    }
                }
            }
        });
    }
}
