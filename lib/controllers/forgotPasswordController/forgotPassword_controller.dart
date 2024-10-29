import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:onboarding_app/network/models/HttpReposonceHandler.dart';

import '../../network/repository/auth/auth_repo.dart';
import '../../routes/app_pages.dart';

class ForgotPasswordController extends GetxController {
  var isLoading = false.obs;
  final TextEditingController emailController = TextEditingController();
  RxString email = ''.obs;
  var showEmailError = false.obs;
  UserRepo userRepo = UserRepo();

  @override
  void onInit() {
    //   userRepo.login("saritharajashekat@yahoo.com", "fff");
    super.onInit();
  }

  String? validateEmail(String value) {
    final RegExp emailRegex =
    RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'); // Regex for email format

    if (value
        .trim()
        .isEmpty) {
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



  void validateForm(context) {
    final emailIsValid = validateEmail(email.value);
    if (emailIsValid == null) {
      forgotPassword(context);
    } else {
      if (emailIsValid != null) {
        showEmailError.value = true;
      }
      update();
    }
  }

  Future<HttpResponse> forgotPassword(context) async {
    isLoading.value = true;
    HttpResponse httpResponse =
    await userRepo!.forgotPassword(email.value);
    if(httpResponse.statusCode == 200 || httpResponse.statusCode == 201){
      isLoading.value = false;
      Get.dialog(
        AlertDialog(
          title: Text('Success', style: Theme.of(context)
              .textTheme!
              .headlineLarge!
              .copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 18),),
          content: Text(httpResponse.data['data']['message'],
            style: Theme.of(context)
                .textTheme!
                .headlineLarge!
                .copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // Close the dialog
                Get.offNamed(Routes.LOGIN);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );



    }
    else if(httpResponse.statusCode == 422)
    {
      if(httpResponse.data['error'] == "The selected email is invalid.") {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(httpResponse.data['error'])));
      }
    }
    else if(httpResponse.statusCode == 404){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(httpResponse.message.toString())));
    }
    else
    {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Server issues, Check again later')));
    }
    isLoading.value = false;
    return httpResponse;
  }



}