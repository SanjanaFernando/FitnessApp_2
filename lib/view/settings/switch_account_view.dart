import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../view/Authentication/login_view.dart';// Import LoginPage
import '../../view/Authentication/register_view.dart';
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

  // Navigate to the login page with pre-populated email
  void _login(BuildContext context, String email) {
    // Pass the email to LoginPage
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(email: email), // Provide the email here
      ),
    );
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
                          onTap: () => _login(context, account['email']), // Pass email to LoginPage
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
