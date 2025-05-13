import 'package:ccce_application/common/widgets/gold_app_bar.dart';
import 'package:flutter/material.dart';
import 'welcome_page_1.dart';
import 'welcome_page_2.dart';
import 'welcome_page_3.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController(initialPage: 0);
  final List<Widget> _pages = const [
    WelcomePage1(),
    WelcomePage2(),
    WelcomePage3(),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            physics: const ClampingScrollPhysics(),
            children: _pages,
          ),
        ],
      ),
    );
  }
}
