import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class Directory extends StatefulWidget {
  const Directory({Key? key}) : super(key: key);

  final String title = "Directory";
  @override
  State<Directory> createState() => _DirectoryState();
}

// Custom Widget for Popup
class CompanyPopup extends StatelessWidget {
  final Company company;
  static const calPolyGreen = Color(0xFF003831);
  static const calPolyGold = Color.fromRGBO(210, 200, 156, 1);

  final VoidCallback onClose;

  const CompanyPopup({required this.company, required this.onClose, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: calPolyGreen,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              // Use Stack within Column for content positioning
              children: [
                // Transparent background to allow tapping outside to close (optional)
                GestureDetector(
                  onTap: onClose,
                  child: Container(
                    color: Colors.transparent,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                // Center the popup content
                Center(
                  child: Container(
                    // Container for popup content
                    decoration: BoxDecoration(
                      color: calPolyGold,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25.0),
                        bottomRight: Radius.circular(25.0),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Close button with arrow
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.grey),
                                child: IconButton(
                                  icon: const Icon(Icons.arrow_back),
                                  onPressed: onClose,
                                ),
                              )
                            ],
                          ),
                        ),
                        // Circle near the top of the page in the middle
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromARGB(255, 252, 253,
                                      240), // Change color as needed
                                ),
                                child: Center(
                                  child: Icon(Icons.construction),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Your existing company details here
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                company.name,
                                style: const TextStyle(
                                  fontSize:
                                      24.0, // Adjust the font size as needed
                                  fontWeight:
                                      FontWeight.bold, // Make the text bold
                                ),
                              ),
                              Text(
                                company.location,
                                style: const TextStyle(
                                  fontSize:
                                      18.0, // Adjust the font size as needed
                                ),
                              ),
                              // ... additional content
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Bottom section with text
          Expanded(
              child: Container(
            // Container properties
            color: Color.fromARGB(
                255, 16, 46, 17), // Example color, adjust as needed
            padding: EdgeInsets.all(16.0), // Example padding, adjust as needed

            child: Column(
              children: [
                // First Row
                Row(children: [
                  Expanded(
                      child: Container(
                    // decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(12.0)),
                    height: 100,
                    width: 100,
                    color: Colors.white,
                  ))
                ]),
                // Second Row
                Row(
                  children: [
                    Text('Second Row - Widget 1'),
                    Text('Second Row - Widget 2'),
                  ],
                ),
                // Third Row
                Row(
                  children: [
                    Text('Third Row - Widget 1'),
                    Text('Third Row - Widget 2'),
                  ],
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class Company implements Comparable<Company> {
  dynamic name;
  dynamic location;
  dynamic aboutMsg;
  dynamic msg;
  dynamic recruiterName;
  dynamic recruiterTitle;
  dynamic recruiterEmail;
  Company(this.name, this.location, this.aboutMsg, this.msg, this.recruiterName,
      this.recruiterTitle, this.recruiterEmail);

  @override
  int compareTo(Company other) {
    return (name.toLowerCase().compareTo(other.name.toLowerCase()));
  }
}

class CompanyItem extends StatelessWidget {
  final Company company;

  const CompanyItem(this.company, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      // Use Column to stack widgets vertically
      children: [
        ListTile(
          leading: const Icon(Icons.business),
          title: Text(company.name),
          subtitle: Text(company.location),
        ),
        const Divider(
          // Divider with default properties
          height: 1.0,
          thickness: 1.0,
          color: Colors.grey, // Adjust color if needed
        ),
      ],
    );
  }
}

class _DirectoryState extends State<Directory> {
  Future<List<Company>> fetchDataFromFirestore() async {
    List<Map<String, String>> companiesData = [];
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
  @override
  void initState() {
    // Should initialize companies in here!
    //Call to db companies collection
    // for (var i = 2; i < 20; i++) {
    //   _DirectoryState.companies[i] = Company(i, i, i, i, i, i, i);
    // }
    super.initState();
    // setState(() {
    //   companies.add(Company("Swinerton", "CA", "swinerton about", "msg",
    //       "recruiterName", "recruiterTitle", "recruiterEmail"));
    //   companies.add(Company("Granite", "CA", "granite abt", "msg",
    //       "recruiterName", "recruiterTitle", "recruiterEmail"));
    //   companies.add(Company("apple", "CA", "apple abt", "msg", "recruiterName",
    //       "recruiterTitle", "recruiterEmail"));
    //   companies.add(Company("Swinerton", "CA", "swinerton about", "msg",
    //       "recruiterName", "recruiterTitle", "recruiterEmail"));
    //   companies.add(Company("Granite", "CA", "granite abt", "msg",
    //       "recruiterName", "recruiterTitle", "recruiterEmail"));
    //   companies.add(Company("apple", "CA", "apple abt", "msg", "recruiterName",
    //       "recruiterTitle", "recruiterEmail"));
    //   companies.add(Company("Swinerton", "CA", "swinerton about", "msg",
    //       "recruiterName", "recruiterTitle", "recruiterEmail"));
    //   companies.add(Company("Granite", "CA", "granite abt", "msg",
    //       "recruiterName", "recruiterTitle", "recruiterEmail"));
    //   companies.add(Company("apple", "CA", "apple abt", "msg", "recruiterName",
    //       "recruiterTitle", "recruiterEmail"));
    //   companies.add(Company("Swinerton", "CA", "swinerton about", "msg",
    //       "recruiterName", "recruiterTitle", "recruiterEmail"));
    //   companies.add(Company("Granite", "CA", "granite abt", "msg",
    //       "recruiterName", "recruiterTitle", "recruiterEmail"));
    //   companies.add(Company("apple", "CA", "apple abt", "msg", "recruiterName",
    //       "recruiterTitle", "recruiterEmail"));
    //   companies.add(Company("Swinerton", "CA", "swinerton about", "msg",
    //       "recruiterName", "recruiterTitle", "recruiterEmail"));
    //   companies.add(Company("Granite", "CA", "granite abt", "msg",
    //       "recruiterName", "recruiterTitle", "recruiterEmail"));
    //   companies.add(Company("apple", "CA", "apple abt", "msg", "recruiterName",
    //       "recruiterTitle", "recruiterEmail"));
    // });
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
                      color:
                          Colors.grey[200], // Set background color (optional)
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
