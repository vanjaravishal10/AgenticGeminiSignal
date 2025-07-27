import 'package:flutter/material.dart';
import 'dashboard.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const userId = 'admin_vishal'; // Firestore document ID in "users"

    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DashboardScreen(userId: userId),
              ),
            );
          },
          child: const Text('Go to Dashboard'),
        ),
      ),
    );
  }
}
