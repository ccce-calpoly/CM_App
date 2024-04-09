import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ccce_application/auth_gate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const calPolyGreen = Color(0xFF003831);
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _schoolYearController = TextEditingController();
  final _companyController = TextEditingController();
  static dynamic curUser;
  static dynamic curUserData;

  bool _editMode = false; // Indicates whether the page is in edit mode

  @override
  void initState() {
    super.initState();
    // Load user data when the widget initializes
    loadUserData();
  }

  void loadUserData() {
    // Load user data and update the text controllers
    final curUser = FirebaseAuth.instance.currentUser;
    if (curUser != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(curUser.uid)
          .get()
          .then((snapshot) {
        if (snapshot.exists) {
          curUserData = snapshot.data() as Map<String, dynamic>;
          _firstNameController.text = curUserData['firstName'] ?? '';
          _lastNameController.text = curUserData['lastName'] ?? '';
          _schoolYearController.text = curUserData['schoolYear'] ?? '';
          _companyController.text = curUserData['company'] ?? '';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Top background
          Positioned.fill(
            top: 0,
            child: Container(color: const Color.fromARGB(255, 86, 86, 1)),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: const Icon(
                Icons.menu,
                size: 50,
              ), // Hamburger icon
              onPressed: () {
                // Add your menu functionality here
              },
            ),
          ),
          // White background with rounded corners for text fields
          Positioned(
            top: MediaQuery.of(context).size.height / 6, // Adjust as needed
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                        height: 120.0), // Adding space between the fields
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: TextFormField(
                        controller: _firstNameController,
                        decoration: const InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 20.0),
                          labelText: 'First Name',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(
                        height: 24.0), // Adding space between the fields
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: TextFormField(
                        controller: _lastNameController,
                        decoration: const InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 20.0),
                          labelText: 'Last Name',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(
                        height: 24.0), // Adding space between the fields
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: TextFormField(
                        controller: _schoolYearController,
                        decoration: const InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 20.0),
                          labelText: 'School Year',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(
                        height: 24.0), // Adding space between the fields
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: TextFormField(
                        controller: _companyController,
                        decoration: const InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 20.0),
                          labelText: 'Company',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: _editMode
                          ? Row(
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: calPolyGreen),
                                  onPressed: () async {
                                    // Retrieve values from form fields
                                    final firstName = _firstNameController.text;
                                    final lastName = _lastNameController.text;
                                    final schoolYear =
                                        _schoolYearController.text;
                                    final company = _companyController.text;

                                    // Clear values in form fields
                                    _firstNameController.clear();
                                    _lastNameController.clear();
                                    _schoolYearController.clear();
                                    _companyController.clear();

                                    // Get the user ID
                                    String? userID = curUser.uid;
                                    String? email = curUser.email;

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
                                            content: const Text(
                                                'Please fill out all fields.'),
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
                                      final userCollection = FirebaseFirestore
                                          .instance
                                          .collection('users');

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
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content:
                                            Text('User created successfully!'),
                                      ));
                                    } catch (e) {
                                      // Handle errors
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                            'Error creating user. Please try again later.'),
                                      ));
                                    }
                                  },
                                  child: const Text('Submit'),
                                ),
                                const SizedBox(
                                    width:
                                        16), // Adding some space between buttons
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: calPolyGreen),
                                  onPressed: () async {
                                    await FirebaseAuth.instance.signOut();
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AuthGate()),
                                    );
                                  },
                                  child: const Text('Sign Out'),
                                ),
                              ],
                            )
                          : Container(), // Empty container when not in edit mode
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Circle for profile pic
          Positioned(
            top: 50, // Adjust as needed
            left: (MediaQuery.of(context).size.width - 186) /
                2, // Adjust as needed
            child: Stack(
              children: [
                Container(
                  width: 186,
                  height: 186,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: const Color.fromARGB(255, 93, 93, 93), width: 2),
                    color: const Color.fromARGB(
                        255, 251, 251, 251), // Change to your desired color
                  ),
                  // You can put an Image or Icon widget inside the container for profile picture
                  child: const Icon(Icons.person,
                      size: 100, color: Color.fromARGB(255, 118, 118, 118)),
                ),
                Positioned(
                  bottom: 10, // Adjust as needed
                  right: 10, // Adjust as needed
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        // Toggle edit mode
                        _editMode = !_editMode;
                        if (_editMode) {
                          _firstNameController.clear();
                          _lastNameController.clear();
                          _schoolYearController.clear();
                          _companyController.clear();
                        } else {
                          _firstNameController.text =
                              curUserData['firstName'] ?? '';
                          _lastNameController.text =
                              curUserData['lastName'] ?? '';
                          _schoolYearController.text =
                              curUserData['schoolYear'] ?? '';
                          _companyController.text =
                              curUserData['company'] ?? '';
                        }
                      });
                      // Add your onPressed function here
                      // For example, you can navigate to another screen
                      // or show a dialog to edit the profile
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      child: const Icon(
                        Icons.edit,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
