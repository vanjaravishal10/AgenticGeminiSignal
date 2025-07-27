
import 'package:flutter/material.dart';

class AlertBadge extends StatelessWidget {
  final String severity;

  AlertBadge({required this.severity});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (severity.toLowerCase()) {
      case 'high':
        color = Colors.red;
        break;
      case 'medium':
        color = Colors.purple;
        break;
      case 'low':
      default:
        color = Colors.blue;
        break;
    }

    return Container(
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
