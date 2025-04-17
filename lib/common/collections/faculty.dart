import 'package:flutter/material.dart';

class Faculty implements Comparable<Faculty> {
  dynamic fname;
  dynamic lname;
  dynamic title;
  dynamic email;
  dynamic phone;
  dynamic hours;
  bool administration;
  bool emeritus;
  Faculty(this.fname, this.lname, this.title, this.email, this.phone,
      this.hours, this.administration, this.emeritus);

  @override
  int compareTo(Faculty other) {
    return (lname.toLowerCase().compareTo(other.lname.toLowerCase()));
  }
}

class FacultyItem extends StatelessWidget {
  final Faculty faculty;

  const FacultyItem(this.faculty, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFD5E3F4),
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8.0),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withOpacity(0.3),
          //     spreadRadius: 1,
          //     blurRadius: 2,
          //     offset: const Offset(0, 2), // changes position of shadow
          //   ),
          //],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
          child: Padding(
            padding: const EdgeInsets.only(left: 18.0, top: 8.0, bottom: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  faculty.lname + ", " + faculty.fname,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 18),
                ),
                Text(faculty.title,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FacultyPopUp extends StatelessWidget {
  final Faculty faculty;

  static const backGroundColor = Color.fromRGBO(255, 253, 237, 1);
  static const calPolyGreen = Color(0xFF003831);
  static const calPolyGold = Color.fromRGBO(206, 204, 160, 1);

  final VoidCallback onClose;

  const FacultyPopUp({required this.faculty, required this.onClose, Key? key})
      : super(key: key);

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
                //     color: Colors.transparent,
                //     width: double.infinity,
                //     height: double.infinity,
                //   ),
                // ),
                // Center the popup content
                Center(
                  child: Container(
                    // Container for popup content
                    decoration: const BoxDecoration(
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
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                                onPressed: onClose,
                              ),
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
                        // Your existing club details here
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                faculty.fname + " " + faculty.lname,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize:
                                      24.0, // Adjust the font size as needed
                                  fontWeight:
                                      FontWeight.bold, // Make the text bold
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
            flex: 3,
            child: Container(
              color: backGroundColor,
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  // First Section
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.mail,
                            size: 24, // Adjust the size of the icon as needed
                            color: Colors.black, // Add your desired icon color
                          ),
                          const SizedBox(
                            width: 10,
                          ), // Add space between icon and text
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                faculty.email,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Additional Text Row
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.camera_alt,
                            size: 24, // Adjust the size of the icon as needed
                            color: Colors.black, // Add your desired icon color
                          ),
                          const SizedBox(
                            width: 10,
                          ), // Add space between icon and text
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                faculty.administration ? "true" : "false",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Divider between the first section and the rest
                      //const Divider(),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                  // Second Section (Upcoming Events)
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Upcoming Events",
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
                        "",
                        style: const TextStyle(
                          color: Color.fromARGB(255, 35, 35, 35),
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                  // Divider between the second and third sections
                  const Divider(),
                  // Third Section (About)
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
                        faculty.fname + " " + faculty.lname,
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
