import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:onboarding_app/widgets/appButton.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../controllers/GuideController/guide-controller.dart';
import '../../../flutter_camera.dart';
import '../../../flutter_camera_latest.dart';
import '../../../network/repository/auth/auth_repo.dart';
import '../../cameraPage/camera_page.dart';

class QuestionsDisplay extends StatefulWidget {
  final String question;

  QuestionsDisplay({Key? key, required this.question}) : super(key: key);

  @override
  QuestionsDisplayState createState() => QuestionsDisplayState();
}

class QuestionsDisplayState extends State<QuestionsDisplay> {
  final GuideController? _controller = Get.put(GuideController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.orange, title: Text("Video Interview")),
        // body: Center(child: Text("Welcome to Javapoint")));
        body: Center(
            child: Column(children: [
          SizedBox(height: 20),
          Text(_controller!.quesList[_controller!.idx.value].question
              .toString()),
          SizedBox(height: 20),
          AppButton(
              borderRadius: BorderRadius.circular(12),
              buttontext: "Open Camera",
              onTap: () {
                //    _controller?.changeListIndex();
                print("current question");
                print(_controller!.currentQuestion);
               // showFESessionExpired();
                showCameraPage();
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) =>
                        CameraPage(question: _controller!.currentQuestion),
                  ),
                );
              }),
        ])));

    /* return StatefulBuilder(
      builder: (BuildContext context, setState) => AlertDialog(
        title: Obx(
          () => Text(
            _controller!.quesList[_controller!.idx.value].question.toString(),
            style: const TextStyle(color: Colors.black),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _controller?.changeListIndex();
            },
            child: const Text(
              "Change Question",
              style: TextStyle(color: Colors.orange),
            ),
          ),
          TextButton(
            onPressed: () {
              _controller?.currentId =
                  _controller?.quesList[_controller!.idx.value].id ??
                      "1308b0cb-5921-420c-8bec-a3a26206c9b5";
              _controller?.currentQuestion =
                  _controller?.quesList[_controller!.idx.value].question ??
                      "Interview Question";
             */ /* Navigator.of(context).pop();
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) =>
                      CameraPage(question: _controller!.currentQuestion),
                ),
              );*/ /*
            },
            child: const Text(
              "Go",
              style: TextStyle(color: Colors.orange),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              //Navigator.of(context).pop();
              //bottomNavController.currentIndex = 1.obs;
            },
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.orange),
            ),
          )
        ],
      ),
    );*/
  }

  void showFESessionExpired() {
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

  void showCameraPage() {

    late var thumbnailPath;
    //var widget;
    FlutterCameraLatest(
      color: Colors.grey[850],
      question: widget.question,
      onVideoRecorded: (value) async {
        ///Show video preview .mp4
        final path = value.path;

        ///to generate thumbnail -DK
        if (path.contains(".mp4")) {
          thumbnailPath = await VideoThumbnail.thumbnailFile(
            video: path,
            imageFormat: ImageFormat.PNG,
            maxHeight: 200,
            quality: 50,
          );
          int len = await value.length();
          HttpResponse httpResponse = (await UserRepo().uploadVideos(
              _controller!.currentQuestion,
              len.toString(),
              thumbnailPath,
              path,
              _controller!.currentId)) as HttpResponse;
          if (httpResponse.statusCode == 200 ||
              httpResponse.statusCode == 201) {
            print("Video Uploaded Successfully questions_display");
            Fluttertoast.showToast(
                msg: "Video Uploaded Successfully!!!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0);
          } else {
            Fluttertoast.showToast(
                msg: "Something went wrong!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        } else {
          Fluttertoast.showToast(
              msg: "Something went wrong!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      },
    );
  }
}
