import 'package:flutter/material.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF154733),
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.person, color: Colors.white),
              title: Text(company.name, style: TextStyle(color: Colors.white)),
              subtitle:
                  Text(company.location, style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class CompanyPopup extends StatelessWidget {
  final Company company;

  static const backGroundColor = Color.fromRGBO(255, 253, 237, 1);
  static const calPolyGreen = Color(0xFF003831);
  static const calPolyGold = Color.fromRGBO(206, 204, 160, 1);

  final VoidCallback onClose;

  const CompanyPopup({required this.company, required this.onClose, Key? key})
      : super(key: key);

  String getRecName() {
    return company.recruiterName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Stack(
              // Use Stack within Column for content positioning
              children: [
                // Transparent background to allow tapping outside to close (optional)
                // GestureDetector(
                //   onTap: onClose,
                //   child: Container(
                //     color: calPolyGreen,
                //     width: double.infinity,
                //     height: double.infinity,
                //   ),
                // ),
                // Center the popup content
                Center(
                  child: Container(
                    // Container for popup content
                    decoration: const BoxDecoration(
                      color: calPolyGreen,
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
                                IconButton(
                                  icon: const Icon(Icons.arrow_back,
                                      color: Colors.white),
                                  onPressed: onClose,
                                ),
                              ]),
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
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromARGB(255, 252, 253,
                                      240), // Change color as needed
                                ),
                                child: const Center(
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
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white, // Make the text bold
                                ),
                              ),
                              Text(
                                company.location,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              GestureDetector(
                                  child: Container(
                                      width: 180,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: backGroundColor),
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.star,
                                              color: Colors.yellow),
                                          SizedBox(width: 8),
                                          Text("Add To Favorites")
                                        ],
                                      )))
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
            flex: 3,
            child: Container(
              color: backGroundColor,
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  // First Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: calPolyGreen),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(width: 40),
                                const Center(
                                  child: CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      Icons.person,
                                      size:
                                          36, // Adjust the size of the icon as needed
                                      color: calPolyGreen,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ), // Add space between icon and text
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      company.recruiterName,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      company.recruiterTitle,
                                      style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 150, 150, 150),
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.mail,
                                            color: Colors.white),
                                        SizedBox(width: 10),
                                        Text(
                                          company.recruiterEmail,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Divider between the first section and the rest
                  const Divider(),
                  // Second Section (About)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "About",
                        style: TextStyle(
                          color: Color.fromARGB(255, 102, 102, 102),
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ), // Add space between text elements
                      Text(
                        company.aboutMsg,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 35, 35, 35),
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                  // Divider between the second and third sections
                  const Divider(),
                  // Third Section (Message)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Message",
                        style: TextStyle(
                          color: Color.fromARGB(255, 102, 102, 102),
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ), // Add space between text elements
                      Text(
                        company.msg,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 35, 35, 35),
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
