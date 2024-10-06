import 'package:dishcraft_app/widgets/snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/recipe_controller.dart';
import '../models/recipe.dart';
import '../models/recipe_type.dart';

class AddEditRecipeScreen extends StatelessWidget {
  AddEditRecipeScreen({super.key, this.recipe});
  final RecipeController recipeController = Get.find();
  final Recipe? recipe;
  final SnackBarWidget snackBarWidget = SnackBarWidget();

  final _nameController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _stepsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (recipe != null) {
      _nameController.text = recipe!.name;
      _ingredientsController.text = recipe!.ingredients.join(', ');
      _stepsController.text = recipe!.steps.join(', ');
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didiPop) async {
        if (!didiPop) {
          final response = await showDialog(
            context: context,
            builder: (context) => AlertDialog.adaptive(
              backgroundColor: Colors.teal.shade900,
              title: Text(
                'Are you sure to exit back?',
                style: GoogleFonts.lato(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text(
                'Your change will be not save',
                style: GoogleFonts.lato(
                  color: Colors.grey.shade400,
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop(false);
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    fixedSize: MaterialStateProperty.all(const Size(80, 20)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  child: Text(
                    'No',
                    style: GoogleFonts.lato(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop(true);
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    fixedSize: MaterialStateProperty.all(const Size(80, 20)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  child: Text(
                    'Yes',
                    style: GoogleFonts.lato(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          );

          if (response) {
            // Get.back();
            Navigator.of(context).pop();
          }
        }
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              recipe == null ? 'Add Recipe' : 'Edit Recipe',
              style: GoogleFonts.lato(
                color: Colors.teal.shade900,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name')),
                Obx(() {
                  return DropdownButton<RecipeType>(
                    hint: Text('Select Recipe Type'),
                    value: recipeController.selectedRecipeType.value,
                    onChanged: (RecipeType? newValue) {
                      recipeController.selectRecipeType(newValue);
                    },
                    items: recipeController.recipeTypes.map((RecipeType type) {
                      return DropdownMenuItem<RecipeType>(
                        value: type,
                        child: Text(type.type),
                      );
                    }).toList(),
                  );
                }),
                TextField(
                    controller: _ingredientsController,
                    decoration: InputDecoration(
                        labelText: 'Ingredients (comma-separated)')),
                TextField(
                    controller: _stepsController,
                    decoration:
                        InputDecoration(labelText: 'Steps (comma-separated)')),
                ElevatedButton(
                  onPressed: () {
                    final ingredientsList = _ingredientsController.text
                        .split(',')
                        .map((s) => s.trim())
                        .toList();
                    final stepsList = _stepsController.text
                        .split(',')
                        .map((s) => s.trim())
                        .toList();

                    if (recipe == null) {
                      recipeController.addRecipe(
                        Recipe(
                          name: _nameController.text,
                          type: recipeController.selectedRecipeType.value!.type,
                          imagePath: 'path/to/image',
                          ingredients: ingredientsList,
                          steps: stepsList,
                        ),
                      );
                      snackBarWidget.displaySnackBar(
                        'New recipe add successfully',
                        Colors.teal.shade900,
                        Colors.white,
                        context,
                      );
                    } else {
                      recipeController.updateRecipe(
                        Recipe(
                          id: recipe!.id,
                          name: _nameController.text,
                          type: recipeController.selectedRecipeType.value!.type,
                          imagePath: recipe!.imagePath,
                          ingredients: ingredientsList,
                          steps: stepsList,
                        ),
                      );
                      snackBarWidget.displaySnackBar(
                        'Recipe update successfully',
                        Colors.teal.shade900,
                        Colors.white,
                        context,
                      );
                    }
                    Get.back();
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.teal.shade900),
                    fixedSize: MaterialStateProperty.all(const Size(100, 30)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  child: Text(
                    recipe == null ? 'Add' : 'Update',
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: Colors.white,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
