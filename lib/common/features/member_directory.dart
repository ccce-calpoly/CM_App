import 'package:flutter/material.dart';
import 'package:ccce_application/common/collections/company.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MemberDirectory extends StatefulWidget {
  const MemberDirectory({Key? key}) : super(key: key);

  final String title = "Directory";
  @override
  State<MemberDirectory> createState() => _MemberDirectoryState();
}

class _MemberDirectoryState extends State<MemberDirectory> {
  Future<List<Company>> fetchDataFromFirestore() async {
    List<Company> companies = [];

    try {
      // Get a reference to the Firestore database
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Query the "companies" collection
      QuerySnapshot querySnapshot =
          await firestore.collection('companies').get();

      // Iterate through the documents in the query snapshot
      querySnapshot.docs.forEach((doc) {
        // Convert each document to a Map and add it to the list
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Map<String, String> companyData = {};
        data.forEach((key, value) {
          // Convert each value to String and add it to companyData
          companyData[key] = value.toString();
        });
        Company newComp = Company(
            companyData['name'],
            companyData['location'],
            companyData['about'],
            companyData['msg'],
            companyData['recruiterName'],
            companyData['recruiterTitle'],
            companyData['recruiterEmail']);
        companies.add(newComp);
      });
    } catch (e) {
      // Handle any errors that occur
      print('Error fetching data: $e');
    }

    return companies;
  }

  final TextEditingController _searchController = TextEditingController();
  bool _isTextEntered = false;

  static List<Company> companies = [];
  static List<Company> filteredCompanies = [];
  static const tanColor = Color(0xFFcecca0);
  static const lighterTanColor = Color(0xFFfffded);
  @override
  void initState() {
    super.initState();

    fetchDataFromFirestore().then((companiesData) {
      setState(() {
        companies = companiesData;
        companies.sort();
      });
    });

    // Fetch company data from a source (e.g., API call, database)
    // and populate the companies list
  }

  @override
  Widget build(BuildContext context) {
    void sortAlphabetically() {
      setState(() {
        companies = companies.reversed.toList();
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
            textStyle: TextStyle(fontSize: 14),
            side: BorderSide(
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
                          filteredCompanies.clear();

                          // Iterate through the original list of companies if text is entered
                          if (_isTextEntered) {
                            for (Company company in companies) {
                              // Check if the company name starts with the entered text substring
                              if (company.name
                                  .toLowerCase()
                                  .startsWith(text.toLowerCase())) {
                                // If it does, add the company to the filtered list
                                filteredCompanies.add(company);
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
                        hintText: 'Member Directory',
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
                  Padding(padding: EdgeInsets.symmetric(horizontal: 6)),
                  createButtonSorter('Sudents', () => {}),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 6)),
                  createButtonSorter('Alumni', () => {}),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 6)),
                  createButtonSorter('Industry', () => {}),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 6)),
                  createButtonSorter('Jobs', () => {}),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount:
                  _isTextEntered ? filteredCompanies.length : companies.length,
              itemBuilder: (context, index) {
                final List<Company> displayList =
                    _isTextEntered ? filteredCompanies : companies;
                return GestureDetector(
                  onTap: () {
                    Company companyData = displayList[index];
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CompanyPopup(
                          company: companyData,
                          onClose: () =>
                              Navigator.pop(context), // Close popup on tap
                        );
                      },
                    );
                  },
                  child: CompanyItem(
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
