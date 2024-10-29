import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onboarding_app/routes/app_pages.dart';

import '../../controllers/loginController/login_controller.dart';
import '../../widgets/appButton.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({Key? key}) : super(key: key);

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
                            SizedBox(height: 70),
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
                            Text(
                                "Get access to your account entering your\n"
                                " login details below",
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
                              "Email",
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
                                    ? controller
                                        .validateEmail(controller.email.value)
                                    : null,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Password",
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
                              controller: controller.passwordController,
                              style: Theme.of(context)
                                  .textTheme!
                                  .headlineLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 14),
                              obscureText: controller.obscureText.value,
                              onChanged: (value) {
                                controller.passwordChange(value.obs);
                              },
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: "Password",
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
                                      color: Colors.grey,
                                    )),
                                errorText: controller.showPasswordError.value
                                    ? controller.validatePassword(
                                        controller.password.value)
                                    : null,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            InkWell(
                              onTap: () {
                                Get.toNamed(Routes.FORGOTPASSWORD);
                              },
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "Forgot password?",
                                  style: Theme.of(context)
                                      .textTheme!
                                      .headlineLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFe93e33),
                                          fontSize: 14),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 36,
                            ),

                            controller.isLoading.value == true
                                ? Center(child: CircularProgressIndicator())
                                : AppButton(
                                    borderRadius: BorderRadius.circular(12),
                              buttontext: "Login",
                                    textcolor: Colors.white,
                                    onTap: () {
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
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                            //   children: [
                            //     Container(
                            //       width: 98,
                            //       decoration: const ShapeDecoration(
                            //         shape: RoundedRectangleBorder(
                            //           side: BorderSide(
                            //             width: 1,
                            //             strokeAlign: BorderSide.strokeAlignCenter,
                            //             color: Color(0xFFDFDFE6),
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //     Text(
                            //       'Or Use',
                            //       textAlign: TextAlign.right,
                            //       style: Theme.of(context)
                            //           .textTheme!
                            //           .headline6!
                            //           .copyWith(
                            //               fontWeight: FontWeight.bold,
                            //               color: Colors.black,
                            //               fontSize: 14),
                            //     ),
                            //     Container(
                            //       width: 98,
                            //       decoration: const ShapeDecoration(
                            //         shape: RoundedRectangleBorder(
                            //           side: BorderSide(
                            //             width: 1,
                            //             strokeAlign: BorderSide.strokeAlignCenter,
                            //             color: Color(0xFFDFDFE6),
                            //           ),
                            //         ),
                            //       ),
                            //     )
                            //   ],
                            // ),
                            //  const  SizedBox(
                            //      height: 40,
                            //    ),
                            //    Row(
                            //      mainAxisAlignment: MainAxisAlignment.center,
                            //     children: [
                            //       InkWell(
                            //         onTap: (){},
                            //         child: Container(
                            //           padding: const EdgeInsets.all(16),
                            //           clipBehavior: Clip.antiAlias,
                            //           decoration: ShapeDecoration(
                            //             color: Color(0xFFE8EDF1),
                            //             shape: RoundedRectangleBorder(
                            //               borderRadius: BorderRadius.circular(25),
                            //             ),
                            //           ),
                            //           child: Container(
                            //             height: 18,
                            //               width: 18,
                            //               child: Image.asset("assets/images/Icon.png")),
                            //         ),
                            //       ),
                            //     const  SizedBox(
                            //         width: 20,
                            //       ),
                            //       InkWell(
                            //         onTap: (){},
                            //         child: Container(
                            //           padding: const EdgeInsets.all(16),
                            //           clipBehavior: Clip.antiAlias,
                            //           decoration: ShapeDecoration(
                            //             color: Color(0xFF1778F2),
                            //             shape: RoundedRectangleBorder(
                            //               borderRadius: BorderRadius.circular(25),
                            //             ),
                            //           ),
                            //           child: Container(
                            //               height: 18,
                            //               width: 18,
                            //               child: Image.asset("assets/images/facebook.png")),
                            //         ),
                            //       ),
                            //       const  SizedBox(
                            //         width: 20,
                            //       ),
                            //       InkWell(
                            //         onTap: (){},
                            //         child: Container(
                            //           padding: const EdgeInsets.all(16),
                            //           clipBehavior: Clip.antiAlias,
                            //           decoration: ShapeDecoration(
                            //             color: Colors.black,
                            //             shape: RoundedRectangleBorder(
                            //               borderRadius: BorderRadius.circular(25),
                            //             ),
                            //           ),
                            //           child: Container(
                            //               height: 18,
                            //               width: 18,
                            //               child: Image.asset("assets/images/apple.png")),
                            //         ),
                            //       ),

                            //     ],
                            //   )
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
                  text: 'Don’t have an account?',
                  style: Theme.of(context).textTheme!.headlineLarge!.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      fontSize: 14),
                  children: <TextSpan>[
                    TextSpan(
                      text: ' Sign Up',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.toNamed(Routes.SIGNUP);
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
}
