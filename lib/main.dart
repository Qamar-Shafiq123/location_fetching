// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:newfirebaseproject/screens/Login.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Background Location App',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.deepPurple,
//         scaffoldBackgroundColor: const Color(0xFFF5F5F5),
//         inputDecorationTheme: InputDecorationTheme(
//           filled: true,
//           fillColor: Colors.white,
//           contentPadding:
//               const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       ),
//       home: const Firebase_Project(),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:newfirebaseproject/screens/Login.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Background Location App',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.deepPurple,
//         scaffoldBackgroundColor: const Color(0xFFF5F5F5),
//         inputDecorationTheme: InputDecorationTheme(
//           filled: true,
//           fillColor: Colors.white,
//           contentPadding:
//               const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       ),
//       home: const Firebase_Project(),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:newfirebaseproject/screens/SignUp.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Background Location App',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.deepPurple,
//         scaffoldBackgroundColor: const Color(0xFFF5F5F5),
//         inputDecorationTheme: InputDecorationTheme(
//           filled: true,
//           fillColor: Colors.white,
//           contentPadding:
//               const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       ),
//       home: const SignUp(), // 👉 Start directly from SignUp
//     );
//   }
// }
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:location/location.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Location Updater',
//       home: const LocationUpdateScreen(),
//     );
//   }
// }

// class LocationUpdateScreen extends StatefulWidget {
//   const LocationUpdateScreen({super.key});

//   @override
//   State<LocationUpdateScreen> createState() => _LocationUpdateScreenState();
// }

// class _LocationUpdateScreenState extends State<LocationUpdateScreen> {
//   late Timer _timer;
//   final Location _location = Location();
//   final DatabaseReference _dbRef =
//       FirebaseDatabase.instance.ref().child('Users');

//   final String userId = 'user_123'; // Replace with your actual user ID
//   bool _updating = false;

//   @override
//   void initState() {
//     super.initState();
//     startLocationUpdates();
//   }

//   Future<void> startLocationUpdates() async {
//     bool serviceEnabled = await _location.serviceEnabled();
//     if (!serviceEnabled) {
//       serviceEnabled = await _location.requestService();
//       if (!serviceEnabled) {
//         print('Location services are not enabled');
//         return;
//       }
//     }

//     PermissionStatus permissionGranted = await _location.hasPermission();
//     if (permissionGranted == PermissionStatus.denied) {
//       permissionGranted = await _location.requestPermission();
//       if (permissionGranted != PermissionStatus.granted) {
//         print('Location permissions are not granted');
//         return;
//       }
//     }

//     // Immediately fetch location first
//     await updateLocation();

//     // Then schedule periodic updates every 5 minutes
//     _timer = Timer.periodic(const Duration(minutes: 5), (Timer timer) async {
//       await updateLocation();
//     });

//     setState(() {
//       _updating = true;
//     });
//   }

//   Future<void> updateLocation() async {
//     try {
//       LocationData locationData = await _location.getLocation();

//       Map<String, dynamic> updatedData = {
//         'latitude': locationData.latitude,
//         'longitude': locationData.longitude,
//         'lastUpdated': DateTime.now().toIso8601String(),
//       };

//       await _dbRef.child(userId).update(updatedData);

//       print('Location updated: $updatedData');
//     } catch (e) {
//       print('Error updating location: $e');
//     }
//   }

//   @override
//   void dispose() {
//     if (_updating) {
//       _timer.cancel();
//     }
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Location Updater'),
//         backgroundColor: Colors.deepPurple,
//       ),
//       body: const Center(
//         child: Text(
//           'Fetching and Updating Location Every 5 Minutes...',
//           textAlign: TextAlign.center,
//           style: TextStyle(fontSize: 20),
//         ),
//       ),
//     );
//   }
// }
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
