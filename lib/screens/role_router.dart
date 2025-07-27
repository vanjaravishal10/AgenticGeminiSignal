
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_dashboard.dart';
import 'citizen_dashboard.dart';

class RoleRouter extends StatelessWidget {
  final String userId;

  RoleRouter({required this.userId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Scaffold(body: Center(child: Text('User not found')));
        }

        final role = snapshot.data!.get('role') ?? 'citizen';

        if (role == 'admin') {
          return AdminDashboard(userId: userId);
        } else {
          return CitizenDashboard(userId: userId);
        }
      },
    );
  }
}
