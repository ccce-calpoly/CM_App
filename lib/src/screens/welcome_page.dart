import 'package:flutter/material.dart';
import 'package:ccce_application/src/screens/signIn.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  static const calPolyGold = Color.fromRGBO(206, 204, 160, 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: calPolyGold,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 80),
                Icon(
                  Icons.waving_hand_outlined,
                  size: 200,
                  color: Colors.white,
                ),
                SizedBox(height: 40),
                Text(
                  'Welcome to',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'CPCM!',
                  style: TextStyle(fontSize: 36, color: Colors.white),
                ),
                SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => signIn()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.symmetric(horizontal: 100),
                    shadowColor: Colors.black,
                    elevation: 5,
                  ),
                  child: Text(
                    'Sign in',
                    style: TextStyle(
                        color: const Color.fromARGB(255, 130, 130, 130),
                        fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => signIn()),
                    );
                  },
                  child: Text(
                    "Don't have an account?",
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 30, // 30 pixels from the bottom
            child: Icon(
              Icons.info_outline,
              size: 24,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
