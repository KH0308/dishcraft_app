import 'package:dishcraft_app/widgets/snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SnackBarWidget snackBarWidget = SnackBarWidget();

  @override
  void initState() {
    super.initState();
    checkTokenStatus();
  }

  @override
  void dispose() {
    super.dispose();
  }

  navigateToOnBoard() {
    Get.offNamed('/onboardScreen');
    snackBarWidget.displaySnackBar(
        "Session Expired\n Re-SignIn Again", Colors.white, Colors.red, context);
  }

  navigateToHome() {
    Get.offNamed('/homeScreen');
    snackBarWidget.displaySnackBar(
        'Welcome Back', Colors.green, Colors.white, context);
  }

  checkTokenStatus() async {
    await Future.delayed(const Duration(seconds: 5), () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String tokenStore = prefs.getString('token') ?? '';

      if ((tokenStore.isEmpty || tokenStore == 'null')) {
        navigateToOnBoard();
      } else {
        navigateToHome();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.50,
              height: MediaQuery.of(context).size.height * 0.95,
              child: Lottie.asset(
                'assets/json/loading_animation.json',
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
