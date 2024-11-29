import 'package:flutter/material.dart';

import '../../common/color_extension.dart';

class MealPlanView2 extends StatefulWidget {
  const MealPlanView2({super.key});

  @override
  State<MealPlanView2> createState() => _MealPlanView2State();
}

class _MealPlanView2State extends State<MealPlanView2> {
  String selectedCategory = "30Kg-40KG"; // Default category

  // Meal plans categorized by weight
  final Map<String, List<Map<String, String>>> mealPlans = {
    "30Kg-40KG": [
      {
        "name": "Breakfast",
        "title": "Vegetable Sandwich",
        "image": "assets/img/VegetableSandwitch.PNG",
        "calories": "350 kcal",
        "ingredients": "Whole grain bread, avocado, lettuce, tomato, cucumber",
        "instructions": "Toast bread, add avocado and vegetables, then serve."
      },
      {
        "name": "Lunch",
        "title": "Grilled Chicken Salad",
        "image": "assets/img/f1.png",
        "calories": "400 kcal",
        "ingredients": "Grilled chicken, mixed greens, tomatoes, olive oil, lemon juice",
        "instructions": "Toss ingredients together and serve."
      },
      {
        "name": "Dinner",
        "title": "Baked Salmon with Vegetables",
        "image": "assets/img/BakedSalmon.PNG",
        "calories": "450 kcal",
        "ingredients": "Salmon, broccoli, carrots, olive oil, garlic",
        "instructions": "Bake salmon and vegetables at 180°C for 20 minutes."
      },
      {
        "name": "Snack",
        "title": "Oats with Nut Butter",
        "image": "assets/img/Oats.PNG",
        "calories": "250 kcal",
        "ingredients": "Oats, almond butter, honey",
        "instructions": "Mix oats with nut butter and honey for a quick snack."
      },
    ],
    "41KG-50KG": [
      {
        "name": "Breakfast",
        "title": "Fruit Smoothie",
        "image": "assets/img/fruitsmoothie.PNG",
        "calories": "200 kcal",
        "ingredients": "Banana, strawberries, almond milk, honey",
        "instructions": "Blend all ingredients until smooth, then serve."
      },
      {
        "name": "Lunch",
        "title": "Quinoa and Veggie Bowl",
        "image": "assets/img/f3.png",
        "calories": "350 kcal",
        "ingredients": "Quinoa, spinach, cherry tomatoes, cucumber, lemon dressing",
        "instructions": "Mix cooked quinoa with vegetables and dressing."
      },
      {
        "name": "Dinner",
        "title": "Stir-Fried Tofu and Veggies",
        "image": "assets/img/stirfriedtofuandvegi.PNG",
        "calories": "400 kcal",
        "ingredients": "Tofu, bell peppers, carrots, soy sauce, sesame oil",
        "instructions": "Stir-fry tofu and vegetables in sesame oil and soy sauce."
      },
      {
        "name": "Snack",
        "title": "Yogurt with Berries",
        "image": "assets/img/yogurtwithberries.PNG",
        "calories": "180 kcal",
        "ingredients": "Greek yogurt, blueberries, raspberries, honey",
        "instructions": "Mix yogurt with berries and drizzle with honey."
      },
    ],
    "51KG-60KG": [
      {
        "name": "Breakfast",
        "title": "Eggs and Toast",
        "image": "assets/img/eggsandtoasts.PNG",
        "calories": "300 kcal",
        "ingredients": "Eggs, whole grain bread, avocado",
        "instructions": "Toast bread, cook eggs, and serve with avocado."
      },
      {
        "name": "Lunch",
        "title": "Chicken Wrap",
        "image": "assets/img/chickenwrap.PNG",
        "calories": "400 kcal",
        "ingredients": "Grilled chicken, tortilla, lettuce, tomato, yogurt dressing",
        "instructions": "Fill tortilla with ingredients and wrap tightly."
      },
      {
        "name": "Dinner",
        "title": "Beef Stir-Fry with Rice",
        "image": "assets/img/beeffrywithrice.PNG",
        "calories": "500 kcal",
        "ingredients": "Beef strips, bell peppers, rice, soy sauce, ginger",
        "instructions": "Stir-fry beef and vegetables, serve over rice."
      },
      {
        "name": "Snack",
        "title": "Mixed Nuts and Fruits",
        "image": "assets/img/fruitandnuts.PNG",
        "calories": "200 kcal",
        "ingredients": "Almonds, walnuts, dried apricots, raisins",
        "instructions": "Mix nuts and dried fruits in a bowl."
      },
    ],
    "61KG-70KG": [
      {
        "name": "Breakfast",
        "title": "Pancakes with Honey",
        "image": "assets/img/pancakewithhoney.PNG",
        "calories": "400 kcal",
        "ingredients": "Pancake mix, honey, berries",
        "instructions": "Cook pancakes, top with honey and berries, and serve."
      },
      {
        "name": "Lunch",
        "title": "Grilled Steak Salad",
        "image": "assets/img/steaksalad.PNG",
        "calories": "500 kcal",
        "ingredients": "Steak, mixed greens, cherry tomatoes, balsamic dressing",
        "instructions": "Grill steak, slice, and serve over salad."
      },
      {
        "name": "Dinner",
        "title": "Shrimp Pasta",
        "image": "assets/img/shrimppasta.PNG",
        "calories": "600 kcal",
        "ingredients": "Shrimp, pasta, garlic, olive oil, parsley",
        "instructions": "Cook pasta, sauté shrimp in garlic and olive oil, combine."
      },
      {
        "name": "Snack",
        "title": "Protein Shake",
        "image": "assets/img/protienshake.PNG",
        "calories": "300 kcal",
        "ingredients": "Protein powder, almond milk, banana",
        "instructions": "Blend all ingredients until smooth."
      },
    ],
  };


  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);

    // Fetch the meal plan for the selected category
    List<Map<String, String>> workArr =
        mealPlans[selectedCategory] ?? [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.primary,
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Meal Plan",
          style: TextStyle(
            color: TColor.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        children: [
          // Dropdown for Weight Category Selection
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text(
                  "Select Weight Category: ",
                  style: TextStyle(
                    color: TColor.secondaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                DropdownButton<String>(
                  value: selectedCategory,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue!;
                    });
                  },
                  items: mealPlans.keys.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: workArr.length,
              itemBuilder: (context, index) {
                var meal = workArr[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: TColor.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          meal["image"]!,
                          width: media.width,
                          height: media.width * 0.4,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        meal["name"]!,
                        style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        meal["title"]!,
                        style: TextStyle(
                          color: TColor.secondaryText,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Calories: ${meal["calories"]}",
                        style: TextStyle(color: TColor.gray, fontSize: 14),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Ingredients: ${meal["ingredients"]}",
                        style: TextStyle(color: TColor.gray, fontSize: 14),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Instructions: ${meal["instructions"]}",
                        style: TextStyle(color: TColor.gray, fontSize: 14),
                      ),
                    ],
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
