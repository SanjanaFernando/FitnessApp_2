import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeightView extends StatefulWidget {
  const WeightView({super.key});

  @override
  State<WeightView> createState() => _WeightViewState();
}

class _WeightViewState extends State<WeightView> {
  final List<Map<String, String>> myWeightArr = [
    {"name": "Monday, NOV 20", "image": "assets/img/w_1.png", "weight": "70 kg"},
    {"name": "Tuesday, NOV 21", "image": "assets/img/w_2.png", "weight": "71 kg"},
    {"name": "Wednesday, NOV 22", "image": "assets/img/w_3.png", "weight": "72 kg"},
    {"name": "Thursday, NOV 23", "image": "assets/img/w_2.png", "weight": "73 kg"},
    {"name": "Friday, NOV 24", "image": "assets/img/w_1.png", "weight": "74 kg"},
  ];


  int currentIndex = 0;
  final CarouselController _carouselController = CarouselController();
  final TextEditingController weightController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  void _addWeight() {
    setState(() {
      myWeightArr.add({
        "name": DateFormat('EEEE, MMM d').format(selectedDate),
        "image": "assets/img/w_2.png", // Use this specific image for all new entries
        "weight": "${weightController.text.trim()} kg",
      });
      weightController.clear();
      selectedDate = DateTime.now();
    });
    Navigator.pop(context); // Close the bottom sheet
  }


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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Weight Last 3 Weeks")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5, // Limit height
              child: CarouselSlider.builder(
                carouselController: _carouselController,
                options: CarouselOptions(
                  autoPlay: false,
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                ),
                itemCount: myWeightArr.length,
                itemBuilder: (context, index, realIndex) {
                  final Map<String, String> dObj = myWeightArr[index];
                  return Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.shade300,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: AssetImage(dObj["image"]!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dObj["name"]!,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    "Selected Date: ${myWeightArr[currentIndex]["name"]!}",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Weight: ${myWeightArr[currentIndex]["weight"]!}",
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return Padding(
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
                        Text("Selected Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}"),
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
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
