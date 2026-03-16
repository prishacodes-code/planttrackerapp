import 'package:flutter/material.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Order Tracking"), backgroundColor: Colors.purple, foregroundColor: Colors.white),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _orderTile("Jeera", "ORD-2026-001", "Processing", Colors.blue),
          _orderTile("Mango", "ORD-2026-002", "Pending", Colors.orange),
          _orderTile("Orange", "ORD-2026-003", "Completed", Colors.green),
        ],
      ),
    );
  }

  Widget _orderTile(String name, String id, String status, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(id),
        trailing: Text(status, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      ),
    );
  }
}