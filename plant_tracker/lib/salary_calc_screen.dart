import 'package:flutter/material.dart';

class SalaryCalcScreen extends StatelessWidget {
  const SalaryCalcScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Salary Calculator"), backgroundColor: Colors.orange[800], foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const TextField(decoration: InputDecoration(labelText: "Basic Salary", prefixIcon: Icon(Icons.money))),
            const SizedBox(height: 15),
            const TextField(decoration: InputDecoration(labelText: "Days Worked", prefixIcon: Icon(Icons.calendar_month))),
            const SizedBox(height: 15),
            const TextField(decoration: InputDecoration(labelText: "Overtime (hrs)", prefixIcon: Icon(Icons.timer))),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange[800], minimumSize: const Size(double.infinity, 50)),
              child: const Text("Calculate Salary", style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}