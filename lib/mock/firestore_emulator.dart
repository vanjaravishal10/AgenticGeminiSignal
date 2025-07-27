
import 'package:cloud_firestore/cloud_firestore.dart';

void connectToFirestoreEmulator() {
  FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
}
