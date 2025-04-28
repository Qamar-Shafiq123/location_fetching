// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:location/location.dart';
// import 'package:newfirebaseproject/screens/InfoPage.dart';
// import 'package:newfirebaseproject/screens/SignUp.dart';

// // ignore: camel_case_types
// class Firebase_Project extends StatefulWidget {
//   const Firebase_Project({super.key});

//   @override
//   State<Firebase_Project> createState() => _Firebase_ProjectState();
// }

// // ignore: camel_case_types
// class _Firebase_ProjectState extends State<Firebase_Project> {
//   final TextEditingController userNameController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   String? errorMessage;
//   late DatabaseReference databaseReference;

//   @override
//   void initState() {
//     super.initState();
//     databaseReference = FirebaseDatabase.instance.ref().child("Details");
//     requestLocationPermission();
//   }

//   Future<void> requestLocationPermission() async {
//     Location location = Location();

//     bool serviceEnabled = await location.serviceEnabled();
//     if (!serviceEnabled) {
//       await location.requestService();
//     }

//     PermissionStatus permissionGranted = await location.hasPermission();
//     if (permissionGranted == PermissionStatus.denied) {
//       await location.requestPermission();
//     }
//   }

//   void login() async {
//   setState(() {
//     errorMessage = null;
//   });

//   String userName = userNameController.text.trim();
//   String password = passwordController.text;

//   if (userName.isEmpty || password.isEmpty) {
//     setState(() {
//       errorMessage = "Username and password are required.";
//     });
//     return;
//   }
//   if (password.length < 6) {
//     setState(() {
//       errorMessage = "Password must be at least 6 characters.";
//     });
//     return;
//   }

//   try {
//     Query query = databaseReference.orderByChild('username').equalTo(userName);
//     DatabaseEvent event = await query.once();

//     if (event.snapshot.exists) {
//       final data = event.snapshot.value as Map<dynamic, dynamic>;
//       Map<dynamic, dynamic>? userData;
//       bool passwordMatch = false;

//       data.forEach((key, value) {
//         if (value["password"] == password) {
//           passwordMatch = true;
//           userData = value;
//         }
//       });

//       if (passwordMatch && userData != null) {
//         userNameController.clear();
//         passwordController.clear();

//         // Pass userData to Infopage
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => Infopage(userData: userData!),
//           ),
//         );
//       } else {
//         setState(() {
//           errorMessage = "Incorrect password.";
//         });
//       }
//     } else {
//       setState(() {
//         errorMessage = "Account not found. Please Sign Up.";
//       });
//     }
//   } catch (e) {
//     setState(() {
//       errorMessage = "An unexpected error occurred.";
//     });
//   }
// }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 24),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text("Login",
//                     style: TextStyle(color: Colors.deepPurple, fontSize: 28)),
//                 const SizedBox(height: 40),
//                 TextField(
//                   controller: userNameController,
//                   decoration:
//                       const InputDecoration(hintText: "Enter User Name"),
//                 ),
//                 const SizedBox(height: 20),
//                 TextField(
//                   controller: passwordController,
//                   obscureText: true,
//                   decoration: const InputDecoration(hintText: "Enter Password"),
//                 ),
//                 const SizedBox(height: 20),
//                 if (errorMessage != null) ...[
//                   Text(errorMessage!,
//                       style: const TextStyle(color: Colors.red)),
//                   const SizedBox(height: 10),
//                 ],
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 100, vertical: 15),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10)),
//                   ),
//                   onPressed: login,
//                   child: const Text("Login", style: TextStyle(fontSize: 18)),
//                 ),
//                 const SizedBox(height: 20),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const SignUp()));
//                   },
//                   child: const Text("Don't have an account? Sign Up"),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:newfirebaseproject/screens/InfoPage.dart';
// import 'package:newfirebaseproject/screens/SignUp.dart';

// // ignore: camel_case_types
// class Firebase_Project extends StatefulWidget {
//   const Firebase_Project({super.key});

//   @override
//   State<Firebase_Project> createState() => _Firebase_ProjectState();
// }

// // ignore: camel_case_types
// class _Firebase_ProjectState extends State<Firebase_Project> {
//   final TextEditingController userNameController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   String? errorMessage;
//   late DatabaseReference databaseReference;

//   @override
//   void initState() {
//     super.initState();
//     databaseReference = FirebaseDatabase.instance.ref().child("Details");
//   }

//   void login() async {
//     setState(() {
//       errorMessage = null;
//     });

//     String userName = userNameController.text.trim();
//     String password = passwordController.text;

//     if (userName.isEmpty || password.isEmpty) {
//       setState(() {
//         errorMessage = "Username and password are required.";
//       });
//       return;
//     }
//     if (password.length < 6) {
//       setState(() {
//         errorMessage = "Password must be at least 6 characters.";
//       });
//       return;
//     }

//     try {
//       Query query = databaseReference.orderByChild('username').equalTo(userName);
//       DatabaseEvent event = await query.once();

//       if (event.snapshot.exists) {
//         final data = event.snapshot.value as Map<dynamic, dynamic>;
//         Map<dynamic, dynamic>? userData;
//         bool passwordMatch = false;

//         data.forEach((key, value) {
//           if (value["password"] == password) {
//             passwordMatch = true;
//             userData = value;
//           }
//         });

//         if (passwordMatch && userData != null) {
//           userNameController.clear();
//           passwordController.clear();

//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (context) => Infopage(userData: userData!),
//             ),
//           );
//         } else {
//           setState(() {
//             errorMessage = "Incorrect password.";
//           });
//         }
//       } else {
//         setState(() {
//           errorMessage = "Account not found. Please Sign Up.";
//         });
//       }
//     } catch (e) {
//       setState(() {
//         errorMessage = "An unexpected error occurred.";
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 24),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text("Login",
//                     style: TextStyle(color: Colors.deepPurple, fontSize: 28)),
//                 const SizedBox(height: 40),
//                 TextField(
//                   controller: userNameController,
//                   decoration:
//                       const InputDecoration(hintText: "Enter User Name"),
//                 ),
//                 const SizedBox(height: 20),
//                 TextField(
//                   controller: passwordController,
//                   obscureText: true,
//                   decoration: const InputDecoration(hintText: "Enter Password"),
//                 ),
//                 const SizedBox(height: 20),
//                 if (errorMessage != null) ...[
//                   Text(errorMessage!,
//                       style: const TextStyle(color: Colors.red)),
//                   const SizedBox(height: 10),
//                 ],
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 100, vertical: 15),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10)),
//                   ),
//                   onPressed: login,
//                   child: const Text("Login", style: TextStyle(fontSize: 18)),
//                 ),
//                 const SizedBox(height: 20),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const SignUp()));
//                   },
//                   child: const Text("Don't have an account? Sign Up"),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
