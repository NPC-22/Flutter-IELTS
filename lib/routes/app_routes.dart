import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:get_storage/get_storage.dart';
import 'package:onboarding_app/bindings/onboarding/onboarding_binding.dart';
import 'package:onboarding_app/presentation/signup/signup_screen.dart';

import '../animations/storage_service.dart';
import '../bindings/DashboardBindings/dashboard_bindings.dart';
import '../bindings/Login/login_bindings.dart';
import '../bindings/Signup/signup_bindings.dart';
import '../bindings/analysis_bindings/analysis_bindings.dart';
import '../bindings/forgotPasswordBindings/forgotpassword_bindings.dart';
import '../bindings/progressBindings/progress_bindings.dart';
import '../middleware/first_middleware.dart';
import '../presentation/dashboard/dashboard_screen.dart';
import '../presentation/deepAnalysis/deep_analysis_screen.dart';
import '../presentation/drawer_screen.dart';
import '../presentation/forgotPassword/forgotPassword_screen.dart';
//import '../presentation/progressReport/progressReport_screen.dart';
import '../presentation/verifyPassword/verifyPassword_screen.dart';
import '../presentation/confirmPassword/confirmPassword_screen.dart';
import '../presentation/login/login_screen.dart';
import '../presentation/onboarding/onboarding_screen.dart';
import 'app_pages.dart';

class AppPages {
  AppPages._();
  static Future<String> get initialRoute async {
    final isLogedIn = Get.find<GetStorage>().read("login");
    if (isLogedIn != null) {
      if (isLogedIn == true) {
        return Paths.HOME;
        // old code
        // var credentials = Get.find<GetStorage>().read("credentials");
        // if (credentials != null) {
        //   final user = await Get.find<AuthController>().login(
        //     credentials['email'],
        //     credentials['password'],
        //       credentials['channel'] ?? ""
        //   );
        //   if (user != null) {
        //     if (user.profile != null) {
        //       return homeScreen;
        //     }
        //   }
        // }
      }
    }
    else
      {
        return Paths.ONBOARDING;
      }
    final isFirstTime = Get.find<GetStorage>().read<bool>("isFirstTime");
    print("isFirstTime$isFirstTime");
    if (isFirstTime != null) {
      if (isFirstTime == true) {
        return Paths.LOGIN;
      }
    }
    return Paths.ONBOARDING;
  }

  static const INITIAL = Paths.ONBOARDING;
  static List<GetPage> routes = [
    GetPage(
        name: Paths.ONBOARDING,
        page: () => OnBoardingScreen(),
        transition: Transition.fadeIn,
        binding: OnBoardingBindings()),
    GetPage(
      name: Paths.LOGIN,

      page: () => LoginScreen(),
      transition: Transition.fadeIn,
      binding: LoginBindings(),
    ),
    GetPage(
      name: Paths.SIGNUP,
      page: () => SignUpScreen(),
      transition: Transition.fadeIn,
      binding: SignupBindings(),
    ),
    GetPage(
      name: Paths.FORGOTPASSWORD,
      page: () => ForgotPasswordScreen(),
      transition: Transition.fadeIn,
      binding: ForgotPasswordBindings(),
    ),
    GetPage(
      name: Paths.VERIFYPASSWORD,
      page: () => VerifyPasswordScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Paths.CONFIRMPASSWORD,
      page: () => ConfirmPasswordScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Paths.DASHBOARD,
      page: () => DashboardScreen(),
      transition: Transition.fadeIn,
      binding: DashboardBindings(),
    ),
    /*
    GetPage(
      name: Paths.PROGRESS,
      page: () => ProgressReportScreen(),
      transition: Transition.fadeIn,
      binding: ProgressBindings(),
    ),

     */
    GetPage(
      name: Paths.ANALYSIS,
      page: () => DeepAnalysisScreen(),
      transition: Transition.fadeIn,
      binding: AnalysisBindings(),
    ),

    GetPage(
      name: Paths.HOME,
      page: () => DrawerScreen(),
      transition: Transition.fadeIn,
     // binding: AnalysisBindings(),
    ),
  ];
}
