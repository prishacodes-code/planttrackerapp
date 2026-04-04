const data = require('./data.json');

// ------------------ RBAC ------------------
function hasPermission(role, action) {
    const permissions = data.rolesPermissions[role];
    if (permissions.includes("all")) return true;
    return permissions.includes(action);
}

// ------------------ ATTENDANCE ------------------
function markAttendance(workerId, checkIn, checkOut) {

    const startTime = "09:30";

    const toMinutes = (time) => {
        const [h, m] = time.split(":").map(Number);
        return h * 60 + m;
    };

    const checkInMin = toMinutes(checkIn);
    const startMin = toMinutes(startTime);

    let lateMinutes = Math.max(0, checkInMin - startMin);

    const hoursWorked = (toMinutes(checkOut) - checkInMin) / 60;

    const worker = data.workers[workerId];

    const deduction = (lateMinutes / 60) * worker.hourlyRate;

    return {
        workerId,
        status: lateMinutes > 0 ? "Late" : "Present",
        hoursWorked,
        lateMinutes,
        deduction: Math.round(deduction)
    };
}

// ------------------ SALARY ------------------
function calculateSalary(workerId, month) {

    const worker = data.workers[workerId];
    const records = Object.values(data.attendance);

    let totalHours = 0;
    let totalDeductions = 0;
    let overtimeHours = 0;

    records.forEach(r => {
        if (r.workerId === workerId && r.date.includes("2026-03")) {
            if (r.status !== "Absent") {
                totalHours += r.hoursWorked || 0;
                totalDeductions += r.deduction || 0;
                overtimeHours += r.overtimeHours || 0;
            }
        }
    });

    const grossSalary = totalHours * worker.hourlyRate;

    const overtimePay =
        overtimeHours * worker.hourlyRate *
        data.rules.salary.overtimeMultiplier;

    const netSalary =
        grossSalary + overtimePay - totalDeductions;

    return {
        workerId,
        totalHours,
        grossSalary,
        overtimePay,
        totalDeductions,
        netSalary
    };
}

// ------------------ INVENTORY ------------------
function updateInventoryForOrder(order) {

    Object.values(data.inventory).forEach(item => {
        item.available -= Math.floor(order.quantity * 0.01);

        item.status =
            item.available < item.minStock ? "Low" : "Safe";
    });
}

// ------------------ ALERTS ------------------
function generateAlerts() {

    let alerts = [];

    Object.values(data.inventory).forEach(item => {
        if (item.status === "Low") {
            alerts.push({
                message: `${item.name} is low`,
                severity: "high"
            });
        }
    });

    return alerts;
}

// ------------------ DASHBOARD ------------------
function updateDashboard() {

    data.dashboard.pendingOrders =
        Object.values(data.orders).filter(o => o.status === "Pending").length;

    data.dashboard.completedOrders =
        Object.values(data.orders).filter(o => o.status === "Completed").length;

    data.dashboard.lowStock =
        Object.values(data.inventory).filter(i => i.status === "Low").length;
}

// ------------------ ORDER PROCESS ------------------
function processOrder(orderId) {

    const order = data.orders[orderId];

    if (!order || order.status !== "Pending") return "Invalid";

    order.status = "Processing";

    updateInventoryForOrder(order);

    const alerts = generateAlerts();

    updateDashboard();

    return { order, alerts };
}

// ------------------ REPORT ------------------
function generateMonthlyReport(month) {

    let totalSalary = 0;

    Object.values(data.salary).forEach(s => {
        if (s.month === month) totalSalary += s.netSalary;
    });

    let best = null, worst = null;

    Object.entries(data.workers).forEach(([id, w]) => {
        if (!best || w.attendanceScore > best.score)
            best = { id, score: w.attendanceScore };

        if (!worst || w.attendanceScore < worst.score)
            worst = { id, score: w.attendanceScore };
    });

    return {
        month,
        totalSalary,
        bestWorker: best.id,
        lowestWorker: worst.id
    };
}
