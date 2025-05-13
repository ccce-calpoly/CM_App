import 'package:flutter/material.dart';
// Import your feature files
import 'package:ccce_application/common/features/faculty_directory.dart';
import 'package:ccce_application/common/features/profile_screen.dart';
import 'package:ccce_application/common/features/member_directory.dart';
import 'package:ccce_application/common/features/club_directory.dart';
import 'package:ccce_application/common/features/home_screen.dart';
import 'package:ccce_application/common/widgets/debug_outline.dart';

class RenderedPage extends StatefulWidget {
  const RenderedPage({Key? key}) : super(key: key);

  @override
  _MyRenderedPageState createState() => _MyRenderedPageState();
}

class _MyRenderedPageState extends State<RenderedPage> {
  static const standardGreen = Color(0xFF164734);
  static const tanColor = Color.fromARGB(255, 69, 68, 36);
  static const lighterTanColor = Color(0xFFfffded);
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late List<Widget> _pageList; // Declare _pageList, but don't initialize here

  @override
  void initState() {
    super.initState();
    _pageList = <Widget>[
      // Initialize _pageList here
      HomeScreen(scaffoldKey: _scaffoldKey),
      const MemberDirectory(),
      const ClubDirectory(),
      const FacultyDirectory(),
      Container(),
      const ProfileScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  ListTile createListItem(String title, int index) {
    return ListTile(
        tileColor: lighterTanColor,
        title: Text(title,
            textAlign: TextAlign.right,
            style: const TextStyle(
                fontFamily: "SansSerifProSemiBold",
                color: standardGreen,
                fontSize: 24.0)),
        onTap: () {
          _onItemTapped(index);
          Navigator.pop(context);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Assign the key to the Scaffold
      body: LayoutBuilder(
        // Use LayoutBuilder
        builder: (context, constraints) {
          return Stack(
            // Use Stack to overlay the button
            children: [
              // Position the main content (IndexedStack) below the AppBar
              IndexedStack(
                index: _selectedIndex,
                children: _pageList,
              ),
              // Position the button at the top left, below the AppBar
              // Positioned(
              //   right: 4.0,
              //   top: 0, // Position it exactly below the AppBar
              //   child: IconButton(
              //     icon: const Icon(
              //       Icons.menu,
              //       color: Colors.white,
              //     ),
              //     onPressed: () {
              //       _scaffoldKey.currentState?.openEndDrawer();
              //     },
              //   ),
              // ),
            ],
          );
        },
      ),
      backgroundColor: tanColor,
      endDrawer: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: DebugOutline(
          child: Drawer(
            backgroundColor: lighterTanColor,
            child: SafeArea(
              child: ListView(
                padding: const EdgeInsets.only(right: 24.0),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: IconButton(
                          icon: const Icon(
                            Icons.menu,
                            color: standardGreen,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ],
                  ),
                  createListItem("Home", 0),
                  createListItem("Member Directory", 1),
                  createListItem("Club Directory", 2),
                  createListItem("Faculty Directory", 3),
                  createListItem("Resources", 4),
                  createListItem("Profile", 5),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
