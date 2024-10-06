// ignore_for_file: use_build_context_synchronously

import 'dart:io';

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
  final formKey = GlobalKey<FormState>();
  // String? selectedImage;

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
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Center(
                    child: Container(
                      width: 200, // Adjust the width as needed
                      height: 200, // Adjust the height as needed
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(100)),
                        border: Border.all(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                      child: Stack(
                        children: [
                          recipeController.selectedImage.value != ''
                              ? Container(
                                  decoration: ShapeDecoration(
                                    shadows: const [
                                      BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset(0, 4),
                                        blurRadius: 8,
                                      ),
                                    ],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    image: DecorationImage(
                                      image: FileImage(
                                        File(recipeController
                                            .selectedImage.value
                                            .toString()),
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : Container(
                                  decoration: ShapeDecoration(
                                    shadows: const [
                                      BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset(0, 4),
                                        blurRadius: 8,
                                      ),
                                    ],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    // shape: BoxShape.rectangle,
                                    image: const DecorationImage(
                                      image: AssetImage(
                                          "assets/images/dish_default.png"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                          recipeController.selectedImage.value == ''
                              ? Positioned(
                                  top: 5,
                                  right: 5,
                                  child: GestureDetector(
                                    onTap: () {
                                      recipeController.selectImage();
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.teal.shade900,
                                      child: const Icon(
                                        Icons.camera_alt_rounded,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                )
                              : Positioned(
                                  top: 5,
                                  right: 5,
                                  child: GestureDetector(
                                    onTap: () {
                                      recipeController.clearImage();
                                    },
                                    child: const CircleAvatar(
                                      backgroundColor: Colors.red,
                                      child: Icon(
                                        Icons.clear_rounded,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    controller: _nameController,
                    style: GoogleFonts.lato(
                      fontSize: 12,
                      color: Colors.black,
                      fontStyle: FontStyle.normal,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.text_fields_rounded),
                      prefixIconColor: Colors.teal.shade400,
                      contentPadding: const EdgeInsets.all(16.0),
                      labelText: 'Recipe Name',
                      hintText: 'Butter Milk Chicken',
                      floatingLabelStyle: GoogleFonts.lato(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal,
                      ),
                      labelStyle: GoogleFonts.lato(
                        color: Colors.black,
                        fontSize: 14,
                        fontStyle: FontStyle.normal,
                      ),
                      hintStyle: GoogleFonts.lato(
                        fontSize: 10,
                        color: Colors.grey,
                        fontStyle: FontStyle.normal,
                      ),
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal.shade400),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal.shade400),
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      errorStyle: const TextStyle(color: Colors.red),
                    ),
                  ),
                  Obx(() {
                    return DropdownButtonFormField<RecipeType>(
                      iconEnabledColor: Colors.teal.shade400,
                      dropdownColor: Colors.grey.shade200,
                      value: recipeController.selectedRecipeType.value,
                      items:
                          recipeController.recipeTypes.map((RecipeType type) {
                        return DropdownMenuItem<RecipeType>(
                          value: type,
                          child: Text(
                            type.type,
                            style: GoogleFonts.lato(
                              fontSize: 12,
                              color: Colors.black,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (RecipeType? newValue) {
                        recipeController.selectRecipeType(newValue);
                      },
                      decoration: InputDecoration(
                        labelText: 'Recipe Type',
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        contentPadding: const EdgeInsets.all(16.0),
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.teal.shade400,
                        ),
                        floatingLabelStyle: GoogleFonts.lato(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                        ),
                        labelStyle: GoogleFonts.lato(
                          color: Colors.black,
                          fontSize: 14,
                          fontStyle: FontStyle.normal,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal.shade400),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal.shade400),
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        errorStyle: const TextStyle(color: Colors.red),
                      ),
                    );
                  }),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingredient is required';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    controller: _ingredientsController,
                    style: GoogleFonts.lato(
                      fontSize: 12,
                      color: Colors.black,
                      fontStyle: FontStyle.normal,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.menu_book_rounded),
                      prefixIconColor: Colors.teal.shade400,
                      contentPadding: const EdgeInsets.all(16.0),
                      labelText: 'Ingredient',
                      hintText: 'Chicken 1/2, Coconut oil, ....',
                      helperText: 'Ingredients (comma-separated)',
                      floatingLabelStyle: GoogleFonts.lato(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal,
                      ),
                      labelStyle: GoogleFonts.lato(
                        color: Colors.black,
                        fontSize: 14,
                        fontStyle: FontStyle.normal,
                      ),
                      hintStyle: GoogleFonts.lato(
                        fontSize: 10,
                        color: Colors.grey,
                        fontStyle: FontStyle.normal,
                      ),
                      helperStyle: GoogleFonts.lato(
                        fontSize: 8,
                        color: Colors.red,
                        fontStyle: FontStyle.italic,
                      ),
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal.shade400),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal.shade400),
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      errorStyle: const TextStyle(color: Colors.red),
                    ),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Step is required';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    controller: _stepsController,
                    style: GoogleFonts.lato(
                      fontSize: 12,
                      color: Colors.black,
                      fontStyle: FontStyle.normal,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.list_alt_rounded),
                      prefixIconColor: Colors.teal.shade400,
                      contentPadding: const EdgeInsets.all(16.0),
                      labelText: 'Steps',
                      hintText: 'Cut Onion, Cut Chicken, ....',
                      helperText: 'Steps (comma-separated)',
                      floatingLabelStyle: GoogleFonts.lato(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal,
                      ),
                      labelStyle: GoogleFonts.lato(
                        color: Colors.black,
                        fontSize: 14,
                        fontStyle: FontStyle.normal,
                      ),
                      hintStyle: GoogleFonts.lato(
                        fontSize: 10,
                        color: Colors.grey,
                        fontStyle: FontStyle.normal,
                      ),
                      helperStyle: GoogleFonts.lato(
                        fontSize: 8,
                        color: Colors.red,
                        fontStyle: FontStyle.italic,
                      ),
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal.shade400),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal.shade400),
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      errorStyle: const TextStyle(color: Colors.red),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final ingredientsList = _ingredientsController.text
                          .split(',')
                          .map((s) => s.trim())
                          .toList();
                      final stepsList = _stepsController.text
                          .split(',')
                          .map((s) => s.trim())
                          .toList();
                      final isValidForm = formKey.currentState?.validate();

                      if (isValidForm != false && recipe == null) {
                        var resultState =
                            await recipeController.checkConnectivity();
                        if (resultState == true) {
                          recipeController.addRecipe(
                            Recipe(
                              name: _nameController.text,
                              type: recipeController
                                  .selectedRecipeType.value!.type,
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
                          snackBarWidget.displaySnackBar(
                            'Opps something wrong with connection',
                            Colors.red,
                            Colors.white,
                            context,
                          );
                        }
                      } else if (isValidForm != false && recipe != null) {
                        var resultState =
                            await recipeController.checkConnectivity();
                        if (resultState == true) {
                          recipeController.updateRecipe(
                            Recipe(
                              id: recipe!.id,
                              name: _nameController.text,
                              type: recipeController
                                  .selectedRecipeType.value!.type,
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
                        } else {
                          snackBarWidget.displaySnackBar(
                            'Opps something wrong with connection',
                            Colors.red,
                            Colors.white,
                            context,
                          );
                        }
                      } else {
                        snackBarWidget.displaySnackBar(
                          'All field need to be fill!!',
                          Colors.red,
                          Colors.white,
                          context,
                        );
                      }
                      Get.back();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.teal.shade900),
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
      ),
    );
  }
}
