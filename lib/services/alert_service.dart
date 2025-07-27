import 'package:cloud_firestore/cloud_firestore.dart';

class AlertService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch all alerts (for admin)
  Future<List<Map<String, dynamic>>> fetchAllAlerts() async {
    try {
      final querySnapshot =
          await _firestore.collection('alerts').orderBy('timestamp', descending: true).get();

      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error fetching all alerts: $e');
      return [];
    }
  }

  /// Fetch alerts for a specific set of zones (for citizen)
  Future<List<Map<String, dynamic>>> fetchAlertsForZones(List<String> zoneIds) async {
    try {
      if (zoneIds.isEmpty) return [];

      final querySnapshot = await _firestore
          .collection('alerts')
          .where('zoneId', whereIn: zoneIds)
          .orderBy('timestamp', descending: true)
          .get();

      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error fetching alerts for zones: $e');
      return [];
    }
  }
}
