import 'package:firebase_database/firebase_database.dart';
import 'package:location/location.dart';
import 'package:workmanager/workmanager.dart';

const fetchBackgroundTask = "fetchBackgroundTask";

void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    if (taskName == fetchBackgroundTask) {
      try {
        Location location = Location();
        bool serviceEnabled = await location.serviceEnabled();
        if (!serviceEnabled) {
          serviceEnabled = await location.requestService();
          if (!serviceEnabled) return Future.value(false);
        }

        PermissionStatus permissionGranted = await location.hasPermission();
        if (permissionGranted == PermissionStatus.denied) {
          permissionGranted = await location.requestPermission();
          if (permissionGranted != PermissionStatus.granted) return Future.value(false);
        }

        LocationData locationData = await location.getLocation();

        String? userId = inputData?['userId'];
        if (userId != null) {
          DatabaseReference ref = FirebaseDatabase.instance.ref().child('Users').child(userId);
          await ref.update({
            'latitude': locationData.latitude,
            'longitude': locationData.longitude,
            'lastUpdated': DateTime.now().toIso8601String(),
          });
        }
      } catch (e) {
        print("Background location update error: $e");
      }
    }

    return Future.value(true);
  });
}
