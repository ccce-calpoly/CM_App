import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  final String title = 'CM Home';
  static const calPolyGreen = Color(0xFF003831);
  static const appBackgroundColor = Color(0xFFE4E3D3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Icon(Icons.account_circle_rounded)));
  }
}
