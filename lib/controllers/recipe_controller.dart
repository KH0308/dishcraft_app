import 'dart:convert';
import 'package:dishcraft_app/services/database_service.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../models/recipe.dart';
import '../models/recipe_type.dart';

class RecipeController extends GetxController {
  var recipes = <Recipe>[].obs;
  var recipeTypes = <RecipeType>[].obs;
  var selectedRecipeType = Rxn<RecipeType>();

  @override
  void onInit() {
    fetchRecipes();
    loadRecipeTypes();
    super.onInit();
  }

  Future<void> loadRecipeTypes() async {
    final String response =
        await rootBundle.loadString('assets/recipetypes.json');
    final data = json.decode(response) as List;
    recipeTypes.value = data.map((json) => RecipeType.fromJson(json)).toList();
  }

  void selectRecipeType(RecipeType? type) {
    selectedRecipeType.value = type;
  }

  Future<void> fetchRecipes() async {
    final data = await DatabaseService.instance.getRecipes();
    recipes.value = data.map((json) => Recipe.fromJson(json)).toList();
  }

  Future<void> addRecipe(Recipe recipe) async {
    await DatabaseService.instance.createRecipe(recipe.toJson());
    fetchRecipes();
  }

  Future<void> updateRecipe(Recipe recipe) async {
    await DatabaseService.instance.updateRecipe(recipe.id!, recipe.toJson());
    fetchRecipes();
  }

  Future<void> deleteRecipe(int id) async {
    await DatabaseService.instance.deleteRecipe(id);
    fetchRecipes();
  }
}
