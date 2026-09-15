import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback/backend/login%20backend.dart';
import 'package:feedback/screen/dashboard%20screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home screen.dart';

class MyFeedback extends StatefulWidget {
  const MyFeedback({super.key});

  @override
  State<MyFeedback> createState() => _MyFeedbackState();
}

class _MyFeedbackState extends State<MyFeedback> {
  @override
  Widget build(BuildContext context) {
    String currentUserId =
        FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Feedback'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await Login().logout();

              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                      (route) => false,
                );
              }
            },
            icon: const Icon(Icons.logout),
          ),

          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
            onPressed: () => _showAdminLoginDialog(context),
          ),
        ],
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('feedback')
            .where('userId', isEqualTo: currentUserId)
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No feedback submitted yet.'),
            );
          }

          var feedbackDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: feedbackDocs.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> data =
              feedbackDocs[index].data()
              as Map<String, dynamic>;

              String rating =
                  data['rating']?.toString() ?? '0';

              String review =
                  data['review']?.toString() ??
                      'No review';

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),

                child: ListTile(
                  title: Text(
                    'Rating: $rating ⭐',
                  ),

                  subtitle: Text(
                    review,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showAdminLoginDialog(BuildContext context) {
    TextEditingController passwordController =
    TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Admin Access'),

          content: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: 'Enter Admin Passcode',
              border: OutlineInputBorder(),
            ),
          ),

          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () {
                if (passwordController.text == '1234') {
                  Navigator.pop(context);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                      const AdminDashboard(),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content:
                      Text('Wrong Admin Password!'),
                    ),
                  );
                }
              },

              child: const Text('Login'),
            ),
          ],
        );
      },
    );
  }
}