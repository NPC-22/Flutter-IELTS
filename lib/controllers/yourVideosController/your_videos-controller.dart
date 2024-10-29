import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:onboarding_app/network/models/HttpReposonceHandler.dart';
import 'package:onboarding_app/network/models/uservideos_model.dart';
import 'package:onboarding_app/network/repository/auth/auth_repo.dart';
import '../../routes/app_pages.dart';

class YourVideosController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  var isLoading = false.obs;
  UserRepo userRepo = UserRepo();
  final box = GetStorage();
  VideoListModel userVideos = VideoListModel();
  List<ListData>? videosList = [];

  @override
  void onInit() {
    getUserVideos();
    super.onInit();
  }

  Future<void> getUserVideos() async {
    try {
      isLoading.value = true;
      String? token = box.read("token");
      if (token == null) {
        // Token is null, navigate to login page
        Get.offAllNamed(Routes.LOGIN);
        return; // Exit the function early
      }
      HttpResponse httpResponse = await userRepo.videosList();
      if (httpResponse.statusCode == 200 || httpResponse.statusCode == 201) {
        isLoading.value = false;
        userVideos = VideoListModel.fromJson(httpResponse.data);
        update();
        videosList = userVideos.data!.data;
      }
      // Does not Display "Session Expired"!!
      // else if (httpResponse.statusCode == 401) {
      //   httpResponse.message = "Session Expired";
      //   box.remove("token");
      //   box.remove("login");
      //   Get.offAllNamed(Routes.LOGIN);
      // }
      else {
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Server issues, Check again later')));
      }
    } finally {
      isLoading.value = false;
    }
  }
}

/*
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:onboarding_app/network/models/HttpReposonceHandler.dart';
import '../../network/repository/auth/auth_repo.dart';
import 'package:onboarding_app/network/models/uservideos_model.dart';





class YourVideosController extends GetxController{
  final RxInt selectedIndex = 0.obs;


  var isLoading = false.obs;
  UserRepo userRepo = UserRepo();
  final box = GetStorage();
  VideoListModel userVideos = VideoListModel();
  List<ListData>? videosList = [];


  @override
  void onInit() {
    getUserVideos();
    super.onInit();
  }

  Future<HttpResponse> getUserVideos() async {
    isLoading.value = true;
    HttpResponse httpResponse = await userRepo.videosList();
    if (httpResponse.statusCode == 200 || httpResponse.statusCode == 201) {
      isLoading.value = false;
      userVideos = VideoListModel.fromJson(httpResponse.data);
      update();
      videosList = userVideos.data!.data;
    } else if (httpResponse.statusCode == 422) {
      
      if (httpResponse.data['error'] == "User credentials don't match") {
        // Handle the specific error condition
      }
    } else if (httpResponse.statusCode == 404) {
      // ScaffoldMessenger.of().showSnackBar(
      //   SnackBar(content: Text(httpResponse.message.toString())));
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Server issues, Check again later')));
    }
    isLoading.value = false;
    return httpResponse;
  }


//
// void changeItem(int index) {
//   selectedIndex.value = index;
//   update();
// }
//
// void goToSelectedScreen() {
//   switch (selectedIndex.value) {
//     case 0:
//       Get.offNamed(Routes.DASHBOARD);
//       break;
//     case 1:
//       Get.offNamed(Routes.PROGRESS);
//       break;
//     case 2:
//       Get.offNamed(Routes.ANALYSIS);
//       break;
//     case 3:
//     // Implement logout logic if needed
//       break;
//     default:
//       break;
//   }
//   update();
// }


}


 */

