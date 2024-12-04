import 'dart:async';
import 'package:flutter/material.dart';

class ExerciseTimerView extends StatefulWidget {
  final String exerciseName;
  final String time;

  const ExerciseTimerView({
    Key? key,
    required this.exerciseName,
    required this.time,
  }) : super(key: key);

  @override
  State<ExerciseTimerView> createState() => _ExerciseTimerViewState();
}

class _ExerciseTimerViewState extends State<ExerciseTimerView> {
  late int totalSeconds; // Total time in seconds
  Timer? timer;
  bool isRunning = false; // Timer state (running/paused)

  @override
  void initState() {
    super.initState();
    // Parse "5 min" -> 5 * 60 seconds
    totalSeconds = int.parse(widget.time.split(" ")[0]) * 60;
  }

  /// Starts the timer
  void startTimer() {
    if (timer != null) timer!.cancel(); // Cancel any existing timer
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (totalSeconds > 0) {
          totalSeconds--; // Decrement totalSeconds
        } else {
          timer.cancel(); // Stop the timer when it reaches 0
          showTimerCompleteDialog(); // Notify the user
        }
      });
    });
    setState(() {
      isRunning = true; // Timer is now running
    });
  }

  /// Pauses the timer
  void pauseTimer() {
    if (timer != null) {
      timer!.cancel(); // Cancel the timer
    }
    setState(() {
      isRunning = false; // Timer is paused
    });
  }

  /// Resets the timer
  void resetTimer() {
    setState(() {
      totalSeconds = int.parse(widget.time.split(" ")[0]) * 60; // Reset time
      if (timer != null) {
        timer!.cancel(); // Cancel any running timer
      }
      isRunning = false; // Timer is reset
    });
  }

  /// Show a dialog when the timer completes
  void showTimerCompleteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Time's Up!"),
          content: Text("${widget.exerciseName} is complete."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    if (timer != null) timer!.cancel(); // Clean up the timer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate minutes and seconds for display
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exerciseName),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display Exercise Name
            Text(
              widget.exerciseName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            // Display Timer in "MM:SS" format
            Text(
              "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}",
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            // Control Buttons (Start/Pause/Reset)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: isRunning ? pauseTimer : startTimer,
                  child: Text(isRunning ? "Pause" : "Start"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: resetTimer,
                  child: const Text("Reset"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
