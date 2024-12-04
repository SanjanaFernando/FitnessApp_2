import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:workout_fitness/view/Authentication/register_view.dart';
import 'package:workout_fitness/view/home/home_view.dart';
import 'package:workout_fitness/view/meal_plan/meal_plan_view_2.dart';


import 'package:workout_fitness/view/user/user_view.dart';

import '../../common/color_extension.dart';
import '../../common_widget/menu_cell.dart';
import '../../common_widget/plan_row.dart';
import '../exercise/exercise_view_2.dart';
import '../meal_plan/meal_plan_view_2.dart';
import '../running/running_view.dart';
import '../schedule/schedule_view.dart';
import '../tips/tips_view.dart';
import '../weight/weight_view.dart';
import '../../view/trainplan/train_plan.dart';
import '../../view/settings/switch_account_view.dart';
import '../../view/menu/customer_drawer.dart';
import '../../view/user/user_view.dart';

class MenuView extends StatefulWidget {
  const MenuView({super.key});

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  List planArr = [
    {
      "name": "Running",
      "icon": "assets/img/menu_running.png",
      "right_icon": "",
    },
    {
      "name": "Yoga",
      "icon": "assets/img/yoga.png",
      "right_icon": "assets/img/information.png",
    },
    {
      "name": "Workout",
      "icon": "assets/img/workout.png",
      "right_icon": "",
    },
    {
      "name": "Walking",
      "icon": "assets/img/walking.png",
      "right_icon": "",
    },
    {
      "name": "Fitness",
      "icon": "assets/img/fitness.png",
      "right_icon": "assets/img/information.png",
    },
    {
      "name": "Strength",
      "icon": "assets/img/strength.png",
      "right_icon": "",
    }
  ];

  List menuArr = [
    {"name": "Exercises", "image": "assets/img/menu_exercises.png", "tag": "1"},
    {"name": "Weight", "image": "assets/img/menu_weight.png", "tag": "2"},
    {
      "name": "Training plan",
      "image": "assets/img/menu_traning_plan.png",
      "tag": "3"
    },
    {"name": "Meal Plan", "image": "assets/img/menu_meal_plan.png", "tag": "5"},
    {"name": "Running", "image": "assets/img/menu_running.png", "tag": "7"},
    {"name": "Tutorials", "image": "assets/img/menu_tutorial.png", "tag": "8"},
    {"name": "Tips", "image": "assets/img/menu_tips.png", "tag": "9"},
    {"name": "Edit Account", "image": "assets/img/menu_edituser.png", "tag": "10"},
    {"name": "Register", "image": "assets/img/menu_register.png", "tag": "11"},

  ];


  String? username;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    fetchUsername();
  }

  void fetchUsername() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        setState(() {
          username = userDoc['username'] ?? "Profile"; // Default if not found
        });
      }
    } catch (e) {
      debugPrint("Error fetching username: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Scaffold(
        drawer: const CustomDrawer(),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.black,
              expandedHeight: media.width * 0.6,
              collapsedHeight: kToolbarHeight + 20,
              leading: Builder(
                builder: (context) {
                  return IconButton(
                    icon: Image.asset(
                      "assets/img/meun_close.png",
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                    ),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
              flexibleSpace: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  Image.asset(
                    "assets/img/1.png",
                    width: media.width,
                    height: media.width * 0.8,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    width: media.width,
                    height: media.width * 0.8,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                    child: Row(
                      children: [
                        Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                              color: TColor.white,
                              borderRadius: BorderRadius.circular(27)),
                          alignment: Alignment.center,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Image.asset(
                              "assets/img/u1.png",
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                    const SwitchAccountView()),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "RUH Fitness",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: TColor.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  username ?? "Profile",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: TColor.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          ];
        },
        body: GridView.builder(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 1,
          ),
          itemCount: menuArr.length,
          itemBuilder: ((context, index) {
            var mObj = menuArr[index] as Map? ?? {};
            return MenuCell(
              mObj: mObj,
              onPressed: () {
                switch (mObj["tag"].toString()) {
                  case "1":
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeView()),
                    );
                    break;
                  case "2":
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WeightView()),
                    );
                    break;
                  case "3":
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TrainPlan()),
                    );
                    break;
                  case "5":
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MealPlanView2()),
                    );
                    break;
                  case "6":
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ScheduleView()),
                    );
                    break;
                  case "7":
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RunningView()),
                    );
                    break;
                  case "8":
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ExerciseView2()),
                    );
                    break;
                  case "9":
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TipsView()),
                    );
                    break;
                  case "10":
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UserDetailsPage(),
                      ),
                    );

                    break;
                  case "11":
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>  CreateAccountPage()),
                    );
                    // Add your navigation logic for "Support" here
                    break;
                  default:
                }
              },
            );
          }),
        ),
      ),
    );
  }
}