import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sportsboard/app/app.dart';
import 'package:sportsboard/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
  }
  runApp(const App());
}
