import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'routes/app_route.dart';

void main() {
  runApp(const DishCraftApp());
}

class DishCraftApp extends StatelessWidget {
  const DishCraftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DishCraft',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal.shade900),
        useMaterial3: true,
      ),
      initialRoute: '/splashScreen',
      getPages: AppRoute.routes,
    );
  }
}
