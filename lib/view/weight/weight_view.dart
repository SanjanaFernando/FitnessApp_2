import 'package:carousel_slider/carousel_slider.dart';
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
  final CarouselController _carouselController = CarouselController();
  final TextEditingController weightController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  final List<String> imageUrls = [
    "https://plus.unsplash.com/premium_photo-1726862769772-dc8c33d980a3?q=80&w=1169&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    "https://plus.unsplash.com/premium_photo-1661301057249-bd008eebd06a?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    "https://plus.unsplash.com/premium_photo-1664477098603-042afd7d70de?q=80&w=1032&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
  ];
  int currentImageIndex = 0; // To keep track of the image index

  /// Add weight to Firestore
  void _addWeight() async {
    final weight = weightController.text.trim(); // Get weight input
    final formattedDate = DateFormat('EEEE, MMM d').format(selectedDate);

    final user = FirebaseAuth.instance.currentUser; // Get current user
    if (user == null) {
      print("No user logged in!");
      return;
    }

    if (weight.isNotEmpty) {
      try {
        // Cycle through the image URLs
        String imageUrl = imageUrls[currentImageIndex];

        // Save to Firestore under user's ID
        await FirebaseFirestore.instance
            .collection('weights')
            .doc(user.uid) // Use user ID as the document ID
            .collection('userWeights') // Nested collection for user's weights
            .add({
          'date': selectedDate, // Store as Firestore Timestamp
          'weight': weight,     // Store weight
          'image': imageUrl,    // Store image
        });
        print("Data successfully saved to Firestore");

        // Update the currentImageIndex to the next image in the list
        setState(() {
          currentImageIndex = (currentImageIndex + 1) % imageUrls.length;
        });
      } catch (error) {
        print("Failed to save data to Firestore: $error");
      }

      weightController.clear();
      selectedDate = DateTime.now();
      Navigator.pop(context); // Close the bottom sheet
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
    final user = FirebaseAuth.instance.currentUser; // Get current user
    if (user == null) {
      return const Stream.empty(); // If no user, return empty stream
    }
    return FirebaseFirestore.instance
        .collection('weights')
        .doc(user.uid) // Use user ID
        .collection('userWeights') // Fetch weights for the current user
        .orderBy('date')
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
      appBar: AppBar(title: const Text("Weight Tracker")),
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

          return Column(
            children: [
              Expanded(
                child: CarouselSlider.builder(
                  carouselController: _carouselController,
                  options: CarouselOptions(
                    autoPlay: false,
                    enlargeCenterPage: true,
                  ),
                  itemCount: weightDocs.length,
                  itemBuilder: (context, index, realIndex) {
                    final data = weightDocs[index].data() as Map<String, dynamic>;
                    final date = (data['date'] as Timestamp).toDate();
                    final weight = data['weight'];
                    final imageUrl = data['image'] ?? 'https://via.placeholder.com/150'; // Default image
                    final documentId = weightDocs[index].id; // Get document ID for deletion

                    return Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.shade300,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 130,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: NetworkImage(imageUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.white),
                                  onPressed: () {
                                    _deleteWeight(documentId); // Delete the record
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            DateFormat('EEEE, MMM d').format(date),
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "$weight kg",
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      // Floating Action Button to add weight
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true, // Ensures the BottomSheet can adjust for keyboard
            builder: (context) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
                    top: 16,
                    left: 16,
                    right: 16,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Input field for weight
                      TextField(
                        controller: weightController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Enter your weight (kg)",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Date picker
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
                      // Button to add weight
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
