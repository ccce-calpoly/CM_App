import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ccce_application/rendered_page.dart';
import 'package:ccce_application/common/features/sign_in.dart';
import 'package:ccce_application/common/widgets/gold_app_bar.dart';
import 'package:ccce_application/common/theme/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  static const calPolyGold = Color.fromRGBO(206, 204, 160, 1);
  static const lighterTanColor = Color(0xFFfffded);
  static dynamic errorMsg = '';
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const GoldAppBar(),
      backgroundColor: AppColors.calPolyGreen,
      body: SingleChildScrollView(
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: screenHeight * 0.1),

                  // 👷 Hardhat logo image
                  Padding(
                    padding: EdgeInsets.only(
                      top: screenHeight * 0.02,
                      bottom: screenHeight * 0.03,
                    ),
                    child: Image.asset(
                      'assets/icons/hardhat.png',
                      height: screenHeight * 0.12,
                    ),
                  ),

                  Text(
                    'Cal Poly Construction\nManagement',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColors.tanText,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SansSerifPro',
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.025,
                    child: Text(
                      errorMsg,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  // Email Field
                  Container(
                    width: screenWidth * 0.75,
                    height: screenHeight * 0.065,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: TextField(
                      controller: _emailController,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight:
                            FontWeight.bold, // This makes the typed text bold
                      ),
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'Username',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.015,
                          horizontal: screenWidth * 0.025,
                        ),
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.020),

                  // Password Field
                  Container(
                    width: screenWidth * 0.75,
                    height: screenHeight * 0.065,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: TextField(
                      controller: _passwordController,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight:
                            FontWeight.bold, // This makes the typed text bold
                      ),
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Password',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(10),
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.020),

                  // Confirm Password Field
                  Container(
                    width: screenWidth * 0.75,
                    height: screenHeight * 0.065,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: TextField(
                      controller: _confirmPasswordController,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight:
                            FontWeight.bold, // This makes the typed text bold
                      ),
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Confirm Password',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(10),
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.030),

                  // Sign Up Button
                  SizedBox(
                    width: screenWidth * 0.75,
                    height: screenHeight * 0.065,
                    child: ElevatedButton(
                      onPressed: _signUpFunc,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.lightGold,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero),
                      ),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.020),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const SignIn()),
                      );
                    },
                    child: const Text(
                      "Already have an account? Sign In",
                      style: TextStyle(
                          color: AppColors.tanText,
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.tanText),
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

      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      String? userID = userCredential.user?.uid;

      if (userID == null) {
        setState(() {
          errorMsg = "Failed to create user.  Please try again.";
        });
        return;
      }

      // 3. Get FCM Token and add to user document in Firestore
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      print('FCM Token on signup: $fcmToken'); // For debugging

      // Prepare user data map
      Map<String, dynamic> userData = {
        'email': email,
        'firstName': "",
        'lastName': "",
        'schoolYear': "",
        'company': "",
      };

      // Add FCM token if available
      if (fcmToken != null) {
        userData['fcmToken'] = fcmToken;
      } else {
        print('Warning: FCM token was null during signup for user: $userID');
        // Consider if you want to handle this more robustly, e.g.,
        // retrying token retrieval later or logging to an error reporting service.
      }

      // Store user data in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .set(userData);

      // If sign-up is successful, navigate to the new page
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
        if (e.code == "weak-password") {
          print(_emailController.text.trim().isEmpty);
          if (_emailController.text.trim().isEmpty) {
            setState(() {
              errorMsg = "Invalid Credentials";
            });
          } else {
            setState(() {
              errorMsg = "Password is too weak";
            });
          }
        } else if (e.code == "invalid-email") {
          setState(() {
            errorMsg = "Invalid Email";
          });
        } else if (e.code == "email-already-in-use") {
          setState(() {
            errorMsg = "Email already in use";
          });
        }
      }
    }
  }
}
