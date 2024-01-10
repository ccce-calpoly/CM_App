import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'CM'),
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
      'Index 0: Home',
      style: optionStyle,
    ),
    const Text(
      'Index 1: Events',
      style: optionStyle,
    ),
    const Text(
      'Index 2: Club Info',
      style: optionStyle,
    ),
    const Text(
      'Index 3: Academics',
      style: optionStyle,
    ),
    const Text(
      'Index 4: Resources',
      style: optionStyle,
    ),
    const Text(
      'Index 5: Profile/Settings',
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
        backgroundColor: calPolyGreen,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
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
            ListTile(
                title: const Text('Profile/Settings',
                    style: TextStyle(color: Color(0xFFFFFFFF))),
                selected: _selectedIndex == 5,
                onTap: () {
                  _onItemTapped(5);
                  Navigator.pop(context);
                }),
          ],
        ),
      ),
    );
  }
}
