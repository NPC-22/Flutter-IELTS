import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onboarding_app/routes/app_pages.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/signupController/signup_controller.dart';
import '../../widgets/appButton.dart';

class SignUpScreen extends GetView<SignupController> {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
                    child: Obx(
                      () => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 70),
                            // const Icon(
                            //   Icons.keyboard_backspace_rounded,
                            //   size: 30,
                            // ),
                            Image.asset(
                              "assets/images/cuvasol.png",
                              width: 120,
                            ),
                            Text("Welcome Back! 👋",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge
                                    ?.copyWith(
                                        fontSize: 22,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700)),
                            Text("Sign up to your account",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge
                                    ?.copyWith(
                                        fontSize: 14,
                                        color: Colors.black,
                                        height: 1.7,
                                        fontWeight: FontWeight.w400)),
                            const SizedBox(
                              height: 30,
                            ),
                            Text(
                              "Full Name*",
                              style: Theme.of(context)
                                  .textTheme!
                                  .headlineLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 14),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TextField(
                              style: Theme.of(context)
                                  .textTheme!
                                  .headlineLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 14),
                              controller: controller.nameController,
                              onChanged: (value) {
                                controller.nameChange(value.obs);
                              },
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: "Full Name",
                                hintStyle: Theme.of(context)
                                    .textTheme!
                                    .headlineLarge!
                                    .copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey,
                                        fontSize: 14),
                                labelStyle: Theme.of(context)
                                    .textTheme!
                                    .headlineLarge!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 14),
                                fillColor: Color(0xFFF1F0F5),
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                  borderSide: BorderSide(
                                      width: 1, color: Color(0xFFCECECF)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                  borderSide: BorderSide(
                                      width: 1, color: Color(0xFFff7e00)),
                                ),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Color(0xFFCECECF)),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                errorText: controller.showNameError.value
                                    ? controller
                                        .validateName(controller.fullName.value)
                                    : null,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Date of Birth*",
                              style: Theme.of(context)
                                  .textTheme!
                                  .headlineLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 14),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TextField(
                              style: Theme.of(context)
                                  .textTheme!
                                  .headlineLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 14),
                              controller: controller.dobController,
                              onChanged: (value) {
                                controller.dobChange(value.obs);
                              },
                              keyboardType: TextInputType.emailAddress,
                              readOnly: true,
                              decoration: InputDecoration(
                                hintText: "Date of Birth",
                                hintStyle: Theme.of(context)
                                    .textTheme!
                                    .headlineLarge!
                                    .copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey,
                                        fontSize: 14),
                                labelStyle: Theme.of(context)
                                    .textTheme!
                                    .headlineLarge!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 14),
                                fillColor: Color(0xFFF1F0F5),
                                filled: true,
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: SizedBox(
                                    width: 45.0,
                                    height: 45.0,
                                    child: IconButton(
                                      padding: EdgeInsets.all(10),
                                      onPressed: () {
                                        openCalender(context);
                                      },
                                      icon: Image.asset(
                                          "assets/images/Vector.png"),
                                      //iconSize: 16,
                                    ),
                                  ),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                  borderSide: BorderSide(
                                      width: 1, color: Color(0xFFCECECF)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                  borderSide: BorderSide(
                                      width: 1, color: Color(0xFFff7e00)),
                                ),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Color(0xFFCECECF)),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                errorText: controller.showDobError.value
                                    ? controller
                                        .validateDOB(controller.dob.value)
                                    : null,
                              ),
                              onTap: () {
                                openCalender(context);
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Email*",
                              style: Theme.of(context)
                                  .textTheme!
                                  .headlineLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 14),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TextField(
                              style: Theme.of(context)
                                  .textTheme!
                                  .headlineLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 14),
                              controller: controller.emailController,
                              onChanged: (value) {
                                controller.emailChange(value.obs);
                              },
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: "Email",
                                hintStyle: Theme.of(context)
                                    .textTheme!
                                    .headlineLarge!
                                    .copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey,
                                        fontSize: 14),
                                labelStyle: Theme.of(context)
                                    .textTheme!
                                    .headlineLarge!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 14),
                                fillColor: Color(0xFFF1F0F5),
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                  borderSide: BorderSide(
                                      width: 1, color: Color(0xFFCECECF)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                  borderSide: BorderSide(
                                      width: 1, color: Color(0xFFff7e00)),
                                ),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Color(0xFFCECECF)),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                errorText: controller.showEmailError.value
                                    ? controller
                                        .validateEmail(controller.email.value)
                                    : null,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Password*",
                              style: Theme.of(context)
                                  .textTheme!
                                  .headlineLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 14),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TextField(
                              style: Theme.of(context)
                                  .textTheme!
                                  .headlineLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 14),
                              controller: controller.passwordController,
                              onChanged: (value) {
                                controller.passwordChange(value.obs);
                              },
                              keyboardType: TextInputType.emailAddress,
                              obscureText: controller.obscureText.value,
                              decoration: InputDecoration(
                                hintText: "Password",
                                hintStyle: Theme.of(context)
                                    .textTheme!
                                    .headlineLarge!
                                    .copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey,
                                        fontSize: 14),
                                labelStyle: Theme.of(context)
                                    .textTheme!
                                    .headlineLarge!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 14),
                                fillColor: Color(0xFFF1F0F5),
                                filled: true,
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                  borderSide: BorderSide(
                                      width: 1, color: Color(0xFFCECECF)),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                  borderSide: BorderSide(
                                      width: 1, color: Color(0xFFff7e00)),
                                ),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Color(0xFFCECECF)),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                suffixIcon: InkWell(
                                    onTap: () {
                                      controller.obscureText.value =
                                          !controller.obscureText.value;
                                    },
                                    child: Icon(
                                      controller.obscureText.value
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: controller.obscureText.value
                                          ? Colors.grey
                                          : Color(0xFFe93e33),
                                    )),
                                errorText: controller.showPasswordError.value
                                    ? controller.validatePassword(
                                        controller.password.value)
                                    : null,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Confirm Password*",
                              style: Theme.of(context)
                                  .textTheme!
                                  .headlineLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 14),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TextField(
                              style: Theme.of(context)
                                  .textTheme!
                                  .headlineLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 14),
                              controller: controller.confirmPasswordController,
                              onChanged: (value) {
                                controller.cPasswordChange(value.obs);
                              },
                              keyboardType: TextInputType.emailAddress,
                              obscureText: controller.obscureText.value,
                              decoration: InputDecoration(
                                hintText: "Confirm Password",
                                hintStyle: Theme.of(context)
                                    .textTheme!
                                    .headlineLarge!
                                    .copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey,
                                        fontSize: 14),
                                labelStyle: Theme.of(context)
                                    .textTheme!
                                    .headlineLarge!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 14),
                                fillColor: Color(0xFFF1F0F5),
                                filled: true,
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                  borderSide: BorderSide(
                                      width: 1, color: Color(0xFFCECECF)),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                  borderSide: BorderSide(
                                      width: 1, color: Color(0xFFff7e00)),
                                ),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Color(0xFFCECECF)),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                suffixIcon: InkWell(
                                    onTap: () {
                                      controller.obscureText.value =
                                          !controller.obscureText.value;
                                    },
                                    child: Icon(
                                      controller.obscureText.value
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: controller.obscureText.value
                                          ? Colors.grey
                                          : Color(0xFFe93e33),
                                    )),
                                errorText:
                                    controller.showConfirmPasswordError.value
                                        ? controller.validateConfirmPassword(
                                            controller.cPassword.value)
                                        : null,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),

                            Text(
                              "Reference Code",
                              style: Theme.of(context)
                                  .textTheme!
                                  .headlineLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 14),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextField(
                              style: Theme.of(context)
                                  .textTheme!
                                  .headlineLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 14),
                              controller: controller.refernceCodeController,
                              onChanged: (value) {
                                controller.refernceCodeChange(value.obs);
                              },
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: "Reference Code",
                                hintStyle: Theme.of(context)
                                    .textTheme!
                                    .headlineLarge!
                                    .copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey,
                                        fontSize: 14),
                                labelStyle: Theme.of(context)
                                    .textTheme!
                                    .headlineLarge!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 14),
                                fillColor: Color(0xFFF1F0F5),
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                  borderSide: BorderSide(
                                      width: 1, color: Color(0xFFCECECF)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                  borderSide: BorderSide(
                                      width: 1, color: Color(0xFFff7e00)),
                                ),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Color(0xFFCECECF)),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                /*errorText:
                                    controller.showReferenceCodeError.value
                                        ? controller.validateReferenceCode(
                                            controller.refernceCode.value)
                                        : null,*/
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Checkbox(
                                  activeColor: Color(0xFFe93e33),
                                  checkColor: Colors.white,
                                  value: controller.acceptedTerms.value,
                                  onChanged: (bool? value) {
                                    controller.acceptedTerms.value =
                                        !controller.acceptedTerms.value;
                                  },
                                ),
                                Text(
                                  'I have accepted the ',
                                  style: Theme.of(context)
                                      .textTheme!
                                      .headlineLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 14),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    launch(
                                        'https://www.cuvasol.com/termsandconditions.php');
                                  },
                                  child: Text(
                                    'Terms and Conditions',
                                    style: Theme.of(context)
                                        .textTheme!
                                        .headlineLarge!
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFe93e33),
                                            decoration:
                                                TextDecoration.underline,
                                            fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            controller.isLoading == true
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : AppButton(
                                    borderRadius: BorderRadius.circular(12),
                                    buttontext: "Sign up",
                                    textcolor: Colors.white,
                                    onTap: () {
                                      //print("cfcv");
                                      controller.validateForm(context);
                                    },
                                    gradientcolor: const LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Color(0xFFe93e33),
                                        Color(0xFFff7e00)
                                      ],
                                    ),
                                  ),
                            const SizedBox(
                              height: 36,
                            ),
                          ]),
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              // Add vertical padding
              child: RichText(
                textScaleFactor: 1,
                text: TextSpan(
                  text: 'Do you have an account?',
                  style: Theme.of(context).textTheme!.headlineLarge!.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      fontSize: 14),
                  children: <TextSpan>[
                    TextSpan(
                      text: ' LOGIN',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.toNamed(Routes.LOGIN);
                        },
                      style: Theme.of(context)
                          .textTheme!
                          .headlineLarge!
                          .copyWith(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFe93e33),
                              fontSize: 14),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }

  Future<void> openCalender(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime(2004),
        firstDate: DateTime(1910),
        //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2008));

    if (pickedDate != null) {
      print(pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000

      controller.dobController.text = pickedDate.toString().substring(0, 10);
      controller.dob.value = pickedDate.toString().substring(0, 10);
    } else {
      print("Date is not selected");
    }
  }
}
