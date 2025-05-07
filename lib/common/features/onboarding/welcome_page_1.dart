import 'package:flutter/material.dart';
import 'package:ccce_application/common/theme/colors.dart';

class WelcomePage1 extends StatelessWidget {
  const WelcomePage1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final smallerSide = screenWidth < screenHeight ? screenWidth : screenHeight;

    return Scaffold(
      backgroundColor: AppColors.calPolyGreen,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: screenHeight * 0.12, bottom: screenHeight * .08),
                    child: Image.asset(
                      'assets/icons/cal_poly_white.png',
                      scale: 0.8,
                      height: smallerSide * 0.1,
                      width: smallerSide * 0.9,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: screenHeight * 0.05),
                    child: Image.asset('assets/icons/hardhat.png'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.05),
                    child: const Text(
                      'Welcome to',
                      style: TextStyle(
                          color: AppColors.tanText,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SansSerifPro'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.015),
                    child: const Text(
                      'CPCM',
                      style: TextStyle(fontSize: 36, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.12, // 30 pixels from the bottom
              child: Image.asset(
                'assets/icons/one_of_three_dots.png',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
