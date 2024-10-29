import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:onboarding_app/network/models/HttpReposonceHandler.dart';

import '../../network/repository/auth/auth_repo.dart';
import '../../routes/app_pages.dart';

class DashBoardController extends GetxController {
  var isLoading = false.obs;
  UserRepo userRepo = UserRepo();
  final box = GetStorage();

  @override
  void onInit() {
    getUserProfile();
    super.onInit();
  }

  Future<HttpResponse> getUserProfile() async {
    isLoading.value = true;
    HttpResponse httpResponse = await userRepo!.userProfile();
    if (httpResponse.statusCode == 200 || httpResponse.statusCode == 201) {
      isLoading.value = false;
    } else if (httpResponse.statusCode == 422) {
      if (httpResponse.data['error'] == "User credentials doesn't matched") {}
    } else if (httpResponse.statusCode == 404) {
      // ScaffoldMessenger.of().showSnackBar(
      //   SnackBar(content: Text(httpResponse.message.toString())));
    } else if (httpResponse.statusCode == 401) {
      box.remove("token");
      box.remove("login");
      showSessionExpiredSnackBar();
      Get.offAllNamed(Routes.LOGIN);
    } else {
      //ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Server issues, Check again later')));
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
