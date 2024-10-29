import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onboarding_app/appTheme/app_theme.dart';

import 'package:onboarding_app/routes/app_routes.dart';

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp(this.initialRoute, {super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.buildLightTheme(),
      darkTheme: AppTheme.buildDarkTheme(),
      themeMode: ThemeMode.light,
      defaultTransition: Transition.fade,
      initialRoute: initialRoute,
      getPages: AppPages.routes,
    );
  }
}
