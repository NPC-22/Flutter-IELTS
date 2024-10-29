import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../presentation/onboarding/onBoardingContent_model.dart';

class OnBoardingController extends GetxController{
  PageController?  pageController;

  List<OnBoardingContents> contents = [];
  RxInt selectedPageIndex = 0.obs;
  RxBool isAnimated = false.obs;


  @override
  void onInit() {
    contents = [
      OnBoardingContents(
          title: "AI powered Interview platform",
          image: "assets/images/demo0.jpg",
          desc: ''
      ),
      OnBoardingContents(
          title: "Take virtual interview",
          image: "assets/images/demo1.jpg",
          desc: ' '
      ),

      OnBoardingContents(
          title: "Submit your videos",
          image: "assets/images/demo2.jpg",
          desc: ''
      ),

      OnBoardingContents(
          title: "Get response with AI",
          image: "assets/images/demo4.jpg",
          desc: ' '
      ),
      OnBoardingContents(
          title: "Cuvasol helps in your success",
          image: "assets/images/demo5.jpg",
          desc: ' '
      ),
    ];

    pageController = PageController();
    isAnimated.value = false;
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    pageController!.dispose();
    super.onClose();


  }
  changePageIndex(int index) {
    selectedPageIndex.value = index;

    pageController!.animateToPage(
      index,
      duration: const Duration(milliseconds: 300), // Adjust the duration as needed
      curve: Curves.easeIn, // Choose the animation curve
    );

  }

}