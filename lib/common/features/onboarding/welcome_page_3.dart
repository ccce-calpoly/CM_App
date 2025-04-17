import 'package:ccce_application/common/features/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:ccce_application/common/features/sign_in.dart';
import 'package:flutter/services.dart'; // Import this

class WelcomePage3 extends StatelessWidget {
  const WelcomePage3({Key? key}) : super(key: key);

  static const calPolyGold = Color.fromRGBO(206, 204, 160, 1);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final smallerSide = screenWidth < screenHeight ? screenWidth : screenHeight;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return Scaffold(
      backgroundColor: calPolyGold,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: screenHeight * 0.12),
                  Image.asset(
                    'assets/icons/welcome_hand_without_padding.png', // Replace with the actual path to your PNG
                    height: smallerSide *
                        0.6, // 60% of the smaller screen dimension
                    width: smallerSide *
                        0.6, // Maintain aspect ratio (adjust as needed)
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.0),
                    child: Image.asset('assets/icons/three_of_three_dots.png'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.05),
                    child: const Text(
                      'Welcome to',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SansSerifPro'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'CPCM!',
                    style: TextStyle(fontSize: 36, color: Colors.white),
                  ),
                  const SizedBox(height: 50),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     Navigator.pushReplacement(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => const SignIn()),
                  //     );
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //     shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(10)),
                  //     padding: const EdgeInsets.symmetric(horizontal: 100),
                  //     shadowColor: Colors.black,
                  //     elevation: 5,
                  //   ),
                  //   child: const Text(
                  //     'Sign in',
                  //     style: TextStyle(
                  //         color: Color.fromARGB(255, 130, 130, 130),
                  //         fontWeight: FontWeight.w700),
                  //   ),
                  // ),
                  // const SizedBox(height: 20),
                  // GestureDetector(
                  //   onTap: () {
                  //     Navigator.pushReplacement(
                  //       context,
                  //       MaterialPageRoute(builder: (context) => SignUp()),
                  //     );
                  //   },
                  //   child: const Text(
                  //     "Don't have an account?",
                  //     style: TextStyle(
                  //       color: Colors.blue,
                  //       decoration: TextDecoration.underline,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.03, // 30 pixels from the bottom
              child: Image.asset(
                'assets/icons/cal_poly_logo.png',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
