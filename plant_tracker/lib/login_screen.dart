import 'package:flutter/material.dart';
import 'admin_dashboard.dart';

class LoginScreen extends StatelessWidget {
  final bool isAdmin;
  const LoginScreen({super.key, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    final color = isAdmin ? const Color(0xFF1B5E20) : const Color(0xFF3F51B5);
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 80, 20, 40),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [color, color.withOpacity(0.7)]),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Text(isAdmin ? "Admin Login" : "Worker Login", style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                TextField(decoration: InputDecoration(labelText: isAdmin ? "Email" : "Worker ID", border: const OutlineInputBorder())),
                const SizedBox(height: 20),
                const TextField(obscureText: true, decoration: InputDecoration(labelText: "Password", border: OutlineInputBorder())),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminDashboard())),
                    child: const Text("Login"),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}