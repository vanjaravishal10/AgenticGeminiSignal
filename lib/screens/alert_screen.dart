import 'package:flutter/material.dart';
import '../services/alert_service.dart';

class AlertScreen extends StatefulWidget {
  final String userId;

  const AlertScreen({required this.userId});

  @override
  _AlertScreenState createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  late Future<List<Map<String, dynamic>>> _alertsFuture;

  @override
  void initState() {
    super.initState();
    _alertsFuture = AlertService.fetchUserAlerts(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Zone Alerts")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _alertsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final alerts = snapshot.data ?? [];

          if (alerts.isEmpty) {
            return Center(child: Text("No active alerts."));
          }

          return ListView.builder(
            itemCount: alerts.length,
            itemBuilder: (context, index) {
              final alert = alerts[index];
              final type = alert['type'] ?? 'Alert';
              final zoneName = alert['zone'] ?? 'Unknown Zone';
              return ListTile(
                title: Text('$type Alert in $zoneName'),
                subtitle: Text(
                    'Severity: ${alert['severity']} | Type: ${alert['type']}'),
              );
            },
          );
        },
      ),
    );
  }
}
