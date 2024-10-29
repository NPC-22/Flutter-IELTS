import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

import '../../controllers/DashboardController/dashboard_controller.dart';
import '../../controllers/drawer_navigation-controller.dart';
import '../../controllers/onboardingController/onboarding_controller.dart';

class AnalysisBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashBoardController>(() => DashBoardController());
    Get.lazyPut<DrawerNavigationController>(() => DrawerNavigationController());

  }
}