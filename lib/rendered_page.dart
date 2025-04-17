import 'package:ccce_application/common/features/faculty_directory.dart';
import 'package:flutter/material.dart';
import 'package:ccce_application/common/features/profile_screen.dart';
import 'package:ccce_application/common/features/member_directory.dart';
import 'package:ccce_application/common/features/club_directory.dart';

import 'package:ccce_application/common/features/home_screen.dart';

class RenderedPage extends StatefulWidget {
  const RenderedPage({Key? key}) : super(key: key);

  @override
  State<RenderedPage> createState() => _MyRenderedPageState();
}

class _MyRenderedPageState extends State<RenderedPage> {
  static const standardGreen = Color(0xFF164734);
  static const tanColor = Color.fromARGB(255, 69, 68, 36);
  static const lighterTanColor = Color(0xFFfffded);
  int _selectedIndex = 0;
  // static const TextStyle optionStyle =
  //     TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static final List<Widget> _pageList = <Widget>[
    const HomeScreen(),
    const MemberDirectory(),
    const ClubDirectory(),
    const FacultyDirectory(),
    Container(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    //Navigator.pop(context);
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
    // String getTitleText() {
    //   switch (_selectedIndex) {
    //     case 0:
    //       return "Home";
    //     case 1:
    //       return "Member Directory";
    //     case 2:
    //       return "Club Info";
    //     case 3:
    //       return "Academics";
    //     case 4:
    //       return "Resources";
    //     case 5:
    //       return "Profile";
    //     default:
    //       return "Missing Title Text";
    //   }
    // }

    Color getAppBarColor() {
      switch (_selectedIndex) {
        case 0:
          return Colors.amber;
        default:
          return lighterTanColor;
      }
    }

    IconThemeData getIconThemeData() {
      switch (_selectedIndex) {
        case 0:
          return const IconThemeData(color: Colors.white);
        default:
          return const IconThemeData(color: standardGreen);
      }
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: getAppBarColor(),
          elevation: 0.0,
          centerTitle: true,
          iconTheme: getIconThemeData(),
          // title: Text(
          //   getTitleText(),
          //   style: const TextStyle(color: Colors.white),
          // ),
        ),
        body: _pageList[_selectedIndex],
        backgroundColor: tanColor, //Still determining background color
        endDrawer: SizedBox(
          width: MediaQuery.of(context).size.width,
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
                        padding:
                            const EdgeInsets.all(0), // Add padding on the right
                        child: IconButton(
                          icon: const Icon(
                            Icons.dehaze,
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
                  createListItem("Profile", 5)
                ],
              ))),
        ));
  }
}
