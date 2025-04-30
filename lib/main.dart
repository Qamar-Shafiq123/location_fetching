import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:newfirebaseproject/screens/SignUp.dart';
import 'package:newfirebaseproject/screens/background_location_service.dart';
import 'package:workmanager/workmanager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Location Updater',
      home: SignUp(),
    );
  }
}
