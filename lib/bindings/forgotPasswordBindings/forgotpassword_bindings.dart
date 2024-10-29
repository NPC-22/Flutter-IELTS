import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

import '../../controllers/forgotPasswordController/forgotPassword_controller.dart';
import '../../controllers/loginController/login_controller.dart';
import '../../controllers/onboardingController/onboarding_controller.dart';

class ForgotPasswordBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotPasswordController>(() => ForgotPasswordController());
  }
}