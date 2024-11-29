import 'package:flutter/material.dart';
import '../../common/color_extension.dart';

class TipsDetailView extends StatelessWidget {
  final Map<String, String> tObj;
  const TipsDetailView({super.key, required this.tObj});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.primary,
        centerTitle: true,
        elevation: 0.1,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Image.asset(
            "assets/img/black_white.png",
            width: 25,
            height: 25,
          ),
        ),
        title: Text(
          "Tip Details",
          style: TextStyle(
              color: TColor.white, fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                "assets/img/1.png",
                width: media.width,
                height: media.width * 0.55,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              Text(
                tObj["name"]!,
                style: TextStyle(
                    color: TColor.secondaryText,
                    fontSize: 22,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 15),
              Text(
                tObj["details"]!,
                style: TextStyle(
                    color: TColor.secondaryText,
                    fontSize: 16,
                    height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
