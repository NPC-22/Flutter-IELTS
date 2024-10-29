import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:onboarding_app/network/models/HttpReposonceHandler.dart';

import '../../network/repository/auth/auth_repo.dart';
import '../../routes/app_pages.dart';

class LoginController extends GetxController {
  RxBool obscureText = true.obs;
  var isLoading = false.obs;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  RxString email = ''.obs;
  RxString password = ''.obs;
  var showPasswordError = false.obs;
  var showEmailError = false.obs;
  UserRepo userRepo = UserRepo();
  final box = GetStorage();

  @override
  void onInit() {
    //   userRepo.login("saritharajashekat@yahoo.com", "fff");
    super.onInit();
  }

  // Validation method
  String? validatePassword(String value) {
    if (value == null || value.isEmpty) {
      update();
      return 'Password is required';
    } else if (value.length < 6) {
      update();
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  String? validateEmail(String value) {
    final RegExp emailRegex =
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'); // Regex for email format

    if (value.trim().isEmpty) {
      return 'Email is required';
    } else if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    update();

    return null; // Return null when the email is valid
  }

  void emailChange(RxString value) {
    email = value;
    showEmailError.value = false; // Reset error status when the value changes
    update();
  }

  void passwordChange(RxString value) {
    password = value;
    showPasswordError.value = false;
    update();
  }

  void validateForm(context) {
    final emailIsValid = validateEmail(email.value);
    final passwordIsValid = validatePassword(password.value);

    if (emailIsValid == null && passwordIsValid == null) {
      //Get.toNamed(Routes.SIGNUP);
      getLogin(context);
    } else {
      if (emailIsValid != null) {
        showEmailError.value = true;
      }
      if (passwordIsValid != null) {
        showPasswordError.value = true;
      }
      update();
    }
  }

  Future<HttpResponse> getLogin(context) async {
    isLoading.value = true;
    HttpResponse httpResponse = await userRepo!
        .login(email.value, password.value, "123", "android", "");
    if (httpResponse.statusCode == 200 || httpResponse.statusCode == 201) {
      isLoading.value = false;
      Get.offAllNamed(Routes.HOME);
      box.write("login", true);
      box.write('token', httpResponse.data['data']['token']);
      userRepo.userProfile();
    } else if (httpResponse.statusCode == 422) {
      if (httpResponse.data['error'] == "User credentials doesn't matched") {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(httpResponse.data['error'])));
      }
    } else if (httpResponse.statusCode == 404) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(httpResponse.message.toString())));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Server issues, Check again later')));
    }
    isLoading.value = false;
    return httpResponse;
  }
  void showSessionExpiredSnackBar() {
    Get.snackbar(
      "Session Expired...",
      "Session has expired. Please login again.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      margin: const EdgeInsets.all(20),
      duration: const Duration(seconds: 3),
    );
  }
}
