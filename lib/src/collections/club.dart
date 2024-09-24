import 'package:flutter/material.dart';

class Club implements Comparable<Club> {
  dynamic name;
  dynamic aboutMsg;
  dynamic email;
  dynamic acronym;
  dynamic instagram;
  Club(this.name, this.aboutMsg, this.email, this.acronym, this.instagram);

  @override
  int compareTo(Club other) {
    return (name.toLowerCase().compareTo(other.name.toLowerCase()));
  }
}

class ClubItem extends StatelessWidget {
  final Club club;

  const ClubItem(this.club, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFCECCA0),
          border: Border.all(color: Colors.transparent),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
          child: Column(
            children: [
              ListTile(
                leading: const Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: const Icon(Icons.person, color: Colors.black),
                ),
                title: Text(club.name + " (" + club.acronym + ")",
                    style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ClubPopUp extends StatelessWidget {
  final Club club;

  static const backGroundColor = Color.fromRGBO(255, 253, 237, 1);
  static const calPolyGreen = Color(0xFF003831);
  static const calPolyGold = Color.fromRGBO(206, 204, 160, 1);

  final VoidCallback onClose;

  const ClubPopUp({required this.club, required this.onClose, Key? key})
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
                                club.name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize:
                                      24.0, // Adjust the font size as needed
                                  fontWeight:
                                      FontWeight.bold, // Make the text bold
                                ),
                              ),
                              Text(
                                club.acronym,
                                textAlign: TextAlign.center,
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
                                club.email,
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
                                club.instagram,
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
                        club.name,
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
