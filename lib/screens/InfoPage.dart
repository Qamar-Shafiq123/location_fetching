// import 'package:flutter/material.dart';

// class Infopage extends StatelessWidget {
//   final Map<dynamic, dynamic> userData;

//   const Infopage({Key? key, required this.userData}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Info Page'),
//         backgroundColor: Colors.deepPurple,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: const Icon(Icons.arrow_back),
//         ),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 "Welcome, ${userData['username']}!",
//                 style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 20),
//               Text("Latitude: ${userData['latitude'] ?? 'N/A'}"),
//               Text("Longitude: ${userData['longitude'] ?? 'N/A'}"),
//               Text("Last Updated: ${userData['lastUpdated'] ?? 'N/A'}"),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:newfirebaseproject/screens/SignUp.dart';

// class Infopage extends StatelessWidget {
//   final Map<dynamic, dynamic> userData;

//   const Infopage({Key? key, required this.userData}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Info Page'),
//         backgroundColor: Colors.deepPurple,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context,
//                 MaterialPageRoute(builder: (context) => const SignUp()));
//           },
//           icon: const Icon(Icons.arrow_back),
//         ),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 "Welcome, ${userData['username'] ?? 'N/A'}!",
//                 style:
//                     const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 20),
//               Text("Latitude: ${userData['latitude'] ?? 'N/A'}"),
//               Text("Longitude: ${userData['longitude'] ?? 'N/A'}"),
//               Text("Last Updated: ${userData['lastUpdated'] ?? 'N/A'}"),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class InfoPage extends StatefulWidget {
  final String userId; // Pass user ID to fetch the user's data

  const InfoPage({super.key, required this.userId});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('Users');

  Map<dynamic, dynamic> userData = {};
  late DatabaseReference userRef;
  late Stream<DatabaseEvent> userStream;

  @override
  void initState() {
    super.initState();
    userRef = _dbRef.child(widget.userId);
    userStream = userRef.onValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Info Page'),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: userStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
            Map<dynamic, dynamic> data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome, ${data['username'] ?? 'N/A'}!",
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Text("Latitude: ${data['latitude'] ?? 'N/A'}"),
                    Text("Longitude: ${data['longitude'] ?? 'N/A'}"),
                    Text("Last Updated: ${data['lastUpdated'] ?? 'N/A'}"),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text("No data found."));
          }
        },
      ),
    );
  }
}
