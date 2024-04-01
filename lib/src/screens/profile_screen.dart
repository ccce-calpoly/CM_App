import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ccce_application/auth_gate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);
  final String title = 'Sign Out';
  static const calPolyGreen = Color(0xFF003831);
  static const appBackgroundColor = Color(0xFFE4E3D3);

  // Declare controller variables
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _schoolYearController = TextEditingController();
  final _companyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackgroundColor,
      body: Form(
        // key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _firstNameController, // Assign controller
                decoration: const InputDecoration(
                  labelText: 'First Name',
                ),
              ),
              TextFormField(
                controller: _lastNameController, // Assign controller
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                ),
              ),
              TextFormField(
                controller: _schoolYearController, // Assign controller
                decoration: const InputDecoration(
                  labelText: 'School Year',
                ),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _companyController, // Assign controller
                decoration: const InputDecoration(
                  labelText: 'Company',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: calPolyGreen),
                      onPressed: () async {
                        // Retrieve values from form fields
                        final firstName = _firstNameController.text;
                        final lastName = _lastNameController.text;
                        final schoolYear = _schoolYearController.text;
                        final company = _companyController.text;

                        // Clear values in form fields
                        _firstNameController.clear();
                        _lastNameController.clear();
                        _schoolYearController.clear();
                        _companyController.clear();

                        // Get the user ID
                        String? userID = FirebaseAuth.instance.currentUser?.uid;
                        String? email =
                            FirebaseAuth.instance.currentUser?.email;

                        // Check if any field is empty
                        if (firstName.isEmpty ||
                            lastName.isEmpty ||
                            schoolYear.isEmpty ||
                            company.isEmpty) {
                          // Show a popup (dialog)
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Error'),
                                content:
                                    const Text('Please fill out all fields.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                          return;
                        }
                        try {
                          // Get a reference to the users collection
                          final userCollection =
                              FirebaseFirestore.instance.collection('users');

                          // Create a new user document with the entered data
                          // Merge: true creates new user if user doesnt exist, modifies if this user already existsLamk
                          await userCollection.doc(userID).set({
                            'email': email,
                            'firstName': firstName,
                            'lastName': lastName,
                            'schoolYear': schoolYear,
                            'company': company,
                          }, SetOptions(merge: true));

                          // Show a success message
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('User created successfully!'),
                          ));
                        } catch (e) {
                          // Handle errors
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                'Error creating user. Please try again later.'),
                          ));
                        }
                      },
                      child: const Text('Submit'),
                    ),
                    SizedBox(width: 16), // Adding some space between buttons
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: calPolyGreen),
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => AuthGate()),
                        );
                      },
                      child: const Text('Sign Out'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
