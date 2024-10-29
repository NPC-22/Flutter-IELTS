import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import '../../widgets/appButton.dart';
import 'package:onboarding_app/routes/app_pages.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class VerifyPasswordScreen extends GetView {
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

              GestureDetector(
                child: Icon( Icons.arrow_back_ios, color: Colors.black,  ),
                onTap: () {
                  Get.back();
                } ,
              ) ,
              const SizedBox(
                height: 20,
              ),
              Text("OTP Verification",
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.w700)),
              const SizedBox(
                height: 5,
              ),
              Text(
                  "Enter the verification code we just \nsent on your email address.",
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
              OtpTextField(
                obscureText: true,
                cursorColor: Colors.black26,
                textStyle: const TextStyle(
                  color:Colors.black
                ),
                fieldWidth: 50,
                numberOfFields: 6,
                borderWidth: 1,
                borderRadius: BorderRadius.circular(8),
                fillColor: Color(0xFFF1F0F5),
                filled:true,
               enabledBorderColor: Color(0xFFF1F0F5),
                borderColor:Color(0xFFF1F0F5),
                focusedBorderColor: Color(0xFFff7e00),
                //set to true to show as box or false to show as dash
                showFieldAsBox: true,
                //runs when a code is typed in
                onCodeChanged: (String code) {
                  //handle validation or checks here
                },

              ),
              const SizedBox(
                height: 40,
              ),
            AppButton(
              borderRadius: BorderRadius.circular(12),
              buttontext: "Verify Account",
              textcolor: Colors.white,
              onTap: () {
                Get.toNamed(Routes.CONFIRMPASSWORD);

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


