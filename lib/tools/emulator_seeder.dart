import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  await Firebase.initializeApp();

  final firestore = FirebaseFirestore.instance;
  firestore.useFirestoreEmulator('localhost', 8080);

  // Seed users
  await firestore.collection('users').doc('admin123').set({
    'name': 'Admin User',
    'role': 'admin',
  });

  await firestore.collection('users').doc('citizen456').set({
    'name': 'Citizen User',
    'role': 'citizen',
  });

  // Seed alerts
  await firestore.collection('alerts').doc('alert1').set({
    'zone': 'Zone A',
    'severity': 'high',
    'message': 'Air quality alert in Zone A',
  });

  await firestore.collection('alerts').doc('alert2').set({
    'zone': 'Zone B',
    'severity': 'medium',
    'message': 'Water shortage alert in Zone B',
  });

  print('✅ Firestore emulator seeded successfully.');
}
