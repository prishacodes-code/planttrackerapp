import 'package:flutter/material.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inventory"), backgroundColor: Colors.red, foregroundColor: Colors.white),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _inventoryCard("Essence", "85 liters", "120 liters", true),
          _inventoryCard("Plastic Wrapper", "3500 rolls", "2000 rolls", false),
          _inventoryCard("Sugar", "450 kg", "800 kg", true),
        ],
      ),
    );
  }

  Widget _inventoryCard(String item, String current, String min, bool isLow) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                if (isLow) const Icon(Icons.warning_amber_rounded, color: Colors.red),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Available: $current"),
                Text("Min: $min", style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(value: isLow ? 0.3 : 0.8, color: isLow ? Colors.red : Colors.green),
          ],
        ),
      ),
    );
  }
}