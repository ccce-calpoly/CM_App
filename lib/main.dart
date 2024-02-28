import 'package:flutter/material.dart';
import 'auth_gate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthGate(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const calPolyGreen = Color(0xFF003831);
  static const appBackgroundColor = Color(0xFFE4E3D3);
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static final List<Widget> _widgetOptions = <Widget>[
    const Text(
      //Index 0
      'Home',
      style: optionStyle,
    ),
    const Text(
      //Index 1
      'Events',
      style: optionStyle,
    ),
    const Text(
      //Index 2
      'Club Info',
      style: optionStyle,
    ),
    const Text(
      //Index 3
      'Academics',
      style: optionStyle,
    ),
    const Text(
      //Index 4
      'Resources',
      style: optionStyle,
    ),
    const Text(
      //Index 5
      'Profile/Settings',
      style: optionStyle,
    )
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
            builder: (context) => IconButton(
                icon: const Icon(Icons.dehaze),
                onPressed: () => Scaffold.of(context).openDrawer())),
        backgroundColor: calPolyGreen,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.account_circle_rounded),
              tooltip: 'Open Profile',
              onPressed: () {
                _onItemTapped(5);
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => const ProfileScreen()));
              })
        ],
      ),
      body: Center(
        child: _widgetOptions[_selectedIndex],
      ),
      backgroundColor: appBackgroundColor, //Still determining background color
      drawer: Drawer(
        backgroundColor: calPolyGreen,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(
              height: 100,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: calPolyGreen,
                ),
                child: Text('Menu'),
              ),
            ),
            ListTile(
                tileColor: calPolyGreen,
                title: const Text('Home',
                    style: TextStyle(color: Color(0xFFFFFFFF))),
                selected: _selectedIndex == 0,
                onTap: () {
                  _onItemTapped(0);
                  Navigator.pop(context);
                }),
            ListTile(
                tileColor: calPolyGreen,
                title: const Text('Events',
                    style: TextStyle(color: Color(0xFFFFFFFF))),
                selected: _selectedIndex == 1,
                onTap: () {
                  _onItemTapped(1);
                  Navigator.pop(context);
                }),
            ListTile(
                title: const Text('Club Info',
                    style: TextStyle(color: Color(0xFFFFFFFF))),
                selected: _selectedIndex == 2,
                onTap: () {
                  _onItemTapped(2);
                  Navigator.pop(context);
                }),
            ListTile(
                title: const Text('Academics',
                    style: TextStyle(color: Color(0xFFFFFFFF))),
                selected: _selectedIndex == 3,
                onTap: () {
                  _onItemTapped(3);
                  Navigator.pop(context);
                }),
            ListTile(
                title: const Text('Resources',
                    style: TextStyle(color: Color(0xFFFFFFFF))),
                selected: _selectedIndex == 4,
                onTap: () {
                  _onItemTapped(4);
                  Navigator.pop(context);
                }),
          ],
        ),
      ),
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