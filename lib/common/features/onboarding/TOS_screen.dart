import 'package:ccce_application/common/widgets/gold_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:ccce_application/common/theme/colors.dart';
import 'package:flutter/services.dart'; // Import for rootBundle

class TosScreen extends StatelessWidget {
  const TosScreen({Key? key}) : super(key: key);

  Future<String> _loadTermsAndConditions() async {
    try {
      return await rootBundle.loadString('assets/terms_and_conditions.txt');
    } catch (e) {
      print("Error loading terms and conditions: $e");
      return "Failed to load Terms and Conditions. Please check the file.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.calPolyGreen,
      appBar: const GoldAppBar(),
      body: SafeArea(
        child: Stack(
          children: [
            // Fixed Title at the Top
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Terms and Conditions",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            // Scrollable Content Below the Title
            Padding(
              padding: const EdgeInsets.only(
                top: 40.0,
                left: 16.0,
                right: 16.0,
              ), // Adjust top padding based on title height and padding
              child: FutureBuilder<String>(
                future: _loadTermsAndConditions(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: Colors.white,
                    ));
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.data}',
                        style: const TextStyle(
                            fontSize: 16.0, color: Colors.white),
                      ),
                    );
                  } else {
                    String termsText =
                        snapshot.data ?? "No terms and conditions found.";
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // Align text to the left
                        children: <Widget>[
                          Text(
                            termsText,
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          SizedBox(
                            // Use SizedBox to control the width of the button
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppColors.calPolyGreen,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
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
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
