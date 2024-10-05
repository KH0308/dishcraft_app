// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/auth_controller.dart';
import '../widgets/snackbar_widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  SnackBarWidget snackBarWidget = SnackBarWidget();
  DateTime timeBackPressed = DateTime.now();
  final formKey = GlobalKey<FormState>();
  AuthController authController = Get.put(AuthController());
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (!didPop) {
          final difference = DateTime.now().difference(timeBackPressed);
          final isExitWarning = difference >= const Duration(seconds: 2);

          timeBackPressed = DateTime.now();

          if (isExitWarning) {
            snackBarWidget.displaySnackBar('Press back again to exit',
                Colors.black, Colors.white, context);
            // return false; // Prevents popping
          } else {
            ScaffoldMessenger.of(context).clearSnackBars();
            SystemNavigator.pop(); // Exits the app
          }
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            physics: const RangeMaintainingScrollPhysics(),
            child: Container(
              width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.width * 0.95,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/DishCraft_bg_main.png"),
                  fit: BoxFit.fill,
                ),
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * 0.90,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                          5,
                          80,
                          5,
                          20,
                        ),
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage(
                                  "assets/images/DishCraft_logo.png"),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        'Sign In',
                        style: GoogleFonts.lato(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Email is required';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              controller: emailController,
                              style: GoogleFonts.lato(
                                fontSize: 12,
                                color: Colors.black,
                                fontStyle: FontStyle.normal,
                              ),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.email_rounded),
                                prefixIconColor: Colors.teal.shade900,
                                labelText: 'Email',
                                hintText: 'abc@provider.com',
                                hintStyle: GoogleFonts.lato(
                                  fontSize: 10,
                                  color: Colors.grey,
                                  fontStyle: FontStyle.normal,
                                ),
                                fillColor: Colors.grey.shade200,
                                filled: true,
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.all(16.0),
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
                                      BorderSide(color: Colors.teal.shade900),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.teal.shade900),
                                ),
                                errorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                                errorStyle: const TextStyle(color: Colors.red),
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Obx(
                              () => TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Password is required';
                                  }
                                  return null;
                                },
                                // keyboardType: TextInputType.visiblePassword,
                                textInputAction: TextInputAction.done,
                                controller: passwordController,
                                style: GoogleFonts.lato(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontStyle: FontStyle.normal,
                                ),
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.lock_rounded),
                                  prefixIconColor: Colors.teal.shade900,
                                  labelText: 'Password',
                                  hintText: '**********',
                                  hintStyle: GoogleFonts.lato(
                                    fontSize: 10,
                                    color: Colors.grey,
                                    fontStyle: FontStyle.normal,
                                  ),
                                  fillColor: Colors.grey.shade200,
                                  filled: true,
                                  border: const OutlineInputBorder(),
                                  contentPadding: const EdgeInsets.all(16.0),
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
                                        BorderSide(color: Colors.teal.shade900),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.teal.shade900),
                                  ),
                                  errorBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  errorStyle:
                                      const TextStyle(color: Colors.red),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                        authController.obsScrText.value
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: authController.obsScrText.value
                                            ? Colors.black12
                                            : Colors.teal.shade900),
                                    onPressed: () {
                                      // setState(() {
                                      //   obsScrText = !obsScrText;
                                      // });
                                      authController.updateObsScrText();
                                    },
                                  ),
                                ),
                                obscureText: authController.obsScrText.value,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Obx(
                        () => ElevatedButton(
                          onPressed: () async {
                            final isValidForm =
                                formKey.currentState?.validate();
                            if (isValidForm != false) {
                              var resultState =
                                  await authController.checkConnectivity();
                              if (resultState == true) {
                                authController.signInUser(
                                  emailController.text,
                                  passwordController.text,
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
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.teal.shade900),
                            fixedSize:
                                MaterialStateProperty.all(const Size(100, 30)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          child: authController.isLoading.isTrue
                              ? Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.teal.shade900,
                                      strokeWidth: 4.0,
                                      strokeCap: StrokeCap.round,
                                      valueColor: const AlwaysStoppedAnimation(
                                          Colors.white),
                                    ),
                                  ),
                                )
                              : Text(
                                  'Sign In',
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text.rich(
                        TextSpan(
                          children: [
                            WidgetSpan(
                              child: Icon(
                                Icons.check_box,
                                color: Colors.teal.shade900,
                                size: 16,
                              ),
                            ),
                            const TextSpan(
                              text: ' ',
                            ),
                            TextSpan(
                              text: 'By clicking you agree with\n',
                              style: GoogleFonts.lato(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                            TextSpan(
                              text: 'Term of Service & Privacy Policy',
                              style: GoogleFonts.lato(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: GoogleFonts.lato(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.toNamed('/novelSignUp');
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                      const EdgeInsets.all(2)),
                            ),
                            child: Text(
                              'Sign Up',
                              style: GoogleFonts.lato(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
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
