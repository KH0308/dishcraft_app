// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:dishcraft_app/widgets/snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/recipe_controller.dart';
import '../models/recipe.dart';
import '../models/recipe_type.dart';

class AddEditRecipeScreen extends StatefulWidget {
  const AddEditRecipeScreen({super.key, this.recipe});
  final Recipe? recipe;

  @override
  State<AddEditRecipeScreen> createState() => _AddEditRecipeScreenState();
}

class _AddEditRecipeScreenState extends State<AddEditRecipeScreen> {
  final RecipeController recipeController = Get.find();
  final SnackBarWidget snackBarWidget = SnackBarWidget();
  TextEditingController nameController = TextEditingController();
  TextEditingController ingredientsController = TextEditingController();
  TextEditingController stepsController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.recipe != null) {
      nameController.text = widget.recipe!.name;
      ingredientsController.text = widget.recipe!.ingredients.join(', ');
      stepsController.text = widget.recipe!.steps.join(', ');
      recipeController.selectedImage.value = widget.recipe!.imagePath;
      recipeController.selectedRecipeTypeOnEditCreate.value =
          recipeController.getRecipeTypeFromString(widget.recipe!.type);
      debugPrint(widget.recipe!.type);
    }
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    ingredientsController.dispose();
    stepsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            recipeController.clearImage();
            recipeController.selectedRecipeTypeOnEditCreate.value = null;
            Get.back();
          }
        }
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              widget.recipe == null ? 'Add Recipe' : 'Edit Recipe',
              style: GoogleFonts.lato(
                color: Colors.teal.shade900,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
          body: SingleChildScrollView(
            physics: const RangeMaintainingScrollPhysics(),
            child: Container(
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
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(100)),
                            border: Border.all(
                              color: Colors.white,
                              width: 2.0,
                            ),
                          ),
                          child: Obx(
                            () => Stack(
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
                                            borderRadius:
                                                BorderRadius.circular(100),
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
                                          color: Colors.white,
                                          shadows: const [
                                            BoxShadow(
                                              color: Colors.grey,
                                              offset: Offset(0, 4),
                                              blurRadius: 8,
                                            ),
                                          ],
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                              color: Colors.teal.shade900,
                                              width: 1.5,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
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
                                            backgroundColor:
                                                Colors.teal.shade900,
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
                                              size: 24,
                                            ),
                                          ),
                                        ),
                                      ),
                              ],
                            ),
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
                        controller: nameController,
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
                      const SizedBox(height: 15),
                      Obx(() {
                        return DropdownButtonFormField<RecipeType>(
                          iconEnabledColor: Colors.teal.shade400,
                          dropdownColor: Colors.grey.shade200,
                          value: recipeController
                              .selectedRecipeTypeOnEditCreate.value,
                          items: recipeController.recipeTypes
                              .map((RecipeType type) {
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
                            recipeController
                                .selectRecipeTypeOnEditUpdate(newValue);
                          },
                          validator: (value) {
                            if (value == null || value.type == '') {
                              return 'Recipe type is required';
                            }
                            return null;
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
                              borderSide:
                                  BorderSide(color: Colors.teal.shade400),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.teal.shade400),
                            ),
                            errorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            errorStyle: const TextStyle(color: Colors.red),
                          ),
                        );
                      }),
                      const SizedBox(height: 15),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingredient is required';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        controller: ingredientsController,
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
                            fontSize: 10,
                            color: Colors.teal.shade900,
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
                      const SizedBox(height: 15),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Step is required';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        controller: stepsController,
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
                            fontSize: 10,
                            color: Colors.teal.shade900,
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
                      const SizedBox(height: 25),
                      ElevatedButton(
                        onPressed: () async {
                          final ingredientsList = ingredientsController.text
                              .split(',')
                              .map((s) => s.trim())
                              .toList();
                          final stepsList = stepsController.text
                              .split(',')
                              .map((s) => s.trim())
                              .toList();
                          final isValidForm = formKey.currentState?.validate();

                          if (isValidForm != false &&
                              widget.recipe == null &&
                              recipeController.selectedImage.value != '' &&
                              recipeController
                                      .selectedRecipeTypeOnEditCreate.value !=
                                  null) {
                            var resultState =
                                await recipeController.checkConnectivity();
                            if (resultState == true) {
                              recipeController.addRecipe(
                                Recipe(
                                  name: nameController.text,
                                  type: recipeController
                                      .selectedRecipeTypeOnEditCreate
                                      .value!
                                      .type,
                                  imagePath:
                                      recipeController.selectedImage.value,
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
                              recipeController.clearImage();
                              recipeController
                                  .selectedRecipeTypeOnEditCreate.value = null;
                              Get.offAllNamed('/homeScreen');
                            } else {
                              snackBarWidget.displaySnackBar(
                                'Opps something wrong with connection',
                                Colors.red,
                                Colors.white,
                                context,
                              );
                            }
                          } else if (isValidForm != false &&
                              widget.recipe != null &&
                              recipeController.selectedImage.value != '') {
                            var resultState =
                                await recipeController.checkConnectivity();
                            if (resultState == true) {
                              recipeController.updateRecipe(
                                Recipe(
                                  id: widget.recipe!.id,
                                  name: nameController.text,
                                  type: recipeController
                                      .selectedRecipeTypeOnEditCreate
                                      .value!
                                      .type,
                                  imagePath:
                                      recipeController.selectedImage.value,
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
                              recipeController.clearImage();
                              recipeController
                                  .selectedRecipeTypeOnEditCreate.value = null;
                              Get.offAllNamed('/homeScreen');
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
                              'All field need to be fill include image!!',
                              Colors.red,
                              Colors.white,
                              context,
                            );
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.teal.shade900),
                          fixedSize:
                              MaterialStateProperty.all(const Size(100, 30)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        child: Text(
                          widget.recipe == null ? 'Add' : 'Update',
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
        ),
      ),
    );
  }
}
