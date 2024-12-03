import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workout_fitness/view/menu/menu_view.dart';
import '../../view/Authentication/register_view.dart'; // Ensure this path is correct

class SwitchAccountView extends StatelessWidget {
  const SwitchAccountView({super.key});

  // Fetch accounts from Firestore
  Future<List<Map<String, dynamic>>> _fetchAccounts() async {
    try {
      QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('users').get();
      print('Fetched ${snapshot.docs.length} accounts'); // Debug print

      // Map each document into a list of account details
      return snapshot.docs.map((doc) {
        print('Document data: ${doc.data()}'); // Debug print
        return {
          'username': doc['username'] ?? 'No Username', // Fetch username from Firestore
          'email': doc['email'] ?? '',
          'uid': doc.id,
        };
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch accounts: $e');
    }
  }

  // Handle account login
  void _login(BuildContext context, String email) async {
    try {
      // Example: logging in using the email. You could replace this with actual Firebase login logic.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Logging in with $email...")),
      );

      // Fetch user data using the email or UID for logging in
      final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: 'yourPasswordHere', // Adjust with the actual password if needed
      );

      // Example navigation after successful login
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MenuView()), // Replace with your main page
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: $e")),
      );
    }
  }

  // Navigate to the account registration page
  void _registerAccount(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateAccountPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Switch Account"),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchAccounts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }

          final accounts = snapshot.data ?? [];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: accounts.isEmpty
                      ? const Center(
                    child: Text("No accounts found."),
                  )
                      : ListView.builder(
                    itemCount: accounts.length,
                    itemBuilder: (context, index) {
                      final account = accounts[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          leading: const Icon(Icons.account_circle),
                          title: Text(account['username']), // Show username
                          subtitle: Text(account['email']), // Optionally show email
                          trailing: const Icon(Icons.login),
                          onTap: () => _login(context, account['email']), // Login on tap
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => _registerAccount(context),
                  icon: const Icon(Icons.add),
                  label: const Text("Register New Account"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
