// lib/screens/dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:csv/csv.dart';
import 'dart:html' as html;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/alert_model.dart';
import '../services/agent_log_service.dart';
//import '../screens/agent_logs_panel_ui.dart';
import '../widgets/agent_logs_panel.dart';


class DashboardScreen extends StatefulWidget {
  final String userId;
  final String role;

  const DashboardScreen({super.key, required this.userId, required this.role});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<AlertModel> alerts = [];
  List<AlertModel> filteredAlerts = [];
  String selectedAlertType = 'All';

  @override
  void initState() {
    super.initState();
    fetchAlerts();
  }

  Future<void> fetchAlerts() async {
	final alertsRef = FirebaseFirestore.instance.collection('alerts');
	QuerySnapshot<Map<String, dynamic>> snapshot;


    if (widget.role == 'admin') {
    // Admin sees all alerts
    snapshot = await alertsRef.get();
  } else {
    // Agent sees only alerts they triggered
    snapshot = await alertsRef.where('agentType', isEqualTo: widget.role).get();
  }

	final List<AlertModel> loadedAlerts = [];

    for (final doc in snapshot.docs) {
      final alert = AlertModel.fromMap(doc.id, doc.data());

      String zoneName = 'Unknown Zone';
      if (alert.zoneId != null) {
        String zoneDocId = 'zone${String.fromCharCode(64 + (alert.zoneId as int))}';
        try {
          final zoneDoc = await FirebaseFirestore.instance
              .collection('zones')
              .doc(zoneDocId)
              .get();

          final zoneData = zoneDoc.data();
          if (zoneDoc.exists && zoneData != null) {
            final name = zoneData['name'];
            if (name != null && name is String && name.trim().isNotEmpty) {
              zoneName = name;
            }
          }
        } catch (e) {
          print('❌ Error loading zone "$zoneDocId": $e');
        }
      }

      loadedAlerts.add(alert.copyWithZoneName(zoneName));
    }

    setState(() {
      alerts = loadedAlerts;
      filteredAlerts = List.from(loadedAlerts);
    });
  }

  void filterAlerts(String type) {
    setState(() {
      selectedAlertType = type;
      if (type == 'All') {
        filteredAlerts = List.from(alerts);
      } else {
        filteredAlerts = alerts.where((alert) => alert.type == type).toList();
      }
    });
  }

  Future<void> exportCSV() async {
    List<List<dynamic>> csvData = [
      ['Type', 'Message', 'Location'],
      ...filteredAlerts.map((alert) => [
            alert.type,
            alert.message,
            alert.zoneName ?? 'Unknown',
          ]),
    ];

    String csv = const ListToCsvConverter().convert(csvData);
    final blob = html.Blob([csv]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute("download", "alerts.csv")
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  Future<void> exportPDF() async {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(
      build: (context) => pw.Column(
        children: filteredAlerts
            .map((alert) => pw.Text(
                'Type: ${alert.type} - ${alert.message} - ${alert.zoneName ?? 'Unknown'}'))
            .toList(),
      ),
    ));

    final bytes = await pdf.save();
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute("download", "alerts.pdf")
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  Widget _buildAlertCard(AlertModel alert) {
    String iconPath = 'assets/icon_general.png';

    switch (alert.type.toLowerCase()) {
      case 'air quality':
      case 'pollution':
        iconPath = 'assets/icon_air_quality.png';
        break;
      case 'flood':
        iconPath = 'assets/icon_flood.png';
        break;
      case 'traffic':
        iconPath = 'assets/icon_traffic.png';
        break;
      case 'fire':
        iconPath = 'assets/icon_fire.png';
        break;
      default:
        iconPath = 'assets/icon_general.png';
    }

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: ListTile(
        leading: Image.asset(iconPath, width: 40),
        title: Text(
          '${alert.type} Alert in ${alert.zoneName ?? 'Unknown Zone'}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          alert.message,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      elevation: 1,
      backgroundColor: Colors.white,
      title: Row(
        children: [
          Image.asset('assets/geminisignal_logo.png', height: 32),
          const SizedBox(width: 8),
          const Text(
            'Geminisignal Dashboard',
            style: TextStyle(color: Colors.black87),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black54),
                children: [
                  const TextSpan(text: 'Logged in as: '),
                  TextSpan(
                    text: widget.userId,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
    body: SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                DropdownButton<String>(
                  value: selectedAlertType,
                  dropdownColor: Colors.white,
                  items: ['All', 'Air Quality', 'Flood', 'Traffic', 'Fire', 'Pollution']
                      .map((type) => DropdownMenuItem<String>(
                            value: type,
                            child: Text(
                              type,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) filterAlerts(value);
                  },
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: exportCSV,
                  icon: const Icon(Icons.download, size: 18),
                  label: const Text("CSV"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A148C),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    elevation: 2,
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: exportPDF,
                  icon: const Icon(Icons.picture_as_pdf, size: 18),
                  label: const Text("PDF"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD32F2F),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    elevation: 2,
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          if (filteredAlerts.isEmpty)
            const Center(
              child: Text("No alerts available", style: TextStyle(color: Colors.black54, fontSize: 16)),
            )
          else
            ListView.builder(
              itemCount: filteredAlerts.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return _buildAlertCard(filteredAlerts[index]);
              },
            ),
          if (widget.role == 'admin')
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Agent Logs',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      AgentLogsPanel(
                        userId: widget.userId,
                        agentType: widget.role,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}
}
