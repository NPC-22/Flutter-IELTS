import 'package:get/get.dart';
import 'package:onboarding_app/network/models/UserAgentModel.dart';
import 'package:onboarding_app/network/repository/auth/auth_repo.dart';

import '../../network/models/HttpReposonceHandler.dart';


class InterViewAttempt{
  late final String? id;
  late final String? question;
  InterViewAttempt({required this.id, required  this.question});
}

class GuideController extends GetxController{
  final RxInt idx = 0.obs;
  late int len = 0;
  String currentId = "1308b0cb-5921-420c-8bec-a3a26206c9b5";
  String currentQuestion = "Interview Question";
  late HttpResponse httpResponse;
  UserRepo userRepo = UserRepo();
  UserAgent userAgent = UserAgent();
  

  void changeListIndex() {
    idx.value = (idx.value+1)%len;
  }
  int changeListIndextoNext() {
    return idx.value = (idx.value+1)%len;
  }

  var isLoading = false.obs;
    List<InterViewAttempt> quesList = [];
    final UserRepo _userRepo = UserRepo();

    Future<HttpResponse> getInterviewQuestions() async {
      isLoading.value = true;
      HttpResponse httpResponse = await _userRepo.interviewQuestions();
      if (httpResponse.statusCode == 200 || httpResponse.statusCode == 201) {

        isLoading.value = false;
        List<dynamic> anon = httpResponse.data['data']['interviewattempt'] ?? [];

        for(var ele in anon){
          InterViewAttempt iva = InterViewAttempt(id: ele['id'], question: ele['interview_question']);
          quesList.add(iva);
          len++;
        }
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


  Future<HttpResponse> getUserAgent() async {
    isLoading.value = true;
    httpResponse = await userRepo.getUserAgent();
    if (httpResponse.statusCode == 200 || httpResponse.statusCode == 201) {
      isLoading.value = false;
      userAgent= UserAgent.fromJson(httpResponse.data);
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
  

}
// In your GuideController or relevant controller



