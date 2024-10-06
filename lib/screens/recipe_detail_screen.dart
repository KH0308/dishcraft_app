import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(title: Text(recipe.name)),
        body: SingleChildScrollView(
          physics: const RangeMaintainingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                recipe.imagePath != ''
                    ? Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.teal.shade900,
                          backgroundImage: FileImage(
                            File(recipe.imagePath),
                          ),
                        ),
                      )
                    : Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.teal.shade900,
                          child: const Icon(
                            Icons.fastfood_rounded,
                            color: Colors.white,
                            size: 80,
                          ),
                        ),
                      ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.60,
                  decoration: BoxDecoration(
                    color: Colors.teal.shade900,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                      25.0,
                      16.0,
                      25.0,
                      16.0,
                    ),
                    child: SingleChildScrollView(
                      physics: const RangeMaintainingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recipe.name,
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Ingredients:',
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          ...recipe.ingredients
                              .map(
                                (ingredient) => Text(
                                  ingredient,
                                  style: GoogleFonts.lato(
                                    fontSize: 12,
                                    color: Colors.grey.shade400,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              )
                              .toList(),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Steps:',
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          ...recipe.steps
                              .map(
                                (step) => Text(
                                  step,
                                  style: GoogleFonts.lato(
                                    fontSize: 12,
                                    color: Colors.grey.shade400,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              )
                              .toList(),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Get.to(() =>
                                      AddEditRecipeScreen(recipe: recipe));
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.black),
                                  fixedSize: MaterialStateProperty.all(
                                      const Size(110, 40)),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'Edit',
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  recipeController.deleteRecipe(recipe.id!);
                                  Get.back();
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.red),
                                  fixedSize: MaterialStateProperty.all(
                                      const Size(110, 40)),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'Delete',
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
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
