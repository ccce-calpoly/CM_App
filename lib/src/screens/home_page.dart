// NOT BEING USED

import 'package:flutter/material.dart';
import 'package:ccce_application/src/screens/profile_screen.dart';

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
  // static const TextStyle optionStyle =
  //     TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static final List<Widget> _widgetOptions = <Widget>[
    // const HomeScreen(),
    Container(),
    Container(),
    Container(),
    Container(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const MyHomePage(
                      title: "CM Home",
                    )));
        break;
      case 1:
        Null;
        break;
      case 2:
        Null;
        break;
      case 3:
        Null;
        break;
      case 4:
        Null;
        break;
      case 5:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ProfileScreen()));
        break;
    }
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context);
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
      body: _widgetOptions[_selectedIndex],
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
