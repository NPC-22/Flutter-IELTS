import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import '../../controllers/forgotPasswordController/forgotPassword_controller.dart';
import '../../widgets/appButton.dart';
import 'package:onboarding_app/routes/app_pages.dart';

class ForgotPasswordScreen extends GetView<ForgotPasswordController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Obx(()=>
            Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 50,
                ),
                GestureDetector(
                  child: Icon( Icons.arrow_back_ios, color: Colors.black,  ),
                  onTap: () {
                    Get.back();
                  } ,
                ) ,
                const SizedBox(
                  height: 20,
                ),

                Text("Forgot Password",
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontSize: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.w700)),
                const SizedBox(
                  height: 5,
                ),
                Text(
                    "Please Enter the E-mail Address linked with your account.",
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge
                        ?.copyWith(
                        fontSize: 14,
                        color: Colors.black,
                        height: 1.7,
                        fontWeight: FontWeight.w400)),
                const SizedBox(
                  height: 40,
                ),
                TextField(
                  style: Theme.of(context)
                      .textTheme!
                      .headlineLarge!
                      .copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 14),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    controller.emailChange(value.obs);
                  },
                  decoration: InputDecoration(
                    hintText: "Email",
                    hintStyle: Theme.of(context)
                        .textTheme!
                        .headlineLarge!
                        .copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                        fontSize: 16),
                    labelStyle: Theme.of(context)
                        .textTheme!
                        .headlineLarge!
                        .copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 14),
                    fillColor: Color(0xFFF1F0F5),
                    filled: true,
                    isDense: false,

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
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1, color: Color(0xFFCECECF)),
                        borderRadius:
                        BorderRadius.all(Radius.circular(12))),
                    errorText: controller.showEmailError.value
                        ? controller.validateEmail(controller.email.value)
                        : null,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                controller.isLoading == true  ?
                Center(child: CircularProgressIndicator(),) : AppButton(
                  borderRadius: BorderRadius.circular(12),
                  buttontext: "Reset Password",
                  textcolor: Colors.white,
                  onTap: () {
                    controller.validateForm(context);
                  },
                  gradientcolor: const LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Color(0xFFe93e33), Color(0xFFff7e00)],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
