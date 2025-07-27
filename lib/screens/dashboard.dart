import 'package:flutter/material.dart';
import 'screens/alert_screen.dart';

class DashboardScreen extends StatelessWidget {
  final String userId;
  const DashboardScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: Center(
        child: ElevatedButton(
          child: Text('View Alerts'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AlertScreen(userId: userId),
              ),
            );
          },
        ),
      ),
    );
  }
}
