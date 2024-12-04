import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeightView extends StatefulWidget {
  const WeightView({super.key});

  @override
  State<WeightView> createState() => _WeightViewState();
}

class _WeightViewState extends State<WeightView> {
  final TextEditingController weightController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  // Predefined images for cycling
  final List<String> imageUrls = [
    "https://plus.unsplash.com/premium_photo-1726862769772-dc8c33d980a3?q=80&w=1169&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    "https://plus.unsplash.com/premium_photo-1661301057249-bd008eebd06a?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    "https://plus.unsplash.com/premium_photo-1664477098603-042afd7d70de?q=80&w=1032&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
  ];
  int currentImageIndex = 0; // Index to cycle images

  /// Add weight to Firestore
  void _addWeight() async {
    final weight = weightController.text.trim();
    final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("No user logged in!");
      return;
    }

    if (weight.isNotEmpty) {
      try {
        // Select the next image URL
        String imageUrl = imageUrls[currentImageIndex];
        currentImageIndex = (currentImageIndex + 1) % imageUrls.length; // Increment and cycle index

        // Save to Firestore
        await FirebaseFirestore.instance
            .collection('weights')
            .doc(user.uid)
            .collection('userWeights')
            .add({
          'date': selectedDate,
          'weight': weight,
          'image': imageUrl,
        });
        print("Data successfully saved to Firestore");
      } catch (error) {
        print("Failed to save data to Firestore: $error");
      }

      weightController.clear();
      selectedDate = DateTime.now();
      Navigator.pop(context);
    }
  }

  /// Show date picker to select a date
  void _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  /// Fetch weights for the logged-in user
  Stream<QuerySnapshot> _fetchWeights() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Stream.empty();
    }
    return FirebaseFirestore.instance
        .collection('weights')
        .doc(user.uid)
        .collection('userWeights')
        .orderBy('date', descending: true)
        .snapshots();
  }

  /// Delete a weight from Firestore
  void _deleteWeight(String documentId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("No user logged in!");
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('weights')
          .doc(user.uid)
          .collection('userWeights')
          .doc(documentId)
          .delete();
      print("Weight successfully deleted from Firestore");
    } catch (error) {
      print("Failed to delete weight: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weight Tracker"),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _fetchWeights(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No data found. Add your weight."));
          }

          final weightDocs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: weightDocs.length,
            itemBuilder: (context, index) {
              final data = weightDocs[index].data() as Map<String, dynamic>;
              final date = (data['date'] as Timestamp).toDate();
              final weight = data['weight'];
              final imageUrl = data['image'] ?? 'https://via.placeholder.com/150'; // Default image
              final documentId = weightDocs[index].id;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    // Image Section
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                        image: DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Info Section
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat('EEEE, MMM d').format(date),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "$weight kg",
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Delete Button
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _deleteWeight(documentId);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    top: 16,
                    left: 16,
                    right: 16,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: weightController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Enter your weight (kg)",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            "Selected Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}",
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: _selectDate,
                            child: const Text("Pick Date"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _addWeight,
                        child: const Text("Add Weight"),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
