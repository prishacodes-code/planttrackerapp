import 'package:flutter/material.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      appBar: AppBar(title: const Text("Attendance Management"), backgroundColor: Colors.green, foregroundColor: Colors.white),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _workerCard("Rahul Sharma", "W001", "9:05 AM", "Present", Colors.green),
          _workerCard("Priya Patel", "W002", "9:12 AM", "Present", Colors.green),
          _workerCard("Amit Kumar", "W003", "No check-in", "Absent", Colors.red),
          _workerCard("Sunita Devi", "W004", "8:35 AM", "Late", Colors.orange),
        ],
      ),
    );
  }

  Widget _workerCard(String name, String id, String time, String status, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color.withOpacity(0.1), child: Icon(Icons.person, color: color)),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("ID: $id • Time: $time"),
        trailing: Chip(label: Text(status, style: const TextStyle(fontSize: 10, color: Colors.white)), backgroundColor: color),
      ),
    );
  }
}