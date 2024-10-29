import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onboarding_app/controllers/onboardingController/onboarding_controller.dart';
import 'package:onboarding_app/core/constants/colors_constant.dart';
import 'package:onboarding_app/routes/app_routes.dart';

import '../../animations/custom_slideopacity_animation.dart';
import '../../animations/storage_service.dart';
import '../../core/utils/SliderDots.dart';
import '../../routes/app_pages.dart';
import '../../widgets/appButton.dart';

class OnBoardingScreen extends GetView<OnBoardingController> {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      body: SafeArea(
          child: Obx(
        () => Column(
          children: [
            Expanded(
                flex: 3,
                child: PageView.builder(
                    controller: controller.pageController,
                    physics: const BouncingScrollPhysics(),
                    itemCount: controller.contents.length,
                    onPageChanged: controller.changePageIndex,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(top: 50, left: 40, right: 40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SlideFadeTransition(
                              child: Image.asset(
                                controller.contents[index].image,
                                height: Get.height * .4,
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            SlideFadeTransition(
                              child: Text(
                                controller.contents[index].title,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.workSans(
                                    textStyle: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black)),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            SlideFadeTransition(
                              child: Text(
                                controller.contents[index].desc,
                                style: GoogleFonts.workSans(
                                    textStyle: const TextStyle(
                                        fontSize: 12,
                                        height: 1.6,
                                        letterSpacing: 0.3,
                                        wordSpacing: 0.7,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black)),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                          ],
                        ),
                      );
                    })),
            Expanded(
              flex: 0,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 30, left: 16, right: 16, bottom: 16),
                    child: controller.selectedPageIndex.value + 1 ==
                            controller.contents.length
                        ?
                    AppButton(
                      width: double.infinity,
                      borderRadius: BorderRadius.circular(12),
                      buttontext: "Get Started",
                      textcolor: Colors.white,
                      onTap: () {
                        Get.find<GetStorage>().write("isFirstTime" , true);
                        //print("cnddffd");
                       Get.toNamed(Routes.LOGIN);

                      },
                      gradientcolor: const LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Color(0xFFe93e33), Color(0xFFff7e00)],
                      ),
                    )

              // ElevatedButton(
              //               onPressed: () {
              //                 Get.toNamed(Routes.LOGIN);
              //               },
              //               child: Text(
              //                 "Get Started",
              //                 style: GoogleFonts.workSans(
              //                     textStyle: const TextStyle(
              //                   fontSize: 16,
              //                   fontWeight: FontWeight.w500,
              //                 )),
              //               ),
              //               style: ElevatedButton.styleFrom(
              //                 shadowColor: Color(0xFF000000),
              //                 backgroundColor: Color(0xFF03B7B5),
              //                 shape: RoundedRectangleBorder(
              //                   borderRadius: BorderRadius.circular(50),
              //                 ),
              //                 elevation: 10, // Elevation
              //                 padding: (Get.width <= 550)
              //                     ? const EdgeInsets.symmetric(
              //                         horizontal: 60, vertical: 18)
              //                     : const EdgeInsets.symmetric(
              //                         horizontal: 70, vertical: 20),
              //                 textStyle: GoogleFonts.workSans(
              //                     textStyle: const TextStyle(
              //                   fontSize: 16,
              //                   fontWeight: FontWeight.w500,
              //                 )),
              //               ),
              //             )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Get.find<GetStorage>().write("isFirstTime" , true);
                                  Get.toNamed(Routes.LOGIN);
                                 // controller.pageController!.jumpToPage(2);
                                },
                                style: TextButton.styleFrom(
                                  elevation: 0,
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: (Get.width <= 550) ? 13 : 17,
                                  ),
                                ),
                                child: Text(
                                  "Skip",
                                  style: GoogleFonts.workSans(
                                      textStyle: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black)),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  for (int i = 0;
                                      i < controller.contents.length;
                                      i++)
                                    if (i == controller.selectedPageIndex.value)
                                      SlideDots(true)
                                    else
                                      SlideDots(false)
                                ],
                              ),
                              AppButton(
                                width: 100,
                                borderRadius: BorderRadius.circular(12),
                                buttontext: "Next",
                                textcolor: Colors.white,
                                onTap: () {
                                  controller.pageController!.nextPage(
                                            duration: const Duration(milliseconds: 200),
                                            curve: Curves.easeIn,
                                          );
                                },
                                gradientcolor: const LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [Color(0xFFe93e33), Color(0xFFff7e00)],
                                ),
                              ),
                              // ElevatedButton(
                              //   onPressed: () {
                              //     controller.pageController!.nextPage(
                              //       duration: const Duration(milliseconds: 200),
                              //       curve: Curves.easeIn,
                              //     );
                              //   },
                              //   child: const Text("NEXT"),
                              //   style: ElevatedButton.styleFrom(
                              //     backgroundColor: Color(0xFF03B7B5),
                              //     shadowColor: Color(0xFF000000),
                              //     shape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.circular(50),
                              //     ),
                              //     elevation: 10,
                              //     padding: (Get.width <= 550)
                              //         ? const EdgeInsets.symmetric(
                              //             horizontal: 40, vertical: 15)
                              //         : const EdgeInsets.symmetric(
                              //             horizontal: 50, vertical: 18),
                              //     textStyle: GoogleFonts.workSans(
                              //         textStyle: const TextStyle(
                              //       fontSize: 16,
                              //       fontWeight: FontWeight.w500,
                              //     )),
                              //   ),
                              // ),
                            ],
                          ),
                  )
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
