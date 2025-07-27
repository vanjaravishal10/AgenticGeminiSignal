// lib/widgets/agent_logs_panel_ui.dart

import 'package:flutter/material.dart';
import '../services/agent_log_service.dart';

class AgentLogsPanel extends StatelessWidget {
  final List<AgentLog> logs;

  const AgentLogsPanel({super.key, required this.logs});

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text("No agent logs available."),
      );
    }

    final Map<String, List<AgentLog>> grouped = {};
    for (var log in logs) {
      grouped.putIfAbsent(log.agentType, () => []).add(log);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: grouped.entries.map((entry) {
        final type = entry.key;
        final entries = entry.value;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: ExpansionTile(
              title: Text(
                type.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              children: entries.map((log) {
                return ListTile(
                  title: Text(
                    log.action,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Reason: ${log.reason}"),
                      Text("Confidence: ${log.confidence?.toStringAsFixed(2)}"),
                      Text("Triggered: ${log.triggeredAt}"),
                      Text("Zone ID: ${log.zoneId}"),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        );
      }).toList(),
    );
  }
}
