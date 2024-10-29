import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import '../../widgets/appButton.dart';
import 'package:onboarding_app/routes/app_pages.dart';

class ConfirmPasswordScreen extends GetView {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Text("Update Password",
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontSize: 22,
                          color: Colors.black,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(
                    height: 26,
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
                    height: 5,
                  ),
                  const TextField(
                   // obscureText: controller.obsecureText.value,
                    decoration: InputDecoration(
                        hintText: "Password",
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
                        // suffixIcon: InkWell(
                        //     onTap: () {
                        //       controller.obsecureText.value =
                        //       !controller.obsecureText.value;
                        //     },
                        //     child: Icon(controller.obsecureText.value
                        //         ? Icons.visibility
                        //         : Icons.visibility_off))
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Confirm Password",
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
                   // obscureText: controller.obsecureText.value,
                    decoration: InputDecoration(
                        hintText: "Confirm Password",
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
                        // suffixIcon: InkWell(
                        //     onTap: () {
                        //       controller.obsecureText.value =
                        //       !controller.obsecureText.value;
                        //     },
                        //     child: Icon(controller.obsecureText.value
                        //         ? Icons.visibility
                        //         : Icons.visibility_off))
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  AppButton(
                    borderRadius: BorderRadius.circular(12),
                    buttontext: "Update Password",
                    textcolor: Colors.white,
                    onTap: () {
                     // Get.toNamed(Routes.VERIFYPASSWORD);

                    },
                    gradientcolor: const LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Color(0xFFe93e33), Color(0xFFff7e00)],
                    ),
                  ),
                ]
            )
        )


    );
  }
}


