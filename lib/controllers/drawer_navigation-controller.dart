import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:onboarding_app/network/models/HttpReposonceHandler.dart';

import '../../network/repository/auth/auth_repo.dart';
import '../network/models/userprofile_model.dart';

class DrawerNavigationController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  var isLoading = false.obs;
  UserRepo userRepo = UserRepo();
  final box = GetStorage();
  UserProfile userProfile = UserProfile();

  @override
  void onInit() {
    getUserProfile();
    super.onInit();
  }

  Future<HttpResponse> getUserProfile() async {
    isLoading.value = true;

    HttpResponse httpResponse = await userRepo.userProfile();
    print("http status code");
    print(httpResponse.statusCode);
    print(httpResponse.message);
    if (httpResponse.statusCode == 200 || httpResponse.statusCode == 201) {
      isLoading.value = false;
      userProfile = UserProfile.fromJson(httpResponse.data);
      update();
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
