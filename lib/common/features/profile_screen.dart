import 'package:ccce_application/common/features/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final String title = 'CM Home';
  static const calPolyGreen = Color(0xFF003831);
  static const tanColor = Color(0xFFcecca0);
  //static const appBackgroundColor = Color(0xFFE4E3D3);
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
    curUser = FirebaseAuth.instance.currentUser;
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

  Row editButtonBuild() {
    List<Widget> children = [
      ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: calPolyGreen),
        onPressed: () async {
          setState(() {
            _editMode = !_editMode;
          });
          // Retrieve values from form fields
          final firstName = _firstNameController.text;
          final lastName = _lastNameController.text;
          final schoolYear = _schoolYearController.text;
          final company = _companyController.text;

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
                  content: const Text('Please fill out all fields.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
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
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('User edited successfully!'),
            ));
          } catch (e) {
            // Handle errors
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Error creating user. Please try again later.'),
            ));
          }
        },
        child: const Text(
          'Submit',
          style: TextStyle(color: Colors.white),
        ),
      ),
      const SizedBox(width: 16), // Adding some space between buttons
      ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: calPolyGreen),
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SignIn()),
          );
        },
        child: const Text('Sign Out', style: TextStyle(color: Colors.white)),
      ),
    ];

    return Row(
      children: [
        for (int i = 0; i < children.length; i++)
          if ((i != 0 && i != 1) || _editMode)
            children[i], // Hide first child if flag is true
      ],
    );
  }

  TextFormField createProfileAttributeField(
      String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      enabled: _editMode,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
        labelText: label,
        border: InputBorder.none,
      ),
    );
  }

  Container createProfileAttributeContainer(TextFormField attributeField) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.grey),
        ),
        child: attributeField);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Top background
          Positioned.fill(
            top: 0,
            child: Container(color: tanColor),
          ),

          // White background with rounded corners for text fields
          Positioned(
            top: MediaQuery.of(context).size.height / 6, // Adjust as needed
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFFFFDED),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32.0),
                  topRight: Radius.circular(32.0),
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
                    createProfileAttributeContainer(createProfileAttributeField(
                        "First Name", _firstNameController)),
                    const SizedBox(
                        height: 24.0), // Adding space between the fields
                    createProfileAttributeContainer(createProfileAttributeField(
                        "Last Name", _lastNameController)),
                    const SizedBox(
                        height: 24.0), // Adding space between the fields
                    createProfileAttributeContainer(createProfileAttributeField(
                        "School Year", _schoolYearController)),
                    const SizedBox(
                        height: 24.0), // Adding space between the fields
                    createProfileAttributeContainer(createProfileAttributeField(
                        "Company", _companyController)),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child:
                          editButtonBuild(), // Empty container when not in edit mode
                    ),
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              // Apply border to the bottom
                              color: Color(0xFFD9D9D9),
                              width: 1.0, // Adjust line thickness
                            ),
                          ),
                        )),
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
                    border:
                        Border.all(color: const Color(0xFFD9D9D9), width: 2),
                    color:
                        const Color(0xFFFFFDED), // Change to your desired color
                  ),
                  // You can put an Image or Icon widget inside the container for profile picture
                  child: const Icon(Icons.person,
                      size: 100, color: Color.fromARGB(255, 118, 118, 118)),
                ),
                Positioned(
                    bottom: 10, // Adjust as needed
                    right: 10, // Adjust as needed
                    child: Container(
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Color(0xFFD9D9D9)),
                        child: Material(
                          borderRadius: BorderRadius.circular(100),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                // Toggle edit mode
                                if (_editMode == false) {
                                  _editMode = !_editMode;
                                }
                              });
                              // Add your onPressed function here
                              // For example, you can navigate to another screen
                              // or show a dialog to edit the profile
                            },
                            child: Ink(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFD9D9D9),
                              ),
                              child: const Icon(
                                Icons.edit,
                                size: 24,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
