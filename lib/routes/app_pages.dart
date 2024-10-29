

abstract class Routes{
  Routes._();

  static const ONBOARDING = Paths.ONBOARDING;
  static const LOGIN = Paths.LOGIN;
  static const SIGNUP = Paths.SIGNUP;
  static const HOME = Paths.HOME;
  static const FORGOTPASSWORD = Paths.FORGOTPASSWORD;
  static const VERIFYPASSWORD = Paths.VERIFYPASSWORD;
  static const CONFIRMPASSWORD = Paths.CONFIRMPASSWORD;
  static const DASHBOARD = Paths.DASHBOARD;
  static const PROGRESS = Paths.PROGRESS;
  static const ANALYSIS = Paths.ANALYSIS;

}

abstract class Paths{
  static const ONBOARDING = '/onboarding';
  static const LOGIN = '/login';
  static const SIGNUP = '/signUp';
  static const FORGOTPASSWORD = '/forgotPassword';
  static const VERIFYPASSWORD = '/verifyPassword';
  static const CONFIRMPASSWORD = '/confirmPassword';
  static const HOME = '/home';
  static const DASHBOARD = '/dashboard';
  static const PROGRESS = '/progressReport';
  static const ANALYSIS = '/analysis';
}