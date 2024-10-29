import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:onboarding_app/network/models/HttpReposonceHandler.dart';
import 'package:onboarding_app/network/repository/auth/auth_repo.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../controllers/GuideController/guide-controller.dart';
import '../../flutter_camera.dart';
import '../../flutter_camera_latest.dart';

class CameraPage extends StatefulWidget {
  final String question;

  CameraPage({Key? key, required this.question}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late var thumbnailPath;
  final GuideController? _controller = Get.put(GuideController());

  @override
  Widget build(BuildContext context) {
    Color transparentRed = Color.fromARGB(128, 0, 0, 0);
    return FlutterCameraLatest(
      color: transparentRed,
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
          HttpResponse httpResponse = await UserRepo().uploadVideos(
              _controller!.currentQuestion,
              len.toString(),
              thumbnailPath,
              path,
              _controller!.currentId);
          if (httpResponse.statusCode == 200 ||
              httpResponse.statusCode == 201) {
            print("Video Uploaded Successfully camera page");
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
