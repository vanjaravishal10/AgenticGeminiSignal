import 'package:flutter/material.dart';
import '../models/agent_log.dart';
import '../services/agent_log_service.dart';

class AgentLogsScreen extends StatefulWidget {
  const AgentLogsScreen({super.key});

  @override
  State<AgentLogsScreen> createState() => _AgentLogsScreenState();
}

class _AgentLogsScreenState extends State<AgentLogsScreen> {
  late Future<List<AgentLog>> _logsFuture;

  @override
  void initState() {
    super.initState();
    _logsFuture = AgentLogService.fetchAllAgentLogs();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AgentLog>>(
      future: _logsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No agent logs found.'));
        }

        final logs = snapshot.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Agent Logs',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  final log = logs[index];
                  return Card(
                    color: const Color(0xFFF6EDF9),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Text('${log.action} (${log.zoneName})'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(log.reason),
                          Text('Confidence: ${log.confidence.toStringAsFixed(2)}'),
                          Text('Triggered At: ${log.triggeredAt}'),
                          Text('By: ${log.agentType}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
