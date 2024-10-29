import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../network/models/HttpReposonceHandler.dart';
import '../../network/models/PieChartModel.dart';
import '../../network/repository/auth/auth_repo.dart';

class PieChartDisplayController extends GetxController {
  var isLoading = false.obs;
  final box = GetStorage();
  UserRepo userRepo = UserRepo();
  late HttpResponse httpResponse;
  PieChartModel piechartScoresModel = PieChartModel();

  @override
  void onInit() {
    getVideosScoreInfo();
    super.onInit();
  }

  Future<HttpResponse> getVideosScoreInfo() async {
    isLoading.value = true;
    httpResponse = await userRepo.getVideosScore();
    if (httpResponse.statusCode == 200 || httpResponse.statusCode == 201) {
      isLoading.value = false;
      update();
      piechartScoresModel = PieChartModel.fromJson(httpResponse.data);

    } else if (httpResponse.statusCode == 422) {
      if (httpResponse.data['error'] == "User credentials don't match") {
        // Handle the specific error condition
      }
    } else if (httpResponse.statusCode == 404) {
      // ScaffoldMessenger.of().showSnackBar(
      //   SnackBar(content: Text(httpResponse.message.toString())));
    } else {
      //ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Server issues, Check again later')));
    }
    isLoading.value = false;
    return httpResponse;
  }
}
