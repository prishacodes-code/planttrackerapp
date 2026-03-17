import 'package:flutter/material.dart';
import 'admin_dashboard.dart';
import 'worker_dashboard.dart';
// Note: You'll need to create a worker_dashboard.dart or similar later!

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // This variable now changes when you click the toggle
  bool isAdmin = true;

  @override
  Widget build(BuildContext context) {
    final primaryColor = isAdmin ? const Color(0xFF1B5E20) : const Color(0xFF3F51B5);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.only(bottomRight: Radius.circular(80)),
              ),
              child: Center(
                child: Text(isAdmin ? "Admin\nManager" : "Worker\nPortal",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  TextField(decoration: InputDecoration(
                      labelText: isAdmin ? "Admin Email" : "Worker ID",
                      prefixIcon: const Icon(Icons.person)
                  )),
                  const SizedBox(height: 20),
                  const TextField(obscureText: true, decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock)
                  )),
                  const SizedBox(height: 30),

                  // --- CHOICE TOGGLE ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Worker"),
                      Switch(
                        value: isAdmin,
                        activeColor: const Color(0xFF1B5E20),
                        onChanged: (value) {
                          setState(() { isAdmin = value; });
                        },
                      ),
                      const Text("Admin"),
                    ],
                  ),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                        onPressed: () {
                          // Logic to choose which dashboard to open
                          if (isAdmin) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const AdminDashboard())
                            );
                          } else {
                            // CHANGE THIS: Replace the SnackBar with the Navigator line below
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const WorkerDashboard())
                            );
                        }
                      },
                      child: const Text("SIGN IN", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}