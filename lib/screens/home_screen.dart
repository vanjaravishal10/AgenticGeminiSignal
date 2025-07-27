// FINAL home_screen.dart after 7 days for hackathon
import 'package:flutter/material.dart';
import 'dashboard_screen.dart';

class HomeScreen extends StatelessWidget {
  final String userId;
  const HomeScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return DashboardScreen(userId: userId);
  }
}