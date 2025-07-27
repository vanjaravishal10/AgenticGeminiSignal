class AgentLog {
  final String agentType;
  final String logId;
  final String action;
  final String reason;
  final String triggeredAt;
  final double confidence;
  final int zoneId;
  final String? zoneName; // Optional, used for UI enhancement

  AgentLog({
    required this.agentType,
    required this.logId,
    required this.action,
    required this.reason,
    required this.triggeredAt,
    required this.confidence,
    required this.zoneId,
    this.zoneName,
  });

  factory AgentLog.fromMap({
  required String agentType,
  required String logId,
  required Map<String, dynamic> map,
}) {
  return AgentLog(
    agentType: agentType,
    logId: logId,
    action: map['action'] ?? '',
    reason: map['reason'] ?? '',
    triggeredAt: map['triggered_at']?.toString() ?? '',
    confidence: (map['confidence'] is int)
        ? (map['confidence'] as int).toDouble()
        : (map['confidence'] ?? 0.0).toDouble(),
    zoneId: (map['zoneId'] is int)
        ? map['zoneId']
        : int.tryParse(map['zoneId']?.toString() ?? ''),
  );
}

  AgentLog copyWithZoneName(String zoneName) {
  return AgentLog(
    agentType: agentType,
    logId: logId,
    action: action,
    reason: reason,
    triggeredAt: triggeredAt,
    confidence: confidence,
    zoneId: zoneId,
    zoneName: zoneName,
  );
}

}
