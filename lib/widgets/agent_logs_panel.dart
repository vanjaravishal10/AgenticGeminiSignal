import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AgentLogsPanel extends StatelessWidget {
  final String userId;
  final String agentType;

  const AgentLogsPanel({
    Key? key,
    required this.userId,
    required this.agentType,
  }) : super(key: key);

  Future<List<Map<String, dynamic>>> _fetchAgentLogs() async {
  final firestore = FirebaseFirestore.instance;
  final logs = <Map<String, dynamic>>[];

  final snapshot = await firestore.collectionGroup('log_values').get();

  for (final doc in snapshot.docs) {
    final data = doc.data();
    final path = doc.reference.path.split('/');
    
    // Extract agentType and zoneId from Firestore path
    // Example path: agent_logs/trafficAgent/zone1/log_values/log_001
    final agentType = path.length >= 2 ? path[1] : 'Unknown';
    final zoneIdRaw = path.length >= 3 ? path[2] : 'zone0';
    final zoneId = zoneIdRaw.replaceAll(RegExp(r'[^0-9]'), '');

    logs.add({
      'agent': agentType,
      'zoneId': zoneId,
      'action': data['action'] ?? '',
      'confidence': data['confidence'] ?? 0,
      'reason': data['reason'] ?? '',
      'triggered_at': data['triggered_at']?.toString() ?? '',
    });
  }

  return logs;
}


  IconData _getIconForAgent(String agent) {
    switch (agent) {
      case 'trafficAgent':
        return Icons.traffic;
      case 'emergencyAgent':
        return Icons.local_hospital;
      case 'pollutionAgent':
        return Icons.cloud;
      case 'weatherAgent':
        return Icons.wb_cloudy;
      default:
        return Icons.device_unknown;
    }
  }

  String _formatAgentName(String raw) {
    switch (raw) {
      case 'trafficAgent':
        return 'Traffic Agent';
      case 'emergencyAgent':
        return 'Emergency Agent';
      case 'pollutionAgent':
        return 'Pollution Agent';
      case 'weatherAgent':
        return 'Weather Agent';
      default:
        return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchAgentLogs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text('No agent logs found.'),
          );
        }

        final logs = snapshot.data!;

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: logs.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final log = logs[index];
            final icon = _getIconForAgent(log['agent']);
            final agentName = _formatAgentName(log['agent']);

            return ListTile(
              leading: Icon(icon, color: Colors.deepPurple),
              title: Text(
                '${log['action']} (Zone ${log['zoneId']})',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${log['reason']}'),
                  Text('Confidence: ${log['confidence']}'),
                  Text('Triggered At: ${log['triggered_at']}'),
                  Text('By: $agentName'),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
