import 'package:flutter/material.dart';
import 'package:workout_fitness/view/tips/tips_details_view.dart';
import '../../common/color_extension.dart';

class TipsView extends StatefulWidget {
  const TipsView({super.key});

  @override
  State<TipsView> createState() => _TipsViewState();
}

class _TipsViewState extends State<TipsView> {
  final List<Map<String, String>> tipsArr = [
    {
      "name": "About Training",
      "details": """
    - Regular physical activity improves overall health and fitness.
    - Builds strength, endurance, and flexibility.
    - Includes cardio, strength training, and recovery sessions.
    - Gradual intensity increase prevents injuries.
    - Boosts mental health, reduces stress, and promotes better sleep.
    - Clear goals and progress tracking keep you motivated.
    """
    },
    {
      "name": "How to Weight Loss?",
      "details": """
    - Create a calorie deficit by burning more calories than consumed.
    - Focus on whole, unprocessed foods like fruits, vegetables, and lean proteins.
    - Combine cardio and strength training to burn calories and maintain muscle.
    - Stay hydrated and ensure adequate sleep for better weight management.
    - Consistency and patience are key to sustainable weight loss.
    """
    },
    {
      "name": "Introducing About Meal Plan",
      "details": """
    - Meal planning helps achieve dietary goals and balance macronutrients.
    - Ensures consistent nutrition and supports fitness objectives.
    - Reduces reliance on unhealthy, processed foods.
    - Saves time and eliminates stress during busy schedules.
    - Customizing meal plans ensures they are sustainable and enjoyable.
    """
    },
    {
      "name": "Water and Food",
      "details": """
    - Water is essential for digestion, absorption, and nutrient transportation.
    - Helps maintain hydration and supports metabolism.
    - Enhances nutrient utilization and reduces overeating when paired with meals.
    - Water-rich foods like fruits and vegetables keep you hydrated and energized.
    - Proper hydration improves overall wellness.
    """
    },
    {
      "name": "Drink Water",
      "details": """
    - Supports digestion, regulates body temperature, and enhances skin health.
    - Helps flush out toxins and lubricates joints.
    - Drinking water before meals can reduce appetite and aid digestion.
    - Improves energy levels and focus throughout the day.
    - Listen to your body’s thirst signals to stay properly hydrated.
    """
    },
    {
      "name": "How Many Times a Day to Eat",
      "details": """
    - Eating 4–6 smaller meals keeps energy levels steady and prevents overeating.
    - Stabilizes blood sugar levels and ensures efficient digestion.
    - Include a balance of protein, healthy fats, and complex carbohydrates.
    - Spacing meals evenly aids in nutrient absorption.
    - Choose a meal frequency that aligns with your schedule and dietary needs.
    """
    },
    {
      "name": "Become Stronger",
      "details": """
    - Incorporate resistance training and compound exercises like squats and deadlifts.
    - Gradually increase weights to challenge muscles and promote growth.
    - Eat protein-rich foods for muscle repair and recovery.
    - Prioritize rest days for muscle healing and strength building.
    - Flexibility and mobility exercises reduce injury risks and improve balance.
    """
    },
    {
      "name": "Shoes To Training",
      "details": """
    - Proper training shoes enhance comfort, safety, and performance.
    - Provide cushioning, arch support, and stability based on activity.
    - Running shoes focus on forward motion, while cross-training shoes offer lateral support.
    - Replace worn-out shoes regularly to maintain effectiveness.
    - Choose well-fitting shoes suited to your specific training needs.
    """
    },
    {
      "name": "Appeal Tips",
      "details": """
    - Wear breathable, moisture-wicking fabrics for comfort and focus.
    - Choose well-fitted clothing to allow freedom of movement.
    - Use weather-appropriate layers for outdoor activities.
    - Invest in comfortable footwear and supportive undergarments.
    - Accessorize with essentials like sweatbands or gloves as needed.
    - Feeling good in your outfit boosts confidence and motivation.
    """
    },
  ];



  @override
  Widget build(BuildContext context) {
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
          "Tips",
          style: TextStyle(
              color: TColor.white, fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemBuilder: (context, index) {
          final tObj = tipsArr[index];
          return ListTile(
            title: Text(
              tObj["name"]!,
              style: TextStyle(
                  color: TColor.secondaryText,
                  fontWeight: FontWeight.w600,
                  fontSize: 16),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black54),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TipsDetailView(tObj: tObj),
                ),
              );
            },
          );
        },
        separatorBuilder: (context, index) => const Divider(
          color: Colors.black26,
          height: 1,
        ),
        itemCount: tipsArr.length,
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {},
                child: Image.asset("assets/img/menu_running.png",
                    width: 25, height: 25),
              ),
              InkWell(
                onTap: () {},
                child: Image.asset("assets/img/menu_meal_plan.png",
                    width: 25, height: 25),
              ),
              InkWell(
                onTap: () {},
                child: Image.asset("assets/img/menu_home.png",
                    width: 25, height: 25),
              ),
              InkWell(
                onTap: () {},
                child: Image.asset("assets/img/menu_weight.png",
                    width: 25, height: 25),
              ),
              InkWell(
                onTap: () {},
                child:
                Image.asset("assets/img/more.png", width: 25, height: 25),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
