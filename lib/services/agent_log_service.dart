import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/agent_log.dart';

class AgentLogService {
  static Future<List<AgentLog>> fetchAllAgentLogs() async {
  final firestore = FirebaseFirestore.instance;
  final logs = <AgentLog>[];

  // Step 1: Build zone map
  final zoneSnapshot = await firestore.collection('zones').get();
  final zoneMap = <int, String>{};
  for (final doc in zoneSnapshot.docs) {
    final data = doc.data();
    final zoneId = data['zoneId'];
    final zoneName = data['name'] ?? 'Unknown Zone';
    if (zoneId != null) {
      zoneMap[zoneId] = zoneName;
    }
  }

  // Step 2: Fetch all logs
  final snapshot = await firestore.collectionGroup('log_values').get();
  for (final doc in snapshot.docs) {
    final data = doc.data();
    final pathSegments = doc.reference.path.split('/');
    final agentType = pathSegments.length >= 2 ? pathSegments[1] : 'Unknown';
    final logId = doc.id;

    final log = AgentLog.fromMap(
      agentType: agentType,
      logId: logId,
      map: data,
    );

    final zoneName = zoneMap[log.zoneId] ?? 'Zone ${log.zoneId}';
    logs.add(log.copyWithZoneName(zoneName));
  }

  return logs;
}



}
