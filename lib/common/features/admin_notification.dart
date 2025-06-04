import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminNotificationPage extends StatefulWidget {
  const AdminNotificationPage({super.key});

  @override
  State<AdminNotificationPage> createState() => _AdminNotificationPageState();
}

class _AdminNotificationPageState extends State<AdminNotificationPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  String? _selectedRole; // To hold the selected role

  // Example list of roles you might have in your app
  final List<String> _roles = ['student', 'teacher', 'parent', 'admin'];

  Future<void> _sendNotificationToRole() async {
    // Basic validation for the admin UI
    if (_selectedRole == null ||
        _titleController.text.isEmpty ||
        _bodyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select a role and fill all fields!')),
      );
      return;
    }

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('You must be logged in to send notifications.')),
      );
      return;
    }

    try {
      // 1. Get a callable function reference (updated name)
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('sendNotificationToRole');

      // 2. Prepare the data to send to the Cloud Function
      final Map<String, dynamic> dataToSend = {
        'targetRole': _selectedRole, // Send the selected role
        'title': _titleController.text.trim(),
        'body': _bodyController.text.trim(),
        'data': {
          'origin': 'admin_broadcast_panel',
          'action': 'role_message_sent',
        },
      };

      // 3. Call the Cloud Function
      final result = await callable.call(dataToSend);

      // 4. Handle the response
      final responseData = result.data;
      if (responseData['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${responseData['message']} (Sent to ${responseData['successCount']} devices, Failed for ${responseData['failureCount']})',
            ),
          ),
        );
        // Clear fields after success
        _titleController.clear();
        _bodyController.clear();
        setState(() {
          _selectedRole = null; // Reset dropdown
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Failed to send notification: ${responseData['message'] ?? 'Unknown error'}')),
        );
      }
    } on FirebaseFunctionsException catch (e) {
      // Handle errors specifically from Cloud Functions
      print('Cloud Functions Error: ${e.code} - ${e.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.message}')),
      );
    } catch (e) {
      // Handle any other unexpected errors
      print('Unexpected error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Role-Based Notifications (Admin)'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedRole,
              decoration: const InputDecoration(
                labelText: 'Select Target Role',
                border: OutlineInputBorder(),
              ),
              items: _roles.map((String role) {
                return DropdownMenuItem<String>(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedRole = newValue;
                });
              },
              validator: (value) =>
                  value == null ? 'Please select a role' : null,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Notification Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _bodyController,
              decoration: const InputDecoration(
                labelText: 'Notification Body',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _sendNotificationToRole,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Send Notification to Role',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
