import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ccce_application/rendered_page.dart';
import 'package:ccce_application/src/screens/sign_up.dart';

class signIn extends StatefulWidget {
  @override
  _signIn createState() => _signIn();
}

class _signIn extends State<signIn> {
  static const calPolyGold = Color.fromRGBO(206, 204, 160, 1);
  static const lighterTanColor = Color(0xFFfffded);
  static dynamic errorMsg = '';
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: calPolyGold,
      body: SingleChildScrollView(
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 100,
                  ),
                  // Your icon and text here
                  Icon(
                    Icons.waving_hand_outlined,
                    size: 100,
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'CPCM',
                    style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 20,
                    child: Text(
                      errorMsg,
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  // Email TextField
                  Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: lighterTanColor,
                    ),
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(10),
                        labelStyle: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Password TextField
                  Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: lighterTanColor,
                    ),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(10),
                        labelStyle: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Sign In Button
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    height: 50,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 0,
                            blurRadius: 8,
                            offset:
                                Offset(0, 4), // Shadow positioned at the bottom
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _signInFunc,
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: lighterTanColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                      height:
                          10), // Add some space between sign-in button and clickable text
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SignUp()),
                      );
                      // Add your navigation logic here
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
              // Positioned(
              //   bottom: -0, // Positioned at the bottom
              //   child: Icon(
              //     Icons.info_outline,
              //     color: Colors.white,
              //     size: 24,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signInFunc() async {
    try {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      // Implement your custom sign-in logic here
      // For example:
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // If sign-in is successful, navigate to the new page
      if (userCredential.user != null) {
        setState(() {
          errorMsg = "";
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const RenderedPage(),
          ),
        );
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == "wrong-password") {
          setState(() {
            errorMsg = "Invalid Credentials";
          });
        }
        if (e.code == "invalid-email") {
          setState(() {
            errorMsg = "Invalid Email";
          });
        } else if (e.code == "invalid-credential") {
          setState(() {
            errorMsg = "Invalid Credentials";
          });
        } else if (e.code == "channel-error") {
          setState(() {
            errorMsg = "Cannot Leave Fields Blank";
          });
        }
      }
    }
  }
}
