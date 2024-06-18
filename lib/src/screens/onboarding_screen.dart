import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  OnboardingScreenState createState() => OnboardingScreenState();
}

class OnboardingScreenState extends State<OnboardingScreen> {
  late Widget _currentOnboardingScreen;

  Widget buildOnboardingScreen1() {
    return Scaffold(body: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[Image.asset(''),]));
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _currentOnboardingScreen = buildOnboardingScreen1();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _currentOnboardingScreen);
  }
}
