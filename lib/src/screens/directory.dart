import 'package:flutter/material.dart';
import 'package:ccce_application/src/collections/company.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Directory extends StatefulWidget {
  const Directory({Key? key}) : super(key: key);

  final String title = "Directory";
  @override
  State<Directory> createState() => _DirectoryState();
}

class _DirectoryState extends State<Directory> {
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
  bool _isAscendingSort =
      true; // Flag for sorting order (true: A-Z, false: Z-A)
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
    return Scaffold(
      backgroundColor: lighterTanColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              // Use Row for horizontal layout
              children: [
                Expanded(
                  child: Container(
                    // Wrap TextField with shadow
                    decoration: BoxDecoration(
                      color: tanColor, // Set background color (optional)
                      borderRadius: BorderRadius.circular(
                          10.0), // Rounded corners (optional)
                      boxShadow: [
                        // Add shadow
                        BoxShadow(
                          color: Colors.grey
                              .withOpacity(0.3), // Shadow color with opacity
                          spreadRadius: 2.0, // Adjust shadow spread (optional)
                          blurRadius: 5.0, // Adjust shadow blur (optional)
                          offset: const Offset(
                              0.0, 4.0), // Shadow offset (optional)
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
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
                        // contentPadding: EdgeInsets.all(2.0),
                        border: InputBorder.none,
                        hintText: 'Search Members...',
                        // border: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(10.0),
                        // ),
                        fillColor: Colors.grey[200],
                        filled: true,
                        // Add Container with colored background for the button
                        suffixIcon: Container(
                          height: 55,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 246, 246, 246),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                  0.0), // No rounding for top left
                              topRight: Radius.circular(
                                  10.0), // Rounded top right corner
                              bottomLeft: Radius.circular(
                                  0.0), // No rounding for bottom left
                              bottomRight: Radius.circular(
                                  10.0), // Rounded bottom right corner
                            ),
                          ),
                          constraints: const BoxConstraints(
                              minWidth:
                                  40.0, // Set minimum width (adjust as needed)
                              maxWidth:
                                  40.0, // Set maximum width (adjust as needed)
                              minHeight: 40.0),
                          // Set your desired background color
                          child: IconButton(
                            icon: const Icon(
                              Icons.sort_by_alpha_outlined,
                            ),
                            onPressed: () {
                              setState(() {
                                _isAscendingSort = !_isAscendingSort;
                                companies = companies.reversed.toList();
                                // Implement sorting logic here (update your content)
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
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
