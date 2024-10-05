import 'package:get/get.dart';

import '../screens/home_screen.dart';
import '../screens/onBoard_screen.dart';
import '../screens/signin_screen.dart';
import '../screens/splash_screen.dart';

class AppRoute {
  static final routes = [
    GetPage(name: '/splashScreen', page: () => const SplashScreen()),
    GetPage(name: '/onboardScreen', page: () => const OnBoardScreen()),
    GetPage(name: '/signinScreen', page: () => const SignInScreen()),
    GetPage(name: '/homeScreen', page: () => const HomeScreen()),
    // GetPage(name: '/novelOTPValidation', page: () => OTPScreen()),
    // GetPage(name: '/novelListHome', page: () => NovelListHomeScreen()),
    // GetPage(name: '/novelDetail', page: () => NovelDetailsScreen()),
  ];
}
