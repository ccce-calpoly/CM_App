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
                const SizedBox(height: 80),
                const Icon(
                  Icons.waving_hand_outlined,
                  size: 200,
                  color: Colors.white,
                ),
                const SizedBox(height: 40),
                const Text(
                  'Welcome to',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'CPCM!',
                  style: TextStyle(fontSize: 36, color: Colors.white),
                ),
                const SizedBox(height: 50),
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
                    padding: const EdgeInsets.symmetric(horizontal: 100),
                    shadowColor: Colors.black,
                    elevation: 5,
                  ),
                  child: const Text(
                    'Sign in',
                    style: TextStyle(
                        color: Color.fromARGB(255, 130, 130, 130),
                        fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => signIn()),
                    );
                  },
                  child: const Text(
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
          const Positioned(
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
