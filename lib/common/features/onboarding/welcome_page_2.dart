import 'package:flutter/material.dart';
import 'package:ccce_application/common/theme/colors.dart';
import 'dart:math';

class WelcomePage2 extends StatelessWidget {
  const WelcomePage2({Key? key}) : super(key: key);

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
                      'Welcome',
                      style: TextStyle(
                          color: AppColors.tanText,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SansSerifPro'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.015),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        style: TextStyle(fontSize: 18, color: Colors.white),
                        children: [
                          TextSpan(
                            text:
                                'Cal Poly Construction Management\'s hub\nfor ',
                          ),
                          TextSpan(
                            text: 'industry connections, club meetings,\n',
                            style: TextStyle(color: AppColors.tanText),
                          ),
                          TextSpan(
                            text: 'event reminders,\n',
                            style: TextStyle(color: AppColors.tanText),
                          ),
                          TextSpan(
                            text: 'and more!',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.12,
              child: Column(children: [
                Image.asset(
                  'assets/icons/two_of_three_dots.png',
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
