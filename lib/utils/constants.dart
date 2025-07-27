import 'package:flutter/material.dart';

/// Standard app padding
const double defaultPadding = 16.0;

/// Severity color codes
const Map<String, Color> severityColors = {
  'Low': Colors.green,
  'Medium': Colors.orange,
  'High': Colors.red,
};

/// Example zone severity thresholds
const Map<String, double> zoneThresholds = {
  'pollution': 75.0,
  'noise': 85.0,
  'temperature': 40.0,
};

/// Firebase Firestore collection paths
const String alertsCollection = 'alerts';
const String usersCollection = 'users';
const String zonesCollection = 'zones';

/// Roles
const String roleAdmin = 'admin';
const String roleCitizen = 'citizen';
