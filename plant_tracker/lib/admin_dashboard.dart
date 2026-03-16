import 'package:flutter/material.dart';
import 'attendance_screen.dart';
import 'inventory_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(20),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              children: [
                _moduleCard(context, "Attendance", Icons.calendar_month, Colors.green, const AttendanceScreen()),
                _moduleCard(context, "Inventory", Icons.inventory, Colors.red, const InventoryScreen()),
                _moduleCard(context, "Salary", Icons.currency_rupee, Colors.orange, Container()), // Placeholder
                _moduleCard(context, "Orders", Icons.shopping_cart, Colors.purple, Container()), // Placeholder
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFF1B5E20), Color(0xFF4CAF50)]),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Good Morning, Admin 👋", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          Text("Friday, March 6, 2026", style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _moduleCard(BuildContext context, String title, IconData icon, Color color, Widget screen) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => screen)),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 5)]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 40),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}