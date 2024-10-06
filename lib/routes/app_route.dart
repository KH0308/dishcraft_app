import 'package:get/get.dart';

import '../screens/add_edit_recipe_screen.dart';
import '../screens/home_screen.dart';
import '../screens/onBoard_screen.dart';
// import '../screens/recipe_detail_screen.dart';
import '../screens/signin_screen.dart';
import '../screens/splash_screen.dart';

class AppRoute {
  static final routes = [
    GetPage(name: '/splashScreen', page: () => const SplashScreen()),
    GetPage(name: '/onboardScreen', page: () => const OnBoardScreen()),
    GetPage(name: '/signinScreen', page: () => const SignInScreen()),
    GetPage(name: '/homeScreen', page: () => HomeScreen()),
    GetPage(name: '/addEditScreen', page: () => AddEditRecipeScreen()),
    // GetPage(name: '/detailScreen', page: () => RecipeDetailPage(recipe: null,)),
  ];
}
