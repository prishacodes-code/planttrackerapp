# 🌿 PlantTracker — Factory Worker Management App

A mobile application built to help small-scale factory owners manage their workers, attendance, salary, inventory, and orders — all in one place.

---

## 👥 Team Members
- Meher Hasija
- Prisha Sharma
- Vinti Tolani
- Khushi Panjwani

---

## 🏭 About the Project
PlantTracker is designed for a real food processing factory. It digitizes the day-to-day management that was previously done manually — tracking who came to work, calculating salaries, monitoring raw material stock, and managing production orders.

---

## ✨ Features
- OTP-based login via Firebase (phone number authentication)
- Worker & Owner roles with different access levels
- Attendance tracking with late deductions and overtime
- Automatic salary calculation based on hours worked
- Inventory monitoring with low stock alerts
- Monthly reports and dashboard summary
- Real-time notifications for low stock

---

## 🛠️ Tech Stack
| Layer | Technology |
|-------|------------|
| Frontend | Flutter (Dart) |
| Backend Logic | JavaScript (Node.js) |
| Database | Firebase Realtime Database |
| Authentication | Firebase Phone Auth (SMS OTP) |

---

## 📁 Project Structure
planttrackerapp/
├── plant_tracker/     # Flutter app (Dart code, UI screens)
├── data.json          # Database schema and seed data
├── logic.js           # Business logic (attendance, salary, orders)
├── auth.js            # OTP authentication and user role detection
└── .gitignore


---

## 🔐 How OTP Login Works
1. Worker/Owner enters their registered phone number
2. Firebase sends an OTP SMS to that number
3. User enters the OTP to verify
4. App checks their role (admin/worker) and shows the right dashboard
5. Owners see full management dashboard, Workers see only their own profile and salary

---

## 👩‍🏭 Workers Managed
7 workers across Production Unit 1, Production Unit 2, Production Unit 3, and Warehouse departments.

---

## 📅 Project Status
✅ Database designed and uploaded to Firebase  
✅ Authentication configured (Phone OTP)  
✅ Business logic implemented  
✅ Flutter app in development
