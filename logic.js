const data = require('./data.json');

// ------------------ RBAC ------------------
function hasPermission(role, action) {
    const permissions = data.rolesPermissions[role];
    if (!permissions) return false;
    if (permissions.includes("all")) return true;
    return permissions.includes(action);
}

// ------------------ USER LOOKUP (for OTP login) ------------------
function getUserByPhone(phone) {
    const ownerEntry = Object.entries(data.owners).find(
        ([id, o]) => o.phone === phone
    );
    if (ownerEntry) {
        return { id: ownerEntry[0], ...ownerEntry[1], collection: "owners" };
    }

    const workerEntry = Object.entries(data.workers).find(
        ([id, w]) => w.phone === phone
    );
    if (workerEntry) {
        return { id: workerEntry[0], ...workerEntry[1], collection: "workers" };
    }

    return null;
}

// ------------------ LINK UID AFTER OTP LOGIN ------------------
function linkUidToUser(phone, uid) {
    const user = getUserByPhone(phone);
    if (!user) return { success: false, message: "Phone not found" };

    data[user.collection][user.id].uid = uid;
    return { success: true, message: `UID linked to ${user.name}` };
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
function getMonthString(month) {
    const monthMap = {
        "January": "01", "February": "02", "March": "03",
        "April": "04", "May": "05", "June": "06",
        "July": "07", "August": "08", "September": "09",
        "October": "10", "November": "11", "December": "12"
    };
    return monthMap[month] || "03";
}

function calculateSalary(workerId, month) {

    const worker = data.workers[workerId];
    const records = Object.values(data.attendance);
    const monthNum = getMonthString(month);

    let totalHours = 0;
    let totalDeductions = 0;
    let overtimeHours = 0;

    records.forEach(r => {
        if (r.workerId === workerId && r.date.includes(`2026-${monthNum}`)) {
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
        month,
        totalHours,
        grossSalary: Math.round(grossSalary),
        overtimePay: Math.round(overtimePay),
        totalDeductions: Math.round(totalDeductions),
        netSalary: Math.round(netSalary)
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

    const todayStr = new Date().toISOString().split("T")[0];

    data.dashboard.present =
        Object.values(data.attendance).filter(
            a => a.date === todayStr && a.status !== "Absent"
        ).length;

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

// ------------------ TEST OUTPUTS ------------------
console.log("Salary:", calculateSalary("W001", "March"));
console.log("Attendance:", markAttendance("W002", "10:00", "18:00"));
console.log("Order Processing:", processOrder("ORD-2026-001"));
console.log("Report:", generateMonthlyReport("March"));
console.log("User by Phone:", getUserByPhone("+919004311450"));
console.log("Link UID:", linkUidToUser("+919004311450", "firebase-uid-abc123"));

module.exports = {
    hasPermission,
    getUserByPhone,
    linkUidToUser,
    markAttendance,
    calculateSalary,
    processOrder,
    generateAlerts,
    updateDashboard,
    generateMonthlyReport
};
