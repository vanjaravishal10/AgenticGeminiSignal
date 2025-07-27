import 'package:cloud_firestore/cloud_firestore.dart';

class AlertModel {
  final String id;
  final String type;
  final String message;
  final String severity;
  final String source;
  final String userId;
  final dynamic zoneId; // Keep dynamic for flexible parsing (int or string)
  final DateTime? issuedAt;
  final DateTime? expiredAt;
  final String? zoneName;

  AlertModel({
    required this.id,
    required this.type,
    required this.message,
    required this.severity,
    required this.source,
    required this.userId,
    required this.zoneId,
    this.issuedAt,
    this.expiredAt,
    this.zoneName,
  });

  factory AlertModel.fromMap(String id, Map<String, dynamic> map) {
    return AlertModel(
      id: id,
      type: map['type'] ?? '',
      message: map['message'] ?? '',
      severity: map['severity'] ?? '',
      source: map['source'] ?? '',
      userId: map['userId'] ?? '',
      zoneId: map['zoneId'],
      issuedAt: (map['issued_at'] != null && map['issued_at'] is Timestamp)
          ? (map['issued_at'] as Timestamp).toDate()
          : null,
      expiredAt: (map['expired_at'] != null && map['expired_at'] is Timestamp)
          ? (map['expired_at'] as Timestamp).toDate()
          : null,
    );
  }

  AlertModel copyWithZoneName(String zoneName) {
    return AlertModel(
      id: id,
      type: type,
      message: message,
      severity: severity,
      source: source,
      userId: userId,
      zoneId: zoneId,
      issuedAt: issuedAt,
      expiredAt: expiredAt,
      zoneName: zoneName,
    );
  }
}
