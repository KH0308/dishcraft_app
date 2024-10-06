import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dishcraft_app/services/database_service.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/recipe.dart';
import '../models/recipe_type.dart';

class RecipeController extends GetxController {
  var recipes = <Recipe>[].obs;
  var recipeTypes = <RecipeType>[].obs;
  var selectedRecipeType = Rxn<RecipeType>();
  var selectedRecipeTypeOnEditCreate = Rxn<RecipeType>();
  var selectedImage = ''.obs;
  File? imageSelected;

  @override
  void onInit() {
    fetchRecipes();
    loadRecipeTypes();
    super.onInit();
  }

  checkConnectivity() async {
    var connectionResult = await Connectivity().checkConnectivity();

    if (connectionResult != ConnectivityResult.mobile &&
        connectionResult != ConnectivityResult.wifi) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> loadRecipeTypes() async {
    final String response =
        await rootBundle.loadString('assets/json/recipetypes.json');
    final data = json.decode(response) as List;
    recipeTypes.value = data.map((json) => RecipeType.fromJson(json)).toList();
  }

  void selectRecipeType(RecipeType? type) {
    selectedRecipeType.value = type;
  }

  void selectRecipeTypeOnEditUpdate(RecipeType? type) {
    selectedRecipeTypeOnEditCreate.value = type;
  }

  RecipeType? getRecipeTypeFromString(String type) {
    return recipeTypes.firstWhere(
      (recipeType) => recipeType.type == type,
    );
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

  void selectImage() async {
    var imagePicker = ImagePicker();
    var pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      selectedImage.value = pickedImage.path;
    }
  }

  void clearImage() async {
    selectedImage.value = '';
  }

  void navigateToLogout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("token");
    Get.offAllNamed('/signinScreen');
  }
}
