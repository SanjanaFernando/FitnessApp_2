import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:workout_fitness/view/settings/switch_account_view.dart';
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
  double? bmi;

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
          weight = userDoc['weight'] ?? 0.0;
          height = userDoc['height'] ?? 0.0;
          bmi = (weight != null && height != null && height! > 0) ? weight! / (height! * height!) : 0.0;
        });
      }
    } catch (e) {
      debugPrint("Error fetching user details: $e");
    }
  }
  double? _calculateBMI(double? weight, double? height) {
    if (weight != null && height != null && height > 0) {
      // Convert height from cm to meters and calculate BMI
      double heightInMeters = height / 100;
      return weight / (heightInMeters * heightInMeters);
    }
    return null; // Return null if weight or height is not available
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
                                "Training Plan",
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
                        title: Text("Weight: ${weight ?? 0.0} kg"),
                      ),
                      ListTile(
                        title: Text("Height: ${height ?? 0.0} cm"),
                      ),
                      ListTile(
                        title: Text("BMI: ${_calculateBMI(weight, height)?.toStringAsFixed(2) ?? '0.0'}"),
                      ),
                      const SizedBox(height: 15),
                      const Divider(color: Colors.black26, height: 1),
                      const SizedBox(height: 15),
                      Container(
                        height: kTextTabBarHeight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Switch Account",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: TColor.secondaryText,
                                  fontWeight: FontWeight.w700),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Image.asset("assets/img/next.png",
                                  width: 18, height: 18),
                            ),
                          ],
                        ),
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
                          width: 30, // Explicitly set the size
                          height: 30, // Adjust size accordingly
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
