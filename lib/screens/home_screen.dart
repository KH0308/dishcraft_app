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
          drawer: Drawer(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            shadowColor: Colors.white,
            child: Stack(
              children: [
                Column(
                  children: [
                    Theme(
                      data: Theme.of(context).copyWith(
                        dividerTheme:
                            const DividerThemeData(color: Colors.transparent),
                      ),
                      child: DrawerHeader(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.transparent,
                          ),
                          gradient: LinearGradient(
                              colors: [
                                Colors.teal.shade900,
                                Colors.teal.shade500,
                                Colors.white,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/DishCraft_logo.png'),
                                    fit: BoxFit.fill),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Text(
                                'DishCraft',
                                style: GoogleFonts.lato(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.logout_rounded,
                        color: Colors.teal.shade900,
                        size: 22,
                      ),
                      title: const Text('LogOut'),
                      onTap: () {
                        snackBarWidget.displaySnackBar('Successfull logout',
                            Colors.green, Colors.white, context);
                        recipeController.navigateToLogout();
                      },
                    ),
                  ],
                ),
                Positioned(
                  left: 50,
                  right: 50,
                  bottom: 20,
                  child: Container(
                    color: Colors.white,
                    child: Text(
                      'Version: 1.0.0+1',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Lato',
                        color: Colors.teal.shade900,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.95,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/DishCraft_bg_main.png"),
                fit: BoxFit.fill,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.teal.shade900,
                          Colors.teal.shade100,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.only(
                      left: 5,
                      right: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome',
                                style: GoogleFonts.lato(
                                  fontSize: 22,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                              Text(
                                '         Gastronomy',
                                style: GoogleFonts.lato(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                              Text(
                                '                              Expert',
                                style: GoogleFonts.lato(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Obx(
                          () {
                            return DropdownButton<RecipeType>(
                              selectedItemBuilder: (BuildContext context) {
                                return recipeController.recipeTypes
                                    .map<Widget>((RecipeType type) {
                                  return Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      type.type,
                                      style: GoogleFonts.lato(
                                        fontSize: 12,
                                        color: Colors.teal.shade900,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                }).toList();
                              },
                              menuMaxHeight: 150,
                              underline: const SizedBox.shrink(),
                              elevation: 18,
                              dropdownColor: Colors.teal.shade900,
                              focusColor: Colors.white,
                              hint: Text(
                                'Filter\nby Type',
                                style: GoogleFonts.lato(
                                  fontSize: 12,
                                  color: Colors.teal.shade900,
                                  fontWeight: FontWeight.bold,
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
                                  child: Text(
                                    type.type,
                                    style: GoogleFonts.lato(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
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
                          recipeController.selectedRecipeType.value == null ||
                                  recipeController
                                          .selectedRecipeType.value!.type ==
                                      "All"
                              ? recipeController.recipes
                              : recipeController.recipes.where((recipe) {
                                  return recipe.type ==
                                      recipeController
                                          .selectedRecipeType.value!.type;
                                }).toList();

                      return filteredRecipes.isNotEmpty
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.75,
                              child: ListView.builder(
                                itemCount: filteredRecipes.length,
                                itemBuilder: (context, index) {
                                  final recipe = filteredRecipes[index];
                                  return Card(
                                    color: Colors.teal.shade900,
                                    shadowColor: Colors.black,
                                    child: ListTile(
                                      tileColor: Colors.transparent,
                                      leading: recipe.imagePath != ''
                                          ? CircleAvatar(
                                              radius: 20,
                                              backgroundColor:
                                                  Colors.teal.shade900,
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
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        'Type: ${recipe.type}',
                                        style: GoogleFonts.lato(
                                          color: Colors.grey.shade400,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      trailing: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Get.to(() => AddEditRecipeScreen(
                                                    recipe: recipe,
                                                  ));
                                            },
                                            child: const Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                              size: 24,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              recipeController
                                                  .deleteRecipe(recipe.id!);
                                            },
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.red.shade700,
                                              size: 24,
                                            ),
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        Get.to(() =>
                                            RecipeDetailPage(recipe: recipe));
                                        // Get.to('/addEditScreen', arguments: recipe);
                                      },
                                    ),
                                  );
                                },
                              ),
                            )
                          : SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.75,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Recipe list is empty',
                                  style: GoogleFonts.lato(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            );
                    },
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.teal.shade900,
            onPressed: () {
              Get.to(() => AddEditRecipeScreen());
              // Get.to('/addEditScreen');
            },
            child: const Icon(
              Icons.note_add_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        ),
      ),
    );
  }
}
