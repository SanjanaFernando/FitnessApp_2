import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/color_extension.dart';
import '../../common_widget/tab_button.dart';

class ExerciseView2 extends StatefulWidget {
  const ExerciseView2({super.key});

  @override
  State<ExerciseView2> createState() => _ExerciseView2State();
}

class _ExerciseView2State extends State<ExerciseView2> {
  int isActiveTab = 0;

  // Tab-specific exercise data with YouTube video links
  final List<List<Map<String, String>>> tabData = [
    [
      {"name": "Push-Up", "image": "assets/img/pushups.PNG", "videoUrl": "https://youtube.com/shorts/ba8tr1NzwXU?feature=shared"},
      {"name": "Leg Extension", "image": "assets/img/legextension.PNG", "videoUrl": "https://youtube.com/shorts/XQeytI_bCsk?feature=shared"},
    ],
    [
      {"name": "Foot Stretches", "image": "assets/img/footstretch.PNG", "videoUrl": "https://youtube.com/shorts/oE6SQanl5e4?feature=shared"},
      {"name": "Toe Taps", "image": "assets/img/toetaps.PNG", "videoUrl": "https://youtube.com/shorts/S7DmQ0VYPZo?feature=shared"},
    ],
    [
      {"name": "Bicep Curls", "image": "assets/img/bicepcurls.PNG", "videoUrl": "https://youtube.com/shorts/iui51E31sX8?feature=shared"},
      {"name": "Tricep Dips", "image": "assets/img/tricepdips.PNG", "videoUrl": "https://youtube.com/shorts/9llvBAV4RHI?feature=shared"},
    ],
    [
      {"name": "Core Plank", "image": "assets/img/7.png", "videoUrl": "https://youtube.com/shorts/v25dawSzRTM?feature=shared"},
      {"name": "Mountain Climber", "image": "assets/img/mountainclimber.PNG", "videoUrl": "https://youtube.com/shorts/BF6tzsTmGMk?feature=shared"},
    ],
  ];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    var currentTabData = tabData[isActiveTab];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.primary,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image.asset(
            "assets/img/black_white.png",
            width: 25,
            height: 25,
          ),
        ),
        title: Text(
          "Exercise",
          style: TextStyle(
              color: TColor.white, fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: TColor.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TabButton2(
                    title: "Full Body",
                    isActive: isActiveTab == 0,
                    onPressed: () {
                      setState(() {
                        isActiveTab = 0;
                      });
                    },
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: TabButton2(
                    title: "Foot",
                    isActive: isActiveTab == 1,
                    onPressed: () {
                      setState(() {
                        isActiveTab = 1;
                      });
                    },
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: TabButton2(
                    title: "Arm",
                    isActive: isActiveTab == 2,
                    onPressed: () {
                      setState(() {
                        isActiveTab = 2;
                      });
                    },
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: TabButton2(
                    title: "Body",
                    isActive: isActiveTab == 3,
                    onPressed: () {
                      setState(() {
                        isActiveTab = 3;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: currentTabData.length,
              itemBuilder: (context, index) {
                var wObj = currentTabData[index];
                return GestureDetector(
                  onTap: () async {
                    final Uri url = Uri.parse(wObj["videoUrl"]!);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(color: TColor.white),
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              wObj["image"]!,
                              width: media.width,
                              height: media.width * 0.55,
                              fit: BoxFit.cover,
                            ),
                            Container(
                              width: media.width,
                              height: media.width * 0.55,
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5)),
                            ),
                            Image.asset(
                              "assets/img/play.png",
                              width: 60,
                              height: 60,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                wObj["name"]!,
                                style: TextStyle(
                                    color: TColor.secondaryText,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700),
                              ),
                              IconButton(
                                onPressed: () {
                                  // Optionally handle "more" actions here
                                },
                                icon: Image.asset(
                                  "assets/img/more.png",
                                  width: 25,
                                  height: 25,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
