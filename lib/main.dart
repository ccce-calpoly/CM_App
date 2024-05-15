import 'package:ccce_application/src/screens/welcome_page.dart';
import 'package:flutter/material.dart';
import 'auth_gate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:isar/isar.dart';
// import 'package:ccce_application/src/screens/profile_screen.dart';
// import 'package:ccce_application/src/screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AuthGate(),
    );
  }
}


// class CMApp extends StatelessWidget {
//   const CMApp({super.key});
//   final String title = 'CM';
//   static const calPolyGreen = Color(0xFF003831);
//   static const appBackgroundColor = Color(0xFFE4E3D3);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: Drawer(
//           child: ListView(children: <Widget>[
//         ListTile(
//           title: const Text('Home'),
//           onTap: () {
//             Navigator.pushReplacement(context,
//                 MaterialPageRoute(builder: (context) => const HomeScreen()));
//           },
//         ),
//         ListTile(
//           title: const Text('Events'),
//           onTap: () {
//             Navigator.pushReplacement(context,
//                 MaterialPageRoute(builder: (context) => const HomeScreen()));
//           },
//         ),
//         ListTile(
//           title: const Text('Club Info'),
//           onTap: () {
//             Navigator.pushReplacement(context,
//                 MaterialPageRoute(builder: (context) => const HomeScreen()));
//           },
//         ),
//         ListTile(
//           title: const Text('Academics'),
//           onTap: () {
//             Navigator.pushReplacement(context,
//                 MaterialPageRoute(builder: (context) => const HomeScreen()));
//           },
//         ),
//         ListTile(
//           title: const Text('Resources'),
//           onTap: () {
//             Navigator.pushReplacement(context,
//                 MaterialPageRoute(builder: (context) => const HomeScreen()));
//           },
//         )
//       ])),
//       appBar: AppBar(
//         leading: Builder(
//           builder: (context) => IconButton(
//               onPressed: () => Scaffold.of(context).openDrawer(),
//               icon: const Icon(Icons.dehaze)),
//         ),
//         backgroundColor: calPolyGreen,
//         centerTitle: true,
//         iconTheme: const IconThemeData(color: Colors.white),
//         title: Text(
//           title,
//           style: const TextStyle(
//             color: Colors.white,
//           ),
//         ),
//         actions: <Widget>[
//           IconButton(
//             icon: const Icon(Icons.account_circle_rounded),
//             tooltip: 'Open Profile',
//             onPressed: () {
//               Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const ProfileScreen()));
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }