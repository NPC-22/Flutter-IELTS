import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:onboarding_app/network/client/dioApi_client.dart';
import 'package:onboarding_app/network/models/HttpReposonceHandler.dart';

import '../../../routes/app_pages.dart';
import '../../apiClient/base_url.dart';
import '../../apiClient/endPoints.dart' as endPoints;

class UserRepo {
  DioClient? httpClient;
  bool isSnackBarShown = false;

  void showSessionExpiredSnackBar() {
    if (!isSnackBarShown) {
      Get.snackbar(
        "Session Expired...",
        "Session has expired. Please login again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black87,
        colorText: Colors.white,
        margin: const EdgeInsets.all(20),
        duration: const Duration(seconds: 3),
      );
      isSnackBarShown = true;
    }
  }

  void closeDialogBox() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }

  UserRepo() {
    httpClient = DioClient();
  }

  Future<HttpResponse> login(String email, String password, String deviceToken,
      String deviceType, String referenceCode) async {
    HttpResponse httpResponse = HttpResponse();
    GetStorage box = GetStorage();
    // httpClient!.client!.options =
    //     BaseOptions(contentType: Headers.formUrlEncodedContentType);
    await httpClient!.post(
        BaseUrl().baseUrl + endPoints.User().login, box.read("token"),
        body: {
          "email": email,
          "password": password,
          "device_token": deviceToken,
          "device_type": deviceType,
          "reference_code": referenceCode,
        }).then((responce) async {
      if (responce.statusCode == 200 || responce.statusCode == 201) {
        httpResponse.statusCode = responce.statusCode;
        httpResponse.data = responce.data;
        httpResponse.message = responce.data['data']['message'];
      } else if (responce.statusCode == 401) {
        httpResponse.statusCode = responce.statusCode;
        httpResponse.data = responce.data;
        httpResponse.message = responce.data['data']['message'];
        box.remove("token");
        box.remove("login");

        showSessionExpiredSnackBar();
        Get.offAllNamed(Routes.LOGIN);
      } else if (responce.statusCode == 422) {
        httpResponse.statusCode = responce.statusCode;
        httpResponse.message = responce.data['error'];
        httpResponse.data = httpResponse.data = responce.data;
      }
      return httpResponse;
    }).catchError((err) {
      httpResponse.statusCode = 400;
      httpResponse.message = err.toString();
      httpResponse.data = err.toString();
      return httpResponse;
    });
    return httpResponse;
  }

  Future<HttpResponse> signup(
      String name,
      String email,
      String password,
      String dob,
      String deviceToken,
      String deviceType,
      String referenceCode) async {
    HttpResponse httpResponse = HttpResponse();
    GetStorage box = GetStorage();
    // httpClient!.client!.options =
    //     BaseOptions(contentType: Headers.formUrlEncodedContentType);
    await httpClient!.post(
        BaseUrl().baseUrl + endPoints.User().signupUser, box.read("token"),
        body: {
          "name": name,
          "email": email,
          "password": password,
          "dob": dob,
          "device_token": deviceToken,
          "device_type": deviceType,
          "reference_code": referenceCode,
        }).then((responce) async {
      if (responce.statusCode == 201 || responce.statusCode == 200) {
        httpResponse.statusCode = responce.statusCode;
        httpResponse.message = responce.data['data']['message'];
        httpResponse.data = responce.data['data'];
      } else if (responce.statusCode == 422) {
        httpResponse.statusCode = responce.statusCode;
        httpResponse.message = responce.data['error'];
        httpResponse.data = responce.data;
      }
      // else if (httpResponse.statusCode == 401) {
      //   box.remove("token");
      //   box.remove("login");
      //   Get.offAllNamed(Routes.LOGIN);
      // }
      else if (responce.statusCode == 404) {
        httpResponse.statusCode = responce.statusCode;
        httpResponse.message = "Something went wrong";
        httpResponse.data = null;
      }

      return httpResponse;
    }).catchError((err) {
      httpResponse.statusCode = 404;
      httpResponse.message = err.toString();
      httpResponse.data = err.toString();
      return httpResponse;
    });
    return httpResponse;
  }

  Future<HttpResponse> forgotPassword(String email) async {
    HttpResponse httpResponse = HttpResponse();
    GetStorage box = GetStorage();
    // httpClient!.client!.options =
    //     BaseOptions(contentType: Headers.formUrlEncodedContentType);
    await httpClient!.post(
        BaseUrl().baseUrl + endPoints.User().resetPassword, box.read("token"),
        body: {
          "email": email,
        }).then((responce) async {
      if (responce.statusCode == 200 || responce.statusCode == 201) {
        httpResponse.statusCode = responce.statusCode;
        httpResponse.data = responce.data;
        httpResponse.message = responce.data['data']['message'];
      } else if (responce.statusCode == 401) {
        httpResponse.statusCode = responce.statusCode;
        httpResponse.data = responce.data;
        httpResponse.message = responce.data['data']['message'];
        box.remove("token");
        box.remove("login");

        showSessionExpiredSnackBar();
        Get.offAllNamed(Routes.LOGIN);
      } else if (responce.statusCode == 422) {
        httpResponse.statusCode = responce.statusCode;
        httpResponse.message = responce.data['error'];
        httpResponse.data = httpResponse.data = responce.data;
      }
      return httpResponse;
    }).catchError((err) {
      httpResponse.statusCode = 400;
      httpResponse.message = err.toString();
      httpResponse.data = err.toString();
      return httpResponse;
    });
    return httpResponse;
  }

  Future<HttpResponse> logout() async {
    HttpResponse httpResponse = HttpResponse();
    GetStorage box = GetStorage();
    // httpClient!.client!.options =
    //     BaseOptions(contentType: Headers.formUrlEncodedContentType);
    await httpClient!
        .get(BaseUrl().baseUrl + endPoints.User().logout, box.read("token"))
        .then((responce) async {
      print("responce.statusCode:");
      print(responce.statusCode);

      if (responce.statusCode == 200 || responce.statusCode == 201) {
        httpResponse.statusCode = responce.statusCode;
        httpResponse.data = responce.data;
        httpResponse.message = responce.data['data']['message'];

        box.remove("token");
        box.remove("login");

        showSessionExpiredSnackBar();
        Get.offAllNamed(Routes.LOGIN);
      } else if (responce.statusCode == 401) {
        httpResponse.statusCode = responce.statusCode;
        httpResponse.data = responce.data;
        httpResponse.message = responce.data['data']['message'];
        box.remove("token");
        box.remove("login");

        showSessionExpiredSnackBar();
        Get.offAllNamed(Routes.LOGIN);
      } else if (responce.statusCode == 422) {
        httpResponse.statusCode = responce.statusCode;
        httpResponse.message = responce.data['error'];
        httpResponse.data = httpResponse.data = responce.data;
        box.remove("token");
        box.remove("login");

        showSessionExpiredSnackBar();
        Get.offAllNamed(Routes.LOGIN);
      }
      return httpResponse;
    }).catchError((err) {
      box.remove("token");
      box.remove("login");

      showSessionExpiredSnackBar();
      Get.offAllNamed(Routes.LOGIN);
      httpResponse.statusCode = 400;
      httpResponse.message = err.toString();
      httpResponse.data = err.toString();
      return httpResponse;
    });

    return httpResponse;
  }

  Future<HttpResponse> userProfile() async {
    HttpResponse httpResponse = HttpResponse();
    GetStorage box = GetStorage();
    // httpClient!.client!.options =
    //     BaseOptions(contentType: Headers.formUrlEncodedContentType);
    await httpClient!
        .get(
            BaseUrl().baseUrl + endPoints.User().userProfile, box.read("token"))
        .then((responce) async {
      print("responce.statusCode");
      print(responce.statusCode);

      if (responce.statusCode == 200 || responce.statusCode == 201) {
        httpResponse.statusCode = responce.statusCode;
        httpResponse.data = responce.data;
        httpResponse.message = responce.data['data']['message'];
      } else if (responce.statusCode == 401) {
        httpResponse.statusCode = responce.statusCode;
        httpResponse.data = responce.data;
        httpResponse.message = responce.data['data']['message'];
        box.remove("token");
        box.remove("login");
        showSessionExpiredSnackBar();
        Get.offAllNamed(Routes.LOGIN);
      } else if (responce.statusCode == 422) {
        httpResponse.statusCode = responce.statusCode;
        httpResponse.message = responce.data['error'];
        httpResponse.data = httpResponse.data = responce.data;
      }
      return httpResponse;
    }).catchError((err) {
      if (err.toString().contains("401")) {
        httpResponse.statusCode = 401;
        httpResponse.data = null;
        httpResponse.message = "Invalid AUTH Token";
        box.remove("token");
        box.remove("login");
        showSessionExpiredSnackBar();
        Get.offAllNamed(Routes.LOGIN);
      } else {
        httpResponse.statusCode = 400;
        httpResponse.message = err.toString();
        httpResponse.data = err.toString();
        return httpResponse;
      }
    });
    return httpResponse;
  }

  Future<HttpResponse> videosList() async {
    HttpResponse httpResponse = HttpResponse();
    GetStorage box = GetStorage();
    // httpClient!.client!.options =
    //     BaseOptions(contentType: Headers.formUrlEncodedContentType);

    await httpClient!
        .post(
            BaseUrl().baseUrl + endPoints.User().userVideos, box.read("token"))
        .then((responce) async {
      print("responce.statusCode");
      print(responce.statusCode);

      if (responce.statusCode == 200 || responce.statusCode == 201) {
        httpResponse.statusCode = responce.statusCode;
        httpResponse.data = responce.data;
        httpResponse.message = responce.data['data']['message'];
      } else if (responce.statusCode == 401 || responce.statusCode == 422) {
        httpResponse.statusCode = responce.statusCode;
        httpResponse.data = responce.data;
        httpResponse.message = responce.data['data']['message'];
        box.remove("token");
        box.remove("login");

        showSessionExpiredSnackBar();
        Get.offAllNamed(Routes.LOGIN);
      }

      return httpResponse;
    }).catchError((err) {
      httpResponse.statusCode = 400;
      httpResponse.message = err.toString();
      httpResponse.data = err.toString();
      return httpResponse;
    });
    return httpResponse;
  }

  Future<HttpResponse> interviewQuestions() async {
    HttpResponse httpResponse = HttpResponse();
    GetStorage box = GetStorage();
    // httpClient!.client!.options =
    //     BaseOptions(contentType: Headers.formUrlEncodedContentType);
    await httpClient!.post(
        BaseUrl().baseUrl + endPoints.User().interviewQuestions,
        box.read("token"),
        body: {
          'interview_id': '1',
          'interview_category_id': '1'
        }).then((responce) async {
      print("responce.statusCode");
      print(responce.statusCode);

      if (responce.statusCode == 200 || responce.statusCode == 201) {
        httpResponse.statusCode = responce.statusCode;
        httpResponse.data = responce.data;
        httpResponse.message = responce.data['data']['message'];
      } else if (responce.statusCode == 401 || responce.statusCode == 422) {
        closeDialogBox();
        httpResponse.statusCode = responce.statusCode;
        httpResponse.data = responce.data;
        httpResponse.message = responce.data['data']['message'];
        box.remove("token");
        box.remove("login");
        // Get.offAll(() => Routes.LOGIN);
        closeDialogBox();
        Get.offAllNamed(Routes.LOGIN);
        showSessionExpiredSnackBar();
      }

      return httpResponse;
    }).catchError((err) {
      httpResponse.statusCode = 400;
      httpResponse.message = err.toString();
      httpResponse.data = err.toString();
      return httpResponse;
    });
    return httpResponse;
  }

  String changeFileNameOnly(File file, String newFileName) {
    var path = file.path;
    var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
    var newPath = path.substring(0, lastSeparator + 1) + newFileName;
    file.rename(newPath);
    return newPath;
  }

  Future<HttpResponse> uploadVideos(String title, String length,
      String pathImage, String pathVideo, String id) async {
    HttpResponse httpResponse = HttpResponse();
    GetStorage box = GetStorage();
    // httpClient!.client!.options =
    //     BaseOptions(contentType: Headers.formUrlEncodedContentType);
    String newPath = changeFileNameOnly(File(pathVideo), '${id}.mp4');
    Map<String, String> data = {
      'type': '1',
      'title': title,
      'length': length,
    };

    final formData = dio.FormData();
    formData.files.add(MapEntry(
      'video',
      await dio.MultipartFile.fromFile(
        newPath,
        filename: '$id.mp4', // Replace with the desired file name
      ),
    ));
    formData.files.add(MapEntry(
        'thumbnail_image', await dio.MultipartFile.fromFile(pathImage)));
    formData.fields
        .addAll(data.entries.map((e) => MapEntry(e.key, e.value.toString())));

    await httpClient!
        .post(BaseUrl().baseUrl + endPoints.User().upload, box.read("token"),
            body: formData)
        .then((responce) async {
      print("responce.statusCode");
      print(responce.statusCode);

      if (responce.statusCode == 200 || responce.statusCode == 201) {
        httpResponse.statusCode = responce.statusCode;
        httpResponse.data = responce.data;
        httpResponse.message = responce.data['data']['message'];
      } else if (responce.statusCode == 401 || responce.statusCode == 422) {
        httpResponse.statusCode = responce.statusCode;
        httpResponse.data = responce.data;
        httpResponse.message = responce.data['data']['message'];
        box.remove("token");
        box.remove("login");

        showSessionExpiredSnackBar();
        Get.offAllNamed(Routes.LOGIN);
      }

      return httpResponse;
    }).catchError((err) {
      httpResponse.statusCode = 400;
      httpResponse.message = err.toString();
      httpResponse.data = err.toString();
      return httpResponse;
    });
    return httpResponse;
  }

  Future<HttpResponse> getUserAgent() async {
    HttpResponse httpResponse = HttpResponse();
    GetStorage box = GetStorage();
    // httpClient!.client!.options =
    //     BaseOptions(contentType: Headers.formUrlEncodedContentType);
    await httpClient!
        .post(BaseUrl().baseUrl + endPoints.User().getAgent, box.read("token"))
        .then((responce) async {
      print("responce.statusCode");
      print(responce.statusCode);

      if (responce.statusCode == 200 || responce.statusCode == 201) {
        httpResponse.statusCode = responce.statusCode;
        httpResponse.data = responce.data;
        httpResponse.message = responce.data['data']['message'];
        //print(httpResponse.message);
      } else if (responce.statusCode == 401) {
        httpResponse.statusCode = responce.statusCode;
        httpResponse.data = responce.data;
        httpResponse.message = responce.data['data']['message'];
        box.remove("token");
        box.remove("login");
        showSessionExpiredSnackBar();
        Get.offAllNamed(Routes.LOGIN);
      } else if (responce.statusCode == 422) {
        httpResponse.statusCode = responce.statusCode;
        httpResponse.message = responce.data['error'];
        httpResponse.data = httpResponse.data = responce.data;
        //print("${httpResponse.message} 422");
      }
      return httpResponse;
    }).catchError((err) {
      httpResponse.statusCode = 400;
      httpResponse.message = err.toString();
      httpResponse.data = err.toString();
      //print("${httpResponse.message} 400");
      return httpResponse;
    });
    return httpResponse;
  }

  Future<HttpResponse> getVideosScore() async {
    HttpResponse httpResponse = HttpResponse();
    GetStorage box = GetStorage();

    await httpClient!
        .get(BaseUrl().baseUrl + endPoints.User().getVideosScore, box.read("token"))
        .then((responce) async {

      print("responce.statusCode");
      print(responce.statusCode);


      if (responce.statusCode == 200 || responce.statusCode == 201) {
        httpResponse.statusCode = responce.statusCode;
        httpResponse.data = responce.data;
        httpResponse.message = responce.data['data']['message'];
      } else if (responce.statusCode == 401 || responce.statusCode == 422) {
        closeDialogBox();
        httpResponse.statusCode = responce.statusCode;
        httpResponse.data = responce.data;
        httpResponse.message = responce.data['data']['message'];
        box.remove("token");
        box.remove("login");
        // Get.offAll(() => Routes.LOGIN);
        closeDialogBox();
        Get.offAllNamed(Routes.LOGIN);
        showSessionExpiredSnackBar();
      }

      return httpResponse;
    }).catchError((err) {
      httpResponse.statusCode = 400;
      httpResponse.message = err.toString();
      httpResponse.data = err.toString();
      return httpResponse;
    });
    return httpResponse;
  }
}
/*
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:onboarding_app/network/client/dioApi_client.dart';
import 'package:onboarding_app/network/models/HttpReposonceHandler.dart';
import '../../../routes/app_pages.dart';
import '../../apiClient/base_url.dart';
import '../../apiClient/endPoints.dart' as endPoints;
import 'package:dio/dio.dart' as dio;

class UserRepo {
  DioClient? httpClient;
  void showSessionExpiredSnackBar() {
    Get.snackbar(
      "Session Expired...",
      "Session has expired. Please login again.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      margin: const EdgeInsets.all(20),
      duration: const Duration(seconds: 5),

    );
  }
  UserRepo() {
    httpClient = DioClient();
  }
  Future<HttpResponse> login(String email, String password , String deviceToken ,
      String  deviceType , String referenceCode
      ) async {
    HttpResponse httpResponse = HttpResponse();
    GetStorage box = GetStorage();
    // httpClient!.client!.options =
    //     BaseOptions(contentType: Headers.formUrlEncodedContentType);
    await httpClient!
        .post(BaseUrl().baseUrl + endPoints
        .User()
        .login,
        box.read("token"),
        body: {
          "email": email,
          "password": password,
          "device_token": deviceToken,
          "device_type": deviceType,
          "reference_code": referenceCode,
        }
    ).then((responce) async {



      if(responce.statusCode == 200 || responce.statusCode == 201){
        httpResponse.statusCode = responce.statusCode;
        httpResponse.data = responce.data;
        httpResponse.message = responce.data['data']['message'];

      }
      else if (responce.statusCode == 401) {
        httpResponse.statusCode = responce.statusCode;
        httpResponse.data = responce.data;
        httpResponse.message = responce.data['data']['message'];
        box.remove("token");
        box.remove("login");

        showSessionExpiredSnackBar();
        Get.offAllNamed(Routes.LOGIN);
      }

      else if(responce.statusCode == 422) {

        httpResponse.statusCode = responce.statusCode;
        httpResponse.message = responce.data['error'];
        httpResponse.data = httpResponse.data = responce.data;
      }
      return httpResponse;
    }).catchError((err) {
      httpResponse.statusCode = 400;
      httpResponse.message = err.toString();
      httpResponse.data = err.toString();
      return httpResponse;
    });
    return httpResponse;
  }



  Future<HttpResponse> signup( String name ,String email, String password ,  String dob, String deviceToken ,
      String  deviceType , String referenceCode
      ) async {
    HttpResponse httpResponse = HttpResponse();
    GetStorage box = GetStorage();
    // httpClient!.client!.options =
    //     BaseOptions(contentType: Headers.formUrlEncodedContentType);
    await httpClient!
        .post(BaseUrl().baseUrl + endPoints
        .User()
        .signupUser,
        box.read("token"),
        body: {
          "name": name,
          "email": email,
          "password": password,
          "dob": dob,
          "device_token": deviceToken,
          "device_type": deviceType,
          "reference_code": referenceCode,
        }
    ).then((responce) async {

      if (responce.statusCode == 201 ||  responce.statusCode == 200) {

        httpResponse.statusCode = responce.statusCode;
        httpResponse.message = responce.data['data']['message'];
        httpResponse.data = responce.data['data'];
      } else if(responce.statusCode == 422) {
        httpResponse.statusCode = responce.statusCode;
        httpResponse.message = responce.data['error'];
        httpResponse.data = responce.data;
      }
      // else if (httpResponse.statusCode == 401) {
      //   box.remove("token");
      //   box.remove("login");
      //   Get.offAllNamed(Routes.LOGIN);
      // }
      else  if(responce.statusCode == 404){
        httpResponse.statusCode = responce.statusCode;
        httpResponse.message = "Something went wrong";
        httpResponse.data = null;
      }

      return httpResponse;
    }).catchError((err) {

      httpResponse.statusCode = 404;
      httpResponse.message = err.toString();
      httpResponse.data = err.toString();
      return httpResponse;
    });
    return httpResponse;
  }

  Future<HttpResponse> forgotPassword(String email) async {
    HttpResponse httpResponse = HttpResponse();
    GetStorage box = GetStorage();
    // httpClient!.client!.options =
    //     BaseOptions(contentType: Headers.formUrlEncodedContentType);
    await httpClient!
        .post(BaseUrl().baseUrl + endPoints
        .User()
        .resetPassword,
        box.read("token"),
        body: {
          "email": email,
        }
    ).then((responce) async {

      if(responce.statusCode == 200 || responce.statusCode == 201){
        httpResponse.statusCode = responce.statusCode;
        httpResponse.data = responce.data;
        httpResponse.message = responce.data['data']['message'];

      }  else if (responce.statusCode == 401) {
        httpResponse.statusCode = responce.statusCode;
        httpResponse.data = responce.data;
        httpResponse.message = responce.data['data']['message'];
        box.remove("token");
        box.remove("login");

        showSessionExpiredSnackBar();
        Get.offAllNamed(Routes.LOGIN);
      }
      else if(responce.statusCode == 422) {

        httpResponse.statusCode = responce.statusCode;
        httpResponse.message = responce.data['error'];
        httpResponse.data = httpResponse.data = responce.data;
      }
      return httpResponse;
    }).catchError((err) {

      httpResponse.statusCode = 400;
      httpResponse.message = err.toString();
      httpResponse.data = err.toString();
      return httpResponse;
    });
    return httpResponse;
  }

  Future<HttpResponse> logout() async {
    HttpResponse httpResponse = HttpResponse();
    GetStorage box = GetStorage();
    // httpClient!.client!.options =
    //     BaseOptions(contentType: Headers.formUrlEncodedContentType);
    await httpClient!
        .get(BaseUrl().baseUrl + endPoints
        .User()
        .logout,
        box.read("token")

    ).then((responce) async {


      if(responce.statusCode == 200 || responce.statusCode == 201){
        httpResponse.statusCode = responce.statusCode;
        httpResponse.data = responce.data;
        httpResponse.message = responce.data['data']['message'];
        box.remove("token");
        box.remove("login");
        Get.offAllNamed(Routes.LOGIN);

      }
      else if (responce.statusCode == 401) {
        httpResponse.statusCode = responce.statusCode;
        httpResponse.data = responce.data;
        httpResponse.message = responce.data['data']['message'];
        box.remove("token");
        box.remove("login");

        showSessionExpiredSnackBar();
        Get.offAllNamed(Routes.LOGIN);
      }
      else if(responce.statusCode == 422) {

        httpResponse.statusCode = responce.statusCode;
        httpResponse.message = responce.data['error'];
        httpResponse.data = httpResponse.data = responce.data;
      }
      return httpResponse;
    }).catchError((err) {

      httpResponse.statusCode = 400;
      httpResponse.message = err.toString();
      httpResponse.data = err.toString();
      return httpResponse;
    });
    return httpResponse;
  }

  Future<HttpResponse> userProfile() async {
    HttpResponse httpResponse = HttpResponse();
    GetStorage box = GetStorage();
    // httpClient!.client!.options =
    //     BaseOptions(contentType: Headers.formUrlEncodedContentType);
    await httpClient!
        .get(BaseUrl().baseUrl + endPoints
        .User()
        .userProfile,
        box.read("token")

    ).then((responce) async {




      if(responce.statusCode == 200 || responce.statusCode == 201){
        httpResponse.statusCode = responce.statusCode;
        httpResponse.data = responce.data;
        httpResponse.message = responce.data['data']['message'];



      }
      else if (responce.statusCode == 401) {
        httpResponse.statusCode = responce.statusCode;
        httpResponse.data = responce.data;
        httpResponse.message = responce.data['data']['message'];
        box.remove("token");
        box.remove("login");

        showSessionExpiredSnackBar();
        Get.offAllNamed(Routes.LOGIN);

      }
      else if(responce.statusCode == 422) {

        httpResponse.statusCode = responce.statusCode;
        httpResponse.message = responce.data['error'];
        httpResponse.data = httpResponse.data = responce.data;
      }
      return httpResponse;
    }).catchError((err) {

      httpResponse.statusCode = 400;
      httpResponse.message = err.toString();
      httpResponse.data = err.toString();
      return httpResponse;
    });
    return httpResponse;
  }

  Future<HttpResponse> videosList()
  async {
    HttpResponse httpResponse = HttpResponse();
    GetStorage box = GetStorage();
    // httpClient!.client!.options =
    //     BaseOptions(contentType: Headers.formUrlEncodedContentType);

    await httpClient!
        .post(BaseUrl().baseUrl + endPoints
        .User()
        .userVideos,
        box.read("token")

    ).then((responce) async {

      print("responce.statusCode");

      print(responce.statusCode);


      if(responce.statusCode == 200 || responce.statusCode == 201){
        httpResponse.statusCode = responce.statusCode;
        httpResponse.data = responce.data;
        httpResponse.message = responce.data['data']['message'];

      }
      else if (responce.statusCode == 401 || responce.statusCode == 422) {
        httpResponse.statusCode = responce.statusCode;
        httpResponse.data = responce.data;
        httpResponse.message = responce.data['data']['message'];
        box.remove("token");
        box.remove("login");

        showSessionExpiredSnackBar();
        Get.offAllNamed(Routes.LOGIN);


      }

      return httpResponse;
    }).catchError((err) {

      httpResponse.statusCode = 400;
      httpResponse.message = err.toString();
      httpResponse.data = err.toString();
      return httpResponse;
    });
    return httpResponse;
  }

  Future<HttpResponse> interviewQuestions() async {
    HttpResponse httpResponse = HttpResponse();
    GetStorage box = GetStorage();
    // httpClient!.client!.options =
    //     BaseOptions(contentType: Headers.formUrlEncodedContentType);
    await httpClient!
        .post(BaseUrl().baseUrl + endPoints
        .User()
        .interviewQuestions,
        box.read("token"),
        body: {
          'interview_id':'1',
          'interview_category_id':'1'
        }

    ).then((responce) async {


      print("responce.statusCode");
      print(responce.statusCode);




      if(responce.statusCode == 200 || responce.statusCode == 201){
        httpResponse.statusCode = responce.statusCode;
        httpResponse.data = responce.data;
        httpResponse.message = responce.data['data']['message'];


      }
      else if (responce.statusCode == 401 || responce.statusCode == 422) {
        httpResponse.statusCode = responce.statusCode;
        httpResponse.data = responce.data;
        httpResponse.message = responce.data['data']['message'];
        box.remove("token");
        box.remove("login");
        // Get.offAll(() => Routes.LOGIN);
        Get.offAllNamed(Routes.LOGIN);
        showSessionExpiredSnackBar();
      }


      return httpResponse;
    }).catchError((err) {
      httpResponse.statusCode = 400;
      httpResponse.message = err.toString();
      httpResponse.data = err.toString();
      return httpResponse;
    });
    return httpResponse;
  }

  String changeFileNameOnly(File file, String newFileName) {
    var path = file.path;
    var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
    var newPath = path.substring(0, lastSeparator + 1) + newFileName;
    file.rename(newPath);
    return newPath;
  }

  Future<HttpResponse> uploadVideos(String title, String length, String pathImage, String pathVideo, String id) async {
    HttpResponse httpResponse = HttpResponse();
    GetStorage box = GetStorage();
    // httpClient!.client!.options =
    //     BaseOptions(contentType: Headers.formUrlEncodedContentType);
    String newPath = changeFileNameOnly(File(pathVideo), '${id}.mp4');
    Map<String, String> data = {
      'type':'1',
      'title':title,
      'length':length,
    };


    final formData = dio.FormData();
    formData.files.add(MapEntry(
      'video',
      await dio.MultipartFile.fromFile(
        newPath,
        filename: '$id.mp4', // Replace with the desired file name
      ),
    ));
    formData.files.add(MapEntry(
        'thumbnail_image',
        await dio.MultipartFile.fromFile(pathImage)
    ));
    formData.fields.addAll(data.entries.map((e) => MapEntry(e.key, e.value.toString())));


    await httpClient!
        .post(BaseUrl().baseUrl + endPoints
        .User()
        .upload,
        box.read("token"),
        body: formData
    ).then((responce) async {


      print("responce.statusCode");
      print(responce.statusCode);


      if(responce.statusCode == 200 || responce.statusCode == 201){
        httpResponse.statusCode = responce.statusCode;
        httpResponse.data = responce.data;
        httpResponse.message = responce.data['data']['message'];


      }
      else if (responce.statusCode == 401|| responce.statusCode == 422) {
        httpResponse.statusCode = responce.statusCode;
        httpResponse.data = responce.data;
        httpResponse.message = responce.data['data']['message'];
        box.remove("token");
        box.remove("login");

        showSessionExpiredSnackBar();
        Get.offAllNamed(Routes.LOGIN);
      }

      return httpResponse;
    }).catchError((err) {

      httpResponse.statusCode = 400;
      httpResponse.message = err.toString();
      httpResponse.data = err.toString();
      return httpResponse;
    });
    return httpResponse;
  }

  Future<HttpResponse> getUserAgent() async {
    HttpResponse httpResponse = HttpResponse();
    GetStorage box = GetStorage();
    // httpClient!.client!.options =
    //     BaseOptions(contentType: Headers.formUrlEncodedContentType);
    await httpClient!
        .post(BaseUrl().baseUrl + endPoints
        .User()
        .getAgent,
        box.read("token")

    ).then((responce) async {

      print("responce.statusCode");
      print(responce.statusCode);

      if(responce.statusCode == 200 || responce.statusCode == 201){
        httpResponse.statusCode = responce.statusCode;
        httpResponse.data = responce.data;
        httpResponse.message = responce.data['data']['message'];
        //print(httpResponse.message);

      }
      else if (responce.statusCode == 401) {
        httpResponse.statusCode = responce.statusCode;
        httpResponse.data = responce.data;
        httpResponse.message = responce.data['data']['message'];
        box.remove("token");
        box.remove("login");
        showSessionExpiredSnackBar();
        Get.offAllNamed(Routes.LOGIN);
      } else if(responce.statusCode == 422) {

        httpResponse.statusCode = responce.statusCode;
        httpResponse.message = responce.data['error'];
        httpResponse.data = httpResponse.data = responce.data;
        //print("${httpResponse.message} 422");
      }
      return httpResponse;
    }).catchError((err) {

      httpResponse.statusCode = 400;
      httpResponse.message = err.toString();
      httpResponse.data = err.toString();
      //print("${httpResponse.message} 400");
      return httpResponse;
    });
    return httpResponse;
  }
}


 */
/*
import 'dart:io';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:onboarding_app/network/client/dioApi_client.dart';
import 'package:onboarding_app/network/models/HttpReposonceHandler.dart';
import '../../../routes/app_pages.dart';
import '../../apiClient/base_url.dart';
import '../../apiClient/endPoints.dart' as endPoints;
import 'package:dio/dio.dart' as dio;

class UserRepo {
  DioClient? httpClient;

  UserRepo() {
    httpClient = DioClient();
  }
  Future<HttpResponse> login(String email, String password , String deviceToken ,
    String  deviceType , String referenceCode
      ) async {
    HttpResponse httpResponse = HttpResponse();
    GetStorage box = GetStorage();
    // httpClient!.client!.options =
    //     BaseOptions(contentType: Headers.formUrlEncodedContentType);
    await httpClient!
        .post(BaseUrl().baseUrl + endPoints
        .User()
        .login,
        box.read("token"),
        body: {
          "email": email,
          "password": password,
          "device_token": deviceToken,
          "device_type": deviceType,
          "reference_code": referenceCode,
        }
    ).then((responce) async {

      if(responce.statusCode == 200 || responce.statusCode == 201){
        httpResponse.statusCode = responce.statusCode;
        httpResponse.data = responce.data;
        httpResponse.message = responce.data['data']['message'];

      } else if(responce.statusCode == 422) {

        httpResponse.statusCode = responce.statusCode;
        httpResponse.message = responce.data['error'];
        httpResponse.data = httpResponse.data = responce.data;
      }
      return httpResponse;
    }).catchError((err) {
      httpResponse.statusCode = 400;
      httpResponse.message = err.toString();
      httpResponse.data = err.toString();
      return httpResponse;
    });
    return httpResponse;
  }



  Future<HttpResponse> signup( String name ,String email, String password ,  String dob, String deviceToken ,
      String  deviceType , String referenceCode
      ) async {
    HttpResponse httpResponse = HttpResponse();
    GetStorage box = GetStorage();
    // httpClient!.client!.options =
    //     BaseOptions(contentType: Headers.formUrlEncodedContentType);
    await httpClient!
        .post(BaseUrl().baseUrl + endPoints
        .User()
        .signupUser,
        box.read("token"),
        body: {
          "name": name,
          "email": email,
          "password": password,
          "dob": dob,
          "device_token": deviceToken,
          "device_type": deviceType,
          "reference_code": referenceCode,
        }
    ).then((responce) async {

      if (responce.statusCode == 201 ||  responce.statusCode == 200) {

          httpResponse.statusCode = responce.statusCode;
          httpResponse.message = responce.data['data']['message'];
          httpResponse.data = responce.data['data'];
      } else if(responce.statusCode == 422) {
        httpResponse.statusCode = responce.statusCode;
        httpResponse.message = responce.data['error'];
        httpResponse.data = responce.data;
      }
      else  if(responce.statusCode == 404){
        httpResponse.statusCode = responce.statusCode;
        httpResponse.message = "Something went wrong";
        httpResponse.data = null;
      }

      return httpResponse;
    }).catchError((err) {

      httpResponse.statusCode = 404;
      httpResponse.message = err.toString();
      httpResponse.data = err.toString();
      return httpResponse;
    });
    return httpResponse;
  }

  Future<HttpResponse> forgotPassword(String email) async {
    HttpResponse httpResponse = HttpResponse();
    GetStorage box = GetStorage();
    // httpClient!.client!.options =
    //     BaseOptions(contentType: Headers.formUrlEncodedContentType);
    await httpClient!
        .post(BaseUrl().baseUrl + endPoints
        .User()
        .resetPassword,
        box.read("token"),
        body: {
          "email": email,
        }
    ).then((responce) async {

      if(responce.statusCode == 200 || responce.statusCode == 201){
        httpResponse.statusCode = responce.statusCode;
        httpResponse.data = responce.data;
        httpResponse.message = responce.data['data']['message'];

      } else if(responce.statusCode == 422) {

        httpResponse.statusCode = responce.statusCode;
        httpResponse.message = responce.data['error'];
        httpResponse.data = httpResponse.data = responce.data;
      }
      return httpResponse;
    }).catchError((err) {

      httpResponse.statusCode = 400;
      httpResponse.message = err.toString();
      httpResponse.data = err.toString();
      return httpResponse;
    });
    return httpResponse;
  }

  Future<HttpResponse> logout() async {
    HttpResponse httpResponse = HttpResponse();
    GetStorage box = GetStorage();
    // httpClient!.client!.options =
    //     BaseOptions(contentType: Headers.formUrlEncodedContentType);
    await httpClient!
        .get(BaseUrl().baseUrl + endPoints
        .User()
        .logout,
      box.read("token")

    ).then((responce) async {

      if(responce.statusCode == 200 || responce.statusCode == 201){
        httpResponse.statusCode = responce.statusCode;
        httpResponse.data = responce.data;
        httpResponse.message = responce.data['data']['message'];
        box.remove("token");
        box.remove("login");
        Get.offAllNamed(Routes.LOGIN);

      } else if(responce.statusCode == 422) {

        httpResponse.statusCode = responce.statusCode;
        httpResponse.message = responce.data['error'];
        httpResponse.data = httpResponse.data = responce.data;
      }
      return httpResponse;
    }).catchError((err) {

      httpResponse.statusCode = 400;
      httpResponse.message = err.toString();
      httpResponse.data = err.toString();
      return httpResponse;
    });
    return httpResponse;
  }

  Future<HttpResponse> userProfile() async {
    HttpResponse httpResponse = HttpResponse();
    GetStorage box = GetStorage();
    // httpClient!.client!.options =
    //     BaseOptions(contentType: Headers.formUrlEncodedContentType);
    await httpClient!
        .get(BaseUrl().baseUrl + endPoints
        .User()
        .userProfile,
        box.read("token")

    ).then((responce) async {

      if(responce.statusCode == 200 || responce.statusCode == 201){
        httpResponse.statusCode = responce.statusCode;
        httpResponse.data = responce.data;
        httpResponse.message = responce.data['data']['message'];


      } else if(responce.statusCode == 422) {

        httpResponse.statusCode = responce.statusCode;
        httpResponse.message = responce.data['error'];
        httpResponse.data = httpResponse.data = responce.data;
      }
      return httpResponse;
    }).catchError((err) {

      httpResponse.statusCode = 400;
      httpResponse.message = err.toString();
      httpResponse.data = err.toString();
      return httpResponse;
    });
    return httpResponse;
  }

  Future<HttpResponse> videosList() async {
    HttpResponse httpResponse = HttpResponse();
    GetStorage box = GetStorage();
    // httpClient!.client!.options =
    //     BaseOptions(contentType: Headers.formUrlEncodedContentType);

    await httpClient!
        .post(BaseUrl().baseUrl + endPoints
        .User()
        .userVideos,
        box.read("token")

    ).then((responce) async {

      if(responce.statusCode == 200 || responce.statusCode == 201){
        httpResponse.statusCode = responce.statusCode;
        httpResponse.data = responce.data;
        httpResponse.message = responce.data['data']['message'];


      } else if(responce.statusCode == 422) {

        httpResponse.statusCode = responce.statusCode;
        httpResponse.message = responce.data['error'];
        httpResponse.data = httpResponse.data = responce.data;
      }
      return httpResponse;
    }).catchError((err) {

      httpResponse.statusCode = 400;
      httpResponse.message = err.toString();
      httpResponse.data = err.toString();
      return httpResponse;
    });
    return httpResponse;
  }

  Future<HttpResponse> interviewQuestions() async {
    HttpResponse httpResponse = HttpResponse();
    GetStorage box = GetStorage();
    // httpClient!.client!.options =
    //     BaseOptions(contentType: Headers.formUrlEncodedContentType);
    await httpClient!
        .post(BaseUrl().baseUrl + endPoints
        .User()
        .interviewQuestions,
        box.read("token"),
      body: {
          'interview_id':'1',
        'interview_category_id':'1'
      }

    ).then((responce) async {

      if(responce.statusCode == 200 || responce.statusCode == 201){
        httpResponse.statusCode = responce.statusCode;
        httpResponse.data = responce.data;
        httpResponse.message = responce.data['data']['message'];


      } else if(responce.statusCode == 422) {

        httpResponse.statusCode = responce.statusCode;
        httpResponse.message = responce.data['error'];
        httpResponse.data = httpResponse.data = responce.data;
      }
      return httpResponse;
    }).catchError((err) {
      httpResponse.statusCode = 400;
      httpResponse.message = err.toString();
      httpResponse.data = err.toString();
      return httpResponse;
    });
    return httpResponse;
  }

  String changeFileNameOnly(File file, String newFileName) {
    var path = file.path;
    var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
    var newPath = path.substring(0, lastSeparator + 1) + newFileName;
    file.rename(newPath);
    return newPath;
  }

  Future<HttpResponse> uploadVideos(String title, String length, String pathImage, String pathVideo, String id) async {
    HttpResponse httpResponse = HttpResponse();
    GetStorage box = GetStorage();
    // httpClient!.client!.options =
    //     BaseOptions(contentType: Headers.formUrlEncodedContentType);
    String newPath = changeFileNameOnly(File(pathVideo), '${id}.mp4');
    Map<String, String> data = {
      'type':'1',
      'title':title,
      'length':length,
    };

    final formData = dio.FormData();
    formData.files.add(MapEntry(
      'video',
      await dio.MultipartFile.fromFile(
        newPath,
        filename: '$id.mp4', // Replace with the desired file name
      ),
    ));
    formData.files.add(MapEntry(
    'thumbnail_image',
      await dio.MultipartFile.fromFile(pathImage)
    ));
    formData.fields.addAll(data.entries.map((e) => MapEntry(e.key, e.value.toString())));


    await httpClient!
        .post(BaseUrl().baseUrl + endPoints
        .User()
        .upload,
        box.read("token"),
        body: formData
    ).then((responce) async {

      if(responce.statusCode == 200 || responce.statusCode == 201){
        httpResponse.statusCode = responce.statusCode;
        httpResponse.data = responce.data;
        httpResponse.message = responce.data['data']['message'];


      } else if(responce.statusCode == 422) {

        httpResponse.statusCode = responce.statusCode;
        httpResponse.message = responce.data['error'];
        httpResponse.data = httpResponse.data = responce.data;
      }
      return httpResponse;
    }).catchError((err) {

      httpResponse.statusCode = 400;
      httpResponse.message = err.toString();
      httpResponse.data = err.toString();
      return httpResponse;
    });
    return httpResponse;
  }

  Future<HttpResponse> getUserAgent() async {
    HttpResponse httpResponse = HttpResponse();
    GetStorage box = GetStorage();
    // httpClient!.client!.options =
    //     BaseOptions(contentType: Headers.formUrlEncodedContentType);
    await httpClient!
        .post(BaseUrl().baseUrl + endPoints
        .User()
        .getAgent,
        box.read("token")

    ).then((responce) async {

      if(responce.statusCode == 200 || responce.statusCode == 201){
        httpResponse.statusCode = responce.statusCode;
        httpResponse.data = responce.data;
        httpResponse.message = responce.data['data']['message'];
        //print(httpResponse.message);

      } else if(responce.statusCode == 422) {

        httpResponse.statusCode = responce.statusCode;
        httpResponse.message = responce.data['error'];
        httpResponse.data = httpResponse.data = responce.data;
        //print("${httpResponse.message} 422");
      }
      return httpResponse;
    }).catchError((err) {

      httpResponse.statusCode = 400;
      httpResponse.message = err.toString();
      httpResponse.data = err.toString();
      //print("${httpResponse.message} 400");
      return httpResponse;
    });
    return httpResponse;
  }
}

 */
