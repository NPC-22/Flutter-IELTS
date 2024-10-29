import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onboarding_app/network/models/HttpReposonceHandler.dart';

import '../../network/repository/auth/auth_repo.dart';
import '../../routes/app_pages.dart';

class SignupController extends GetxController {
  RxBool obscureText = true.obs;
  var isLoading = false.obs;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController refernceCodeController = TextEditingController();
  RxString fullName = ''.obs;
  RxString dob = ''.obs;
  RxString email = ''.obs;
  RxString password = ''.obs;
  RxString cPassword = ''.obs;
  RxString refernceCode = ''.obs;
  var showNameError = false.obs;
  var showDobError = false.obs;
  var showEmailError = false.obs;
  var showPasswordError = false.obs;
  var showConfirmPasswordError = false.obs;
  var showReferenceCodeError = false.obs;
  UserRepo userRepo = UserRepo();
  var acceptedTerms = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  String? validateName(String value) {
    if (value == null || value.isEmpty) {
      update();
      return 'Full Name is required';
    }
    return null;
  }

  String? validateDOB(String value) {
    if (value.isEmpty || value == null) {
      update();
      return 'DOB is required';
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

  String? validateConfirmPassword(String value) {
    if (value == null || value.isEmpty) {
      update();
      return 'Confirm Password is required';
    } else if (value.length < 6) {
      update();
      return 'Confirm Password must be at least 6 characters';
    } else if (value != password.value) {
      return 'Confirm Password is not match with Password';
    }
    return null;
  }

  String? validateReferenceCode(String value) {
    if (value == null || value.isEmpty) {
      update();
      return 'Reference code is required';
    }
    return null;
  }

  void nameChange(RxString value) {
    fullName = value;
    showNameError.value = false; // Reset error status when the value changes
    update();
  }

  void dobChange(RxString value) {
    dob = value;
    showDobError.value = false; // Reset error status when the value changes
    update();
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

  void cPasswordChange(RxString value) {
    cPassword = value;
    showConfirmPasswordError.value = false;
    update();
  }

  void refernceCodeChange(RxString value) {
    refernceCode = value;
    showReferenceCodeError.value = false;
    update();
  }

  void validateForm(context) {
    final nameIsValid = validateName(fullName.value);
    final dobIsValid = validateDOB(dob.value);
    final emailIsValid = validateEmail(email.value);
    final passwordIsValid = validatePassword(password.value);
    final cpasswordIsValid = validateConfirmPassword(cPassword.value);
    final isRefernceCodeValid = validateReferenceCode(refernceCode.value);

    if (emailIsValid == null &&
        passwordIsValid == null &&
        nameIsValid == null &&
        cpasswordIsValid == null &&
        dobIsValid == null &&
        acceptedTerms.value == true) {
      signupUser(context);
    } else {
      if (nameIsValid != null) {
        showNameError.value = true;
      }
      if (dobIsValid != null) {
        showDobError.value = true;
      }
      if (emailIsValid != null) {
        showEmailError.value = true;
      }

      if (passwordIsValid != null) {
        showPasswordError.value = true;
      }
      if (cpasswordIsValid != null) {
        showConfirmPasswordError.value = true;
      }
      if (isRefernceCodeValid != null) {
        showReferenceCodeError.value = true;
      }
      if (acceptedTerms.value == false) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Please agree terms and conditions")));
      }
      update();
    }
  }

  Future<HttpResponse> signupUser(context) async {
    isLoading.value = true;
    HttpResponse httpResponse = await userRepo!.signup(
        fullName.value,
        email.value,
        password.value,
        dob.value,
        "123",
        "android",
        refernceCode.value);
    if (httpResponse.statusCode == 200 || httpResponse.statusCode == 201) {
      isLoading.value = false;
      AwesomeDialog(
        context: context,
        animType: AnimType.scale,
        dialogType: DialogType.success,
        body: Center(
          child: Text(
            'Created Successfully',
            style: Theme.of(context).textTheme!.headlineLarge!.copyWith(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14),
          ),
        ),
        title: 'This is Ignored',
        desc: 'This is also Ignored',
        btnOkOnPress: () {
          Get.offNamed(Routes.LOGIN);
        },
      ).show();
      //archir Get.offNamed(Routes.LOGIN);
    } else if (httpResponse.statusCode == 422) {
      if (httpResponse.data['error'] == "The email has already been taken.") {
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
}
