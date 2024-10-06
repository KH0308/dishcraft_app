import 'dart:io';

import 'package:flutter/material.dart';
import '../controllers/recipe_controller.dart';
import '../models/recipe.dart';
import 'package:get/get.dart';

import 'add_edit_recipe_screen.dart';

class RecipeDetailPage extends StatelessWidget {
  final Recipe recipe;
  final RecipeController recipeController = Get.find();

  RecipeDetailPage({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(recipe.name)),
      // body: Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     Image.file(File(recipe.imagePath)),
      //     Text('Ingredients:', style: TextStyle(fontWeight: FontWeight.bold)),
      //     ...recipe.ingredients.map((ingredient) => Text(ingredient)).toList(),
      //     SizedBox(height: 20),
      //     Text('Steps:', style: TextStyle(fontWeight: FontWeight.bold)),
      //     ...recipe.steps.map((step) => Text(step)).toList(),
      //     SizedBox(height: 20),
      //     ElevatedButton(
      //       onPressed: () {
      //         Get.to(() => AddEditRecipeScreen(recipe: recipe));
      //       },
      //       child: Text('Edit'),
      //     ),
      //     ElevatedButton(
      //       onPressed: () {
      //         recipeController.deleteRecipe(recipe.id!);
      //         Get.back();
      //       },
      //       child: Text('Delete'),
      //     ),
      //   ],
      // ),
    );
  }
}
