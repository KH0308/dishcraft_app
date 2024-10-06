import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/recipe_controller.dart';
import '../models/recipe_type.dart';
import '../widgets/snackbar_widget.dart';
import 'add_edit_recipe_screen.dart';
import 'recipe_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final SnackBarWidget snackBarWidget = SnackBarWidget();
  final RecipeController recipeController = Get.put(RecipeController());

  @override
  Widget build(BuildContext context) {
    DateTime timeBackPressed = DateTime.now();

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (!didPop) {
          final difference = DateTime.now().difference(timeBackPressed);
          final isExitWarning = difference >= const Duration(seconds: 2);

          timeBackPressed = DateTime.now();

          if (isExitWarning) {
            snackBarWidget.displaySnackBar(
                'Press back again to exit',
                Colors.black,
                const Color.fromARGB(255, 175, 166, 166),
                context);
            // return false; // Prevents popping
          } else {
            ScaffoldMessenger.of(context).clearSnackBars();
            SystemNavigator.pop(); // Exits the app
          }
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: Container(
            width: MediaQuery.of(context).size.width,
            // height: MediaQuery.of(context).size.width * 0.95,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/DishCraft_bg_main.png"),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width * 0.10,
                  child: Row(
                    children: [
                      Text(
                        'Welcome ',
                        style: GoogleFonts.lato(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      Text(
                        'Chef',
                        style: GoogleFonts.lato(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      Obx(
                        () {
                          return DropdownButton<RecipeType>(
                            hint: Text(
                              'Filter by Type',
                              style: GoogleFonts.lato(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                            icon: Icon(
                              Icons.filter_list,
                              color: Colors.teal.shade900,
                              size: 24,
                            ),
                            value: recipeController.selectedRecipeType.value,
                            onChanged: (RecipeType? newValue) {
                              recipeController.selectRecipeType(newValue);
                            },
                            items: recipeController.recipeTypes
                                .map((RecipeType type) {
                              return DropdownMenuItem<RecipeType>(
                                value: type,
                                child: Text(type.type),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Obx(
                  () {
                    final filteredRecipes =
                        recipeController.selectedRecipeType.value == null
                            ? recipeController.recipes
                            : recipeController.recipes.where((recipe) {
                                return recipe.type ==
                                    recipeController
                                        .selectedRecipeType.value!.type;
                              }).toList();

                    return ListView.builder(
                      itemCount: filteredRecipes.length,
                      itemBuilder: (context, index) {
                        final recipe = filteredRecipes[index];
                        return Card(
                          color: Colors.grey.shade100,
                          shadowColor: Colors.black,
                          child: ListTile(
                            leading: recipe.imagePath != ''
                                ? CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.teal.shade900,
                                    backgroundImage: FileImage(
                                      File(recipe.imagePath),
                                    ),
                                  )
                                : Icon(
                                    Icons.book,
                                    color: Colors.teal.shade900,
                                    size: 24,
                                  ),
                            title: Text(
                              recipe.name,
                              style: GoogleFonts.lato(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              'Type: ${recipe.type}',
                              style: GoogleFonts.lato(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.to(() => AddEditRecipeScreen(
                                          recipe: recipe,
                                        ));
                                  },
                                  child: const Icon(Icons.edit),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    recipeController.deleteRecipe(recipe.id!);
                                  },
                                  child: const Icon(Icons.delete),
                                ),
                              ],
                            ),
                            onTap: () {
                              Get.to(() => RecipeDetailPage(recipe: recipe));
                              // Get.to('/addEditScreen', arguments: recipe);
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Get.to(() => AddEditRecipeScreen());
              // Get.to('/addEditScreen');
            },
            child: Icon(
              Icons.note_add_rounded,
              color: Colors.teal.shade900,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
