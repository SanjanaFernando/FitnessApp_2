import 'package:flutter/material.dart';
import '../../view/exercise/ExerciseTimerView.dart';
import '../../common/color_extension.dart';
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final List dataArr = [
    {
      "name": "Running",
      "image": "assets/img/2.png",
      "exercises": [
        {"number": "1", "title": "Warm-up Run", "time": "5 min"},
        {"number": "2", "title": "Interval Sprints", "time": "10 min"},
        {"number": "3", "title": "Cool Down Jog", "time": "5 min"},
      ]
    },
    {
      "name": "Push-Up",
      "image": "assets/img/3.png",
      "exercises": [
        {"number": "1", "title": "Incline Push-Ups", "time": "7 min"},
        {"number": "2", "title": "Standard Push-Ups", "time": "10 min"},
        {"number": "3", "title": "Wide Push-Ups", "time": "5 min"},
      ]
    },
    {
      "name": "Stretch",
      "image": "assets/img/stretch.png",
      "exercises": [
        {"number": "1", "title": "Forward Bend", "time": "3 min"},
        {"number": "2", "title": "Quad Stretch", "time": "2 min"},
        {"number": "3", "title": "Side Stretch", "time": "4 min"},
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: dataArr.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Workout Exercises",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: TColor.primary,
          bottom: TabBar(
            labelColor: TColor.primaryText,
            unselectedLabelColor: TColor.secondaryText,
            indicatorColor: TColor.green,
            tabs: dataArr.map((category) {
              return Tab(
                text: category["name"],
              );
            }).toList(),
          ),
        ),
        body: TabBarView(
          children: dataArr.map((category) {
            var exercises = category["exercises"] as List<Map<String, String>>;
            return ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                var exercise = exercises[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 16),
                    title: Text(
                      exercise["title"]!,
                      style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Time: ${exercise["time"]}",
                      style: TextStyle(color: TColor.secondaryText),
                    ),
                    leading: CircleAvatar(
                      backgroundColor: TColor.primary.withOpacity(0.2),
                      child: Text(
                        exercise["number"]!,
                        style: TextStyle(color: TColor.primary),
                      ),
                    ),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColor.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExerciseTimerView(
                              exerciseName: exercise["title"]!,
                              time: exercise["time"]!,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        "Start",
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
