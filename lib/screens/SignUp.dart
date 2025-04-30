// ignore: file_names
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:location/location.dart';
import 'package:newfirebaseproject/screens/InfoPage.dart';
import 'package:workmanager/workmanager.dart';

const fetchBackgroundTask = "fetchBackgroundTask";

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController userNameSignUpController =
      TextEditingController();
  final TextEditingController passwordSignUpController =
      TextEditingController();
  String? errorMessage;
  late DatabaseReference databaseReference;
  Location location = Location();

  LocationData? initialLocationData;

  @override
  void initState() {
    super.initState();
    databaseReference = FirebaseDatabase.instance.ref().child("Users");
    requestLocationPermission();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }
    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }
    initialLocationData = await location.getLocation();
  }

  Future<void> requestLocationPermission() async {
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }
  }

  void signUp() async {
    setState(() {
      errorMessage = null;
    });

    String userName = userNameSignUpController.text.trim();
    String password = passwordSignUpController.text;

    if (userName.isEmpty || password.isEmpty) {
      setState(() {
        errorMessage = "Username and password are required.";
      });
      return;
    }
    if (password.length < 6) {
      setState(() {
        errorMessage = "Password must be at least 6 characters.";
      });
      return;
    }

    if (initialLocationData == null) {
      setState(() {
        errorMessage = "Could not get initial location. please try again";
      });
    }

    // LocationData locationData = await location.getLocation();

    DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("Users");
    String newUserKey = usersRef.push().key!;

    Map<String, dynamic> userData = {
      'username': userName,
      'password': password,
      'latitude': initialLocationData!.latitude,
      'longitude': initialLocationData!.longitude,
      'lastUpdated': DateTime.now().toIso8601String(),
    };

    Map<String, Object?> updates = {};
    updates['Users/$newUserKey'] = userData;
    updates['Details/$newUserKey'] = userData;

    try {
      await FirebaseDatabase.instance.ref().update(updates);

      userNameSignUpController.clear();
      passwordSignUpController.clear();

      // Start background worker
      Workmanager().registerPeriodicTask(
        "locationBackgroundTask",
        fetchBackgroundTask,
        frequency: const Duration(minutes: 5),
        inputData: {'userId': newUserKey},
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => InfoPage(userId: newUserKey)),
      );
    } catch (e) {
      setState(() {
        errorMessage = "Failed to register user. Please try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Create Account",
                    style: TextStyle(color: Colors.deepPurple, fontSize: 28)),
                const SizedBox(height: 40),
                TextField(
                  controller: userNameSignUpController,
                  decoration:
                      const InputDecoration(hintText: "Enter User Name"),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: passwordSignUpController,
                  obscureText: true,
                  decoration: const InputDecoration(hintText: "Enter Password"),
                ),
                const SizedBox(height: 20),
                if (errorMessage != null) ...[
                  Text(errorMessage!,
                      style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 10),
                ],
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: signUp,
                  child: const Text("Sign Up", style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
