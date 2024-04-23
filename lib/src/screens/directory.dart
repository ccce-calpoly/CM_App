import 'package:flutter/material.dart';

class Directory extends StatefulWidget {
  const Directory({Key? key}) : super(key: key);

  final String title = "Directory";
  @override
  State<Directory> createState() => _DirectoryState();
}

// Custom Widget for Popup
class CompanyPopup extends StatelessWidget {
  final Company company;
  final VoidCallback onClose;

  const CompanyPopup({required this.company, required this.onClose, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Makes background transparent
      body: Stack(
        // Use Stack within Scaffold for content positioning
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Close button with arrow
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          onPressed: onClose,
                        ),
                      ],
                    ),
                    // Your existing company details here
                    Text(company.name),
                    Text(company.location),
                    // ... additional content
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Company {
  dynamic name;
  dynamic location;
  dynamic aboutMsg;
  dynamic msg;
  dynamic recruiterName;
  dynamic recruiterTitle;
  dynamic recruiterEmail;
  Company(this.name, this.location, this.aboutMsg, this.msg, this.recruiterName,
      this.recruiterTitle, this.recruiterEmail);
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
  final TextEditingController _searchController = TextEditingController();
  bool _isAscendingSort =
      true; // Flag for sorting order (true: A-Z, false: Z-A)

  static List<Company> companies = [
    Company("Swinerton", "CA", "swinerton about", "msg", "recruiterName",
        "recruiterTitle", "recruiterEmail"),
    Company("Granite", "CA", "granite abt", "msg", "recruiterName",
        "recruiterTitle", "recruiterEmail")
  ];
  @override
  void initState() {
    // Should initialize companies in here!
    //Call to db companies collection
    // for (var i = 2; i < 20; i++) {
    //   _DirectoryState.companies[i] = Company(i, i, i, i, i, i, i);
    // }
    super.initState();
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
              itemCount: companies.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Company companyData = companies[index];
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
                      companies[index]), // Existing CompanyItem widget
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
