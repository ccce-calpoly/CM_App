import 'package:ccce_application/common/features/onboarding/tos_screen.dart';
import 'package:flutter/material.dart';
import 'package:ccce_application/common/theme/colors.dart';
import 'package:flutter/services.dart'; // Import for asset loading

class WelcomePage3 extends StatelessWidget {
  const WelcomePage3({Key? key}) : super(key: key);

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
                        top: screenHeight * 0.12, bottom: screenHeight * 0.08),
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
                                'Before we get started, make sure you\nagree to our ',
                          ),
                          TextSpan(
                            text: 'Terms & Conditions',
                            style: TextStyle(
                                color: AppColors.tanText,
                                fontWeight: FontWeight.w600),
                          ),
                          TextSpan(
                            text: '.',
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
                Padding(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.03),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TosScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkGold,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                      shape:
                          const RoundedRectangleBorder(), // No argument in RoundedRectangleBorder is Square border
                    ),
                    child: const Text(
                      'TERMS & CONDITIONS',
                      style: TextStyle(
                        color: AppColors.calPolyGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Image.asset(
                  'assets/icons/three_of_three_dots.png',
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
