import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geocoding/geocoding.dart'; // For reverse geocoding

class InfoPage extends StatefulWidget {
  final String userId;

  const InfoPage({super.key, required this.userId});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  String? userName;
  double? latitude;
  double? longitude;
  String? locationAddress;
  String? lastUpdated;

  DatabaseReference? userRef;

  @override
  void initState() {
    super.initState();
    userRef =
        FirebaseDatabase.instance.ref().child('Users').child(widget.userId);
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    userRef?.onValue.listen((event) async {
      if (event.snapshot.value != null) {
        final userData = event.snapshot.value as Map<Object?, Object?>;
        setState(() {
          userName = userData['username'] as String?;
          latitude = userData['latitude'] as double?;
          longitude = userData['longitude'] as double?;
          lastUpdated = userData['lastUpdated'] as String?;
        });
        if (latitude != null && longitude != null) {
          await _getAddressFromCoordinates(latitude!, longitude!);
        }
      }
    });
  }

  Future<void> _getAddressFromCoordinates(double lat, double lon) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        setState(() {
          locationAddress =
              '${placemarks.first.street ?? ''}, ${placemarks.first.subLocality ?? ''}, ${placemarks.first.locality ?? ''}, ${placemarks.first.country ?? ''}';
        });
      } else {
        setState(() {
          locationAddress = 'Location not found';
        });
      }
    } catch (e) {
      print("Error fetching address: $e");
      setState(() {
        locationAddress = 'Error fetching location';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Information'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                userName != null ? 'Welcome, $userName!' : 'Welcome!',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple),
              ),
              const SizedBox(height: 20),
              Text(
                'User ID: ${widget.userId}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                'Latitude: ${latitude?.toStringAsFixed(6) ?? 'N/A'}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                'Longitude: ${longitude?.toStringAsFixed(6) ?? 'N/A'}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                'Location: ${locationAddress ?? 'Fetching location...'}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                'Last Updated: ${lastUpdated != null ? DateTime.parse(lastUpdated!).toLocal().toString() : 'N/A'}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                'Location updates are running in the background every 5 minutes.',
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
