import 'package:flutter/material.dart';
import '../../common/color_extension.dart';

class TrainPlan extends StatefulWidget {
  const TrainPlan({super.key});

  @override
  State<TrainPlan> createState() => _TrainPlanState();
}

class _TrainPlanState extends State<TrainPlan> {
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  String bmiResult = "";
  String fitnessEvaluation = "";
  List<Map<String, dynamic>> trainingPlan = [];

  void _calculateBMI() {
    double weight = double.tryParse(weightController.text.trim()) ?? 0;
    double height = double.tryParse(heightController.text.trim()) ?? 0;

    if (weight <= 0 || height <= 0) {
      setState(() {
        bmiResult = "Invalid input!";
        fitnessEvaluation = "";
        trainingPlan = [];
      });
      return;
    }

    double bmi = weight / ((height / 100) * (height / 100)); // BMI formula
    String evaluation;
    if (bmi < 18.5) {
      evaluation = "Underweight";
    } else if (bmi >= 18.5 && bmi < 24.9) {
      evaluation = "Normal";
    } else if (bmi >= 25 && bmi < 29.9) {
      evaluation = "Overweight";
    } else {
      evaluation = "Obese";
    }

    setState(() {
      bmiResult = "BMI: ${bmi.toStringAsFixed(2)} ($evaluation)";
      fitnessEvaluation = evaluation;
      _generateTrainingPlan(evaluation);
    });
  }

  void _generateTrainingPlan(String evaluation) {
    trainingPlan.clear();
    switch (evaluation) {
      case "Underweight":
        trainingPlan = [
          {
            "week": "Week 1",
            "plan": [
              {"name": "Warm-up Run", "time": "5 min"},
              {"name": "Incline Push-Ups", "time": "7 min"},
              {"name": "Forward Bend Stretch", "time": "3 min"},
            ],
          },
          {
            "week": "Week 2",
            "plan": [
              {"name": "Interval Sprints", "time": "10 min"},
              {"name": "Standard Push-Ups", "time": "10 min"},
              {"name": "Side Stretch", "time": "4 min"},
            ],
          },
          {
            "week": "Week 3",
            "plan": [
              {"name": "Cool Down Jog", "time": "5 min"},
              {"name": "Wide Push-Ups", "time": "5 min"},
              {"name": "Quad Stretch", "time": "2 min"},
            ],
          },
          {
            "week": "Week 4",
            "plan": [
              {"name": "Dynamic Warm-up", "time": "5 min"},
              {"name": "Full-body Strength Training", "time": "15 min"},
              {"name": "Comprehensive Stretching", "time": "8 min"},
            ],
          },
        ];
        break;

      case "Normal":
        trainingPlan = [
          {
            "week": "Week 1",
            "plan": [
              {"name": "Warm-up Run", "time": "5 min"},
              {"name": "Standard Push-Ups", "time": "10 min"},
              {"name": "Forward Bend Stretch", "time": "3 min"},
            ],
          },
          {
            "week": "Week 2",
            "plan": [
              {"name": "Interval Sprints", "time": "10 min"},
              {"name": "Wide Push-Ups", "time": "5 min"},
              {"name": "Side Stretch", "time": "4 min"},
            ],
          },
          {
            "week": "Week 3",
            "plan": [
              {"name": "Cool Down Jog", "time": "5 min"},
              {"name": "Strength Training", "time": "10 min"},
              {"name": "Quad Stretch", "time": "2 min"},
            ],
          },
          {
            "week": "Week 4",
            "plan": [
              {"name": "HIIT Cardio", "time": "20 min"},
              {"name": "Core Strengthening", "time": "15 min"},
              {"name": "Dynamic Stretching", "time": "5 min"},
            ],
          },
        ];
        break;

      case "Overweight":
        trainingPlan = [
          {
            "week": "Week 1",
            "plan": [
              {"name": "Brisk Walking", "time": "20 min"},
              {"name": "Incline Push-Ups", "time": "5 min"},
              {"name": "Side Stretch", "time": "3 min"},
            ],
          },
          {
            "week": "Week 2",
            "plan": [
              {"name": "Low-Impact Cardio", "time": "30 min"},
              {"name": "Standard Push-Ups", "time": "7 min"},
              {"name": "Forward Bend Stretch", "time": "3 min"},
            ],
          },
          {
            "week": "Week 3",
            "plan": [
              {"name": "Moderate Cardio", "time": "40 min"},
              {"name": "Wide Push-Ups", "time": "5 min"},
              {"name": "Quad Stretch", "time": "2 min"},
            ],
          },
          {
            "week": "Week 4",
            "plan": [
              {"name": "Dynamic Cardio", "time": "50 min"},
              {"name": "Core Training", "time": "10 min"},
              {"name": "Dynamic Stretching", "time": "6 min"},
            ],
          },
        ];
        break;

      case "Obese":
        trainingPlan = [
          {
            "week": "Week 1",
            "plan": [
              {"name": "Walking", "time": "15 min"},
              {"name": "Light Stretching", "time": "5 min"},
              {"name": "Quad Stretch", "time": "3 min"},
            ],
          },
          {
            "week": "Week 2",
            "plan": [
              {"name": "Low-Impact Cardio", "time": "20 min"},
              {"name": "Bodyweight Exercises", "time": "5 min"},
              {"name": "Side Stretch", "time": "2 min"},
            ],
          },
          {
            "week": "Week 3",
            "plan": [
              {"name": "Moderate Cardio", "time": "30 min"},
              {"name": "Strength Training", "time": "10 min"},
              {"name": "Forward Bend Stretch", "time": "3 min"},
            ],
          },
          {
            "week": "Week 4",
            "plan": [
              {"name": "Dynamic Cardio", "time": "40 min"},
              {"name": "Comprehensive Strength Training", "time": "15 min"},
              {"name": "Stretching Routine", "time": "10 min"},
            ],
          },
        ];
        break;

      default:
        trainingPlan = [];
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Personalized Training Plan"),
        backgroundColor: TColor.primary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Enter your details:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: TColor.primaryText,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Weight (kg)",
                  border: const OutlineInputBorder(),
                  labelStyle: TextStyle(color: TColor.secondaryText),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: TColor.primary),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: heightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Height (cm)",
                  border: const OutlineInputBorder(),
                  labelStyle: TextStyle(color: TColor.secondaryText),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: TColor.primary),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _calculateBMI,
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColor.primary,
                  foregroundColor: TColor.white,
                ),
                child: const Text("Calculate BMI & Show Plan"),
              ),
              const SizedBox(height: 16),
              if (bmiResult.isNotEmpty)
                Text(
                  bmiResult,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: TColor.primaryText,
                  ),
                ),
              const SizedBox(height: 16),
              if (trainingPlan.isNotEmpty) ...[
                Text(
                  "Your 4-Week Training Plan:",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: TColor.primaryText,
                  ),
                ),
                const SizedBox(height: 8),
                ...trainingPlan.map((week) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Card(
                      color: TColor.gray,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              week["week"],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: TColor.primaryText,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...week["plan"].map<Widget>((exercise) {
                              return Text(
                                "• ${exercise['name']} (${exercise['time']})",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: TColor.secondaryText,
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
