import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../common/color_extension.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String? username;
  double? weight;
  double? height;
  int? birthYear;
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  void fetchUserDetails() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        setState(() {
          username = userDoc['username'] ?? "Profile";
          weight = userDoc['weight']?.toDouble() ?? 0.0;
          height = userDoc['height']?.toDouble() ?? 0.0;
          birthYear = userDoc['birthYear'] ?? 2000;
          weightController.text = weight.toString();
          heightController.text = height.toString();
        });
      }
    } catch (e) {
      debugPrint("Error fetching user details: $e");
    }
  }

  void updateUserDetails() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'weight': double.tryParse(weightController.text) ?? weight,
          'height': double.tryParse(heightController.text) ?? height,
        });
        setState(() {
          weight = double.tryParse(weightController.text);
          height = double.tryParse(heightController.text);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Details updated successfully!')),
        );
      }
    } catch (e) {
      debugPrint("Error updating user details: $e");
    }
  }

  double? _calculateBMI(double? weight, double? height) {
    if (weight != null && height != null && height > 0) {
      double heightInMeters = height / 100;
      return weight / (heightInMeters * heightInMeters);
    }
    return null;
  }

  int? _calculateAge(int? birthYear) {
    if (birthYear != null) {
      return DateTime.now().year - birthYear;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Drawer(
      width: media.width,
      backgroundColor: Colors.transparent,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 5.0,
          sigmaY: 5.0,
        ),
        child: Stack(
          children: [
            Container(
              width: media.width * 0.78,
              decoration: BoxDecoration(color: TColor.white),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Column(
                    children: [
                      Container(
                        height: kTextTabBarHeight,
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(22.5),
                              child: Image.asset("assets/img/u1.png",
                                  width: 45, height: 45, fit: BoxFit.cover),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Text(
                                "User Details",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: TColor.secondaryText,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Divider(color: Colors.black26, height: 1),
                      ListTile(
                        title: Text("Username: $username"),
                      ),
                      ListTile(
                        title: Text("Age: ${_calculateAge(birthYear) ?? 'Unknown'} years"),
                      ),
                      const Divider(color: Colors.black26, height: 1),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                        child: TextFormField(
                          controller: weightController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Weight (kg)",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),

                        child: TextFormField(
                          controller: heightController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Height (cm)",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: updateUserDetails,
                        child: const Text("Update Details"),
                      ),
                      const Divider(color: Colors.black26, height: 1),
                      ListTile(
                        title: Text(
                            "BMI: ${_calculateBMI(weight, height)?.toStringAsFixed(2) ?? '0.0'}"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              children: [
                const SizedBox(height: kToolbarHeight - 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Image.asset(
                          "assets/img/meun_close.png", // Ensure this path is correct
                          width: 30,
                          height: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
