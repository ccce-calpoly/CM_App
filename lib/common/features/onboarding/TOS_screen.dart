import 'package:flutter/material.dart';
import 'package:ccce_application/common/theme/colors.dart';
import 'package:flutter/services.dart'; // Import for rootBundle

class TosScreen extends StatelessWidget {
  const TosScreen({Key? key}) : super(key: key);

  // Function to load the text from the file.
  Future<String> _loadTermsAndConditions() async {
    try {
      return await rootBundle.loadString('assets/terms_and_conditions.txt');
    } catch (e) {
      // Handle the error appropriately, e.g., show a message to the user.
      print("Error loading terms and conditions: $e");
      return "Failed to load Terms and Conditions. Please check the file."; // Return a user-friendly error message.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.calPolyGreen,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<String>(
            // Use a FutureBuilder to handle the async operation
            future: _loadTermsAndConditions(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Show a loading indicator while the text is being loaded.
                return const Center(
                    child: CircularProgressIndicator(
                  color: Colors.white,
                ));
              } else if (snapshot.hasError) {
                // Show an error message if loading failed.  The error message from _loadTermsAndConditions is in snapshot.data
                return Center(
                  child: Text(
                    'Error: ${snapshot.data}', // Display the error message.
                    style: const TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                );
              } else {
                // If the text was loaded successfully, display it.
                String termsText = snapshot.data ??
                    "No terms and conditions found."; // added null check
                return SingleChildScrollView(
                    child: Column(children: <Widget>[
                  Text(
                    termsText,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Handle Agree button press (e.g., navigate to the next screen)
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.calPolyGreen,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32.0, vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      'Agree',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ]));
              }
            },
          ),
        ),
      ),
    );
  }
}
