import 'package:flutter/material.dart';

class Directory extends StatefulWidget {
  const Directory({Key? key}) : super(key: key);

  final String title = "Directory";
  @override
  State<Directory> createState() => _DirectoryState();
}

class _DirectoryState extends State<Directory> {
  // static const calPolyGreen = Color(0xFF003831);
  // static const appBackgroundColor = Color(0xFFE4E3D3);
  // int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Text("Members!"));
  }
}
