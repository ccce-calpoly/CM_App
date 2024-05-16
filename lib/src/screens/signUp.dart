import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ccce_application/rendered_page.dart';
import 'package:ccce_application/src/screens/signIn.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  static const calPolyGold = Color.fromRGBO(206, 204, 160, 1);
  static const lighterTanColor = Color(0xFFfffded);
  static dynamic errorMsg = '';
  late User? _user;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        _user = user;
      });
    });
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
                        labelText: 'Email',
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

                  // Confirm Password TextField
                  Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: lighterTanColor,
                    ),
                    child: TextField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
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

                  // Sign Up Button
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
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _signUpFunc,
                        child: Text(
                          'Sign Up',
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
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => signIn()),
                      );
                    },
                    child: Text(
                      "Already have an account? Sign In",
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signUpFunc() async {
    try {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      String confirmPassword = _confirmPasswordController.text.trim();

      if (password != confirmPassword) {
        setState(() {
          errorMsg = "Passwords do not match";
        });
        return;
      }

      // Implement your custom sign-up logic here
      // For example:
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // If sign-up is successful, navigate to the new page
      if (userCredential.user != null) {
        setState(() {
          errorMsg = "";
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const RenderedPage(),
          ),
        );
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == "invalid-email") {
          setState(() {
            errorMsg = "Invalid Email";
          });
        } else if (e.code == "email-already-in-use") {
          setState(() {
            errorMsg = "Email already in use";
          });
        } else if (e.code == "weak-password") {
          setState(() {
            errorMsg = "Password is too weak";
          });
        }
      }
    }
  }
}
