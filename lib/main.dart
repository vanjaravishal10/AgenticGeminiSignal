import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'dart:js' as js; // Optional if needed

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase config for Flutter web
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAVKOcjQ1QtTHR6weHfXeRPjIIt3quJ7tY",
      authDomain: "geminisignaltest-57b01.firebaseapp.com",
      projectId: "geminisignaltest-57b01",
      storageBucket: "geminisignaltest-57b01.firebasestorage.app",
      messagingSenderId: "1056458793645",
      appId: "1:1056458793645:web:72d38ff284770b3f291c24",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GeminiSignal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      home: const LoginScreen(),

    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          // Default to 'citizen' role unless you add Firestore role logic
          return DashboardScreen(
            userId: snapshot.data!.uid,
            role: 'citizen',
          );
        }

        return const LoginScreen();
      },
    );
  }
}
