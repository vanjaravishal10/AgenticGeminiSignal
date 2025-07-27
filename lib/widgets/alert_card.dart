// FINAL alert_card.dart after 7 days for hackathon
import 'package:flutter/material.dart';

class AlertCard extends StatelessWidget {
  final String severity;
  final String message;

  const AlertCard({
    super.key,
    required this.severity,
    required this.message,
  });

  Color _getColor() {
    switch (severity.toLowerCase()) {
      case 'high':
        return Colors.redAccent;
      case 'medium':
        return Colors.deepPurpleAccent;
      case 'low':
        return Colors.blueAccent;
      default:
        return Colors.grey;
    }
  }

  IconData _getIcon() {
    switch (severity.toLowerCase()) {
      case 'high':
        return Icons.warning;
      case 'medium':
        return Icons.info;
      case 'low':
        return Icons.check_circle;
      default:
        return Icons.notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _getColor().withOpacity(0.1),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Icon(_getIcon(), color: _getColor(), size: 30),
        title: Text(
          message,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        trailing: Chip(
          label: Text(severity.toUpperCase()),
          backgroundColor: _getColor(),
          labelStyle: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
