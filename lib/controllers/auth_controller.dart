// ignore_for_file: use_build_context_synchronously

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/database_service.dart';
import '../widgets/snackbar_widget.dart';

class AuthController extends GetxController {
  var isLoading = true.obs;
  var obsScrText = true.obs;
  SnackBarWidget snackBarWidget = SnackBarWidget();

  void updateObsScrText() {
    obsScrText.value = !obsScrText.value;
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

  Future<void> signInUser(
      String email, String pass, BuildContext context) async {
    try {
      isLoading(true);
      debugPrint('${isLoading.value}');
      var fetchSignIn = await DatabaseService.instance.authSignIn(email, pass);
      if (fetchSignIn['token'] == 'QpwL5tke4Pnpja7X4') {
        snackBarWidget.displaySnackBar(
          'Welcome Back',
          Colors.black,
          Colors.white,
          context,
        );
        isLoading(false);
        Get.offAllNamed('/homeScreen');
      } else {
        isLoading(false);
        snackBarWidget.displaySnackBar(
          '${fetchSignIn['error']}',
          Colors.black,
          Colors.red,
          context,
        );
      }
    } catch (e) {
      'Failed to sign in: $e';
    } finally {
      isLoading(false);
      debugPrint('Final loading state ${isLoading.value}');
    }
  }
}
