import 'package:flutter/material.dart';
import 'package:ccce_application/common/collections/faculty.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FacultyDirectory extends StatefulWidget {
  const FacultyDirectory({Key? key}) : super(key: key);

  final String title = "Directory";
  @override
  State<FacultyDirectory> createState() => _FacultyDirectoryState();
}

class _FacultyDirectoryState extends State<FacultyDirectory> {
  Future<List<Faculty>> fetchDataFromFirestore() async {
    List<Faculty> facultyList = [];

    try {
      // Get a reference to the Firestore database
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Query the "companies" collection
      QuerySnapshot querySnapshot = await firestore.collection('faculty').get();

      // Iterate through the documents in the query snapshot
      querySnapshot.docs.forEach((doc) {
        // Convert each document to a Map and add it to the list
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Map<String, String> facultyData = {};
        data.forEach((key, value) {
          // Convert each value to String and add it to companyData
          facultyData[key] = value.toString();
        });
        bool administration = false;
        if (facultyData['administration'] != null) {
          administration =
              facultyData['administration']!.toLowerCase().contains("true");
        }
        Faculty newFaculty = Faculty(
            facultyData['first name'],
            facultyData['last name'],
            facultyData['title'],
            facultyData['email'],
            facultyData['phone'],
            facultyData['hours'],
            administration,
            facultyData['emeritus'] == "true" ? true : false);
        facultyList.add(newFaculty);
      });
    } catch (e) {
      // Handle any errors that occur
      print('Error fetching data: $e');
    }

    return facultyList;
  }

  final TextEditingController _searchController = TextEditingController();
  bool _isTextEntered = false;

  static List<Faculty> facultyList = [];
  static List<Faculty> filteredFaculty = [];
  static const tanColor = Color(0xFFcecca0);
  static const lighterTanColor = Color(0xFFfffded);
  @override
  void initState() {
    super.initState();

    fetchDataFromFirestore().then((facultyData) {
      setState(() {
        facultyList = facultyData;
        facultyList.sort();
      });
    });

    // Fetch company data from a source (e.g., API call, database)
    // and populate the companies list
  }

  @override
  Widget build(BuildContext context) {
    void sortAlphabetically() {
      setState(() {
        facultyList = facultyList.reversed.toList();
      });
    }

    OutlinedButton createButtonSorter(String txt, VoidCallback sortingFunction,
        {bool colorFlag = true}) {
      bool _colorFlag = colorFlag;
      return OutlinedButton(
        onPressed: () {
          setState(() {
            sortingFunction(); // Call your sorting function
            print(_colorFlag);
            _colorFlag = !_colorFlag; // Flip the boolean
            print(_colorFlag);
          });
        },
        style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6), // Rounded corners
            ),
            textStyle: const TextStyle(fontSize: 14),
            side: const BorderSide(
                color: Colors.black, width: 1), // Border color and width
            fixedSize: const Size(60, 30), // Set the button size
            minimumSize: Size(80, 20), // Minimum size constraint
            backgroundColor: _colorFlag ? Colors.transparent : Colors.black),
        child: Text(txt,
            style: TextStyle(
                fontSize: 14, color: _colorFlag ? Colors.black : Colors.white)),
      );
    }

    return Scaffold(
      backgroundColor: lighterTanColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    // Wrap TextField with shadow
                    // decoration: BoxDecoration(
                    //   color: tanColor, // Set background color (optional)
                    //   borderRadius: BorderRadius.circular(
                    //       10.0), // Rounded corners (optional)
                    //   boxShadow: [
                    //     // Add shadow
                    //     BoxShadow(
                    //       color: Colors.grey
                    //           .withOpacity(0.3), // Shadow color with opacity
                    //       spreadRadius: 2.0, // Adjust shadow spread (optional)
                    //       blurRadius: 5.0, // Adjust shadow blur (optional)
                    //       offset: const Offset(
                    //           0.0, 4.0), // Shadow offset (optional)
                    //     ),
                    //   ],
                    // ),
                    child: TextField(
                      //controller: _searchController,
                      onChanged: (text) {
                        setState(() {
                          _isTextEntered = text.isNotEmpty;
                          // Clear the previously filtered companies
                          filteredFaculty.clear();

                          // Iterate through the original list of companies if text is entered
                          if (_isTextEntered) {
                            for (Faculty faculty in facultyList) {
                              // Check if the company name starts with the entered text substring
                              String name = faculty.fname + " " + faculty.lname;
                              if (name
                                  .toLowerCase()
                                  .startsWith(text.toLowerCase())) {
                                // If it does, add the company to the filtered list
                                filteredFaculty.add(faculty);
                              }
                            }
                          }
                        });
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        // contentPadding: EdgeInsets.all(2.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 2.0,
                          ),
                        ),
                        hintText: 'Faculty Directory',
                        // border: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(10.0),
                        // ),
                        fillColor: Colors.white,
                        filled: true,
                        // Add Container with colored background for the button
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  createButtonSorter('A-Z', sortAlphabetically,
                      colorFlag: false),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 6)),
                  createButtonSorter('Admin', () => {}),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount:
                  _isTextEntered ? filteredFaculty.length : facultyList.length,
              itemBuilder: (context, index) {
                final List<Faculty> displayList =
                    _isTextEntered ? filteredFaculty : facultyList;
                return GestureDetector(
                  onTap: () {
                    Faculty facultyData = displayList[index];
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            //padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                            height: 200, // Adjust the height as needed
                            width: MediaQuery.of(context).size.width *
                                0.8, // 80% of screen width
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 2.0),
                                  child: IconButton(
                                    icon: Icon(Icons.arrow_back),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the popup
                                    },
                                  ),
                                ),
                                Container(
                                    color: Color(0xFFD5E3F4),
                                    child: Column(children: [
                                      SizedBox(height: 10),
                                      Text(
                                        'Popup Title',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        'This is some informational text in the popup. It only takes up a little bit of the screen.',
                                        textAlign: TextAlign.center,
                                      ),
                                    ]))
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: FacultyItem(
                      displayList[index]), // Existing CompanyItem widget
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
