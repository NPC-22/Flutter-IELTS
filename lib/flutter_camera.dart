library flutter_camera;

import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:onboarding_app/network/models/HttpReposonceHandler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart' as myVideoThumbNail;
import 'package:video_thumbnail/video_thumbnail.dart';

import 'controllers/GuideController/guide-controller.dart';
import 'network/repository/auth/auth_repo.dart';

class FlutterCamera extends StatefulWidget {
  final Color? color;
  final Color? iconColor;
  final Function(XFile)? onVideoRecorded;
  final Duration? animationDuration;
  final String question;

  const FlutterCamera({
    Key? key,
    this.animationDuration = const Duration(seconds: 1),
    this.onVideoRecorded,
    this.iconColor = Colors.white,
    required this.color,
    this.question = "Question Not Found Restart",
  }) : super(key: key);

  @override
  _FlutterCameraState createState() => _FlutterCameraState();
}

class _FlutterCameraState extends State<FlutterCamera> {
  int _start = 30;
  List<CameraDescription>? cameras;
  CameraController? controller;
  bool _isRecording = false;
  final GuideController? _guidecontroller = Get.put(GuideController());
  XFile? videoUrl = new XFile("");
  late var thumbnailPath;
  late CameraDescription frontCamera;
  late var question;
  bool isStartRecordingBtnEnabled = true;
  bool isStopRecordingBtnEnabled = false;
  bool isUploadRecordingBtnEnabled = false;
  bool isCamerStartButtonPressed = false;
  late String len;
  bool isVideoRecorded = false;
  bool isVideoRecording = false;
  String displayCancelorRetake = "Cancel";
  String displayNextQuestorUploadVideo = "Next\nQuestion";
  late Timer _timer;
  late FlutterTts flutterTts;

  @override
  void initState() {
    super.initState();
    initCamera().then((_) {
      setCamera(1);
    });
    flutterTts = FlutterTts();
    updateText(_guidecontroller!.idx.value);
    _speakQuestion();
  }

  Future _speakQuestion() async {
    await flutterTts.setLanguage("en-US"); // Set language
    await flutterTts.setPitch(1.0); // Set pitch
    await flutterTts.speak(question);
  }

  Future<void> initCamera() async {
    cameras = await availableCameras();
    setState(() {});
  }

  void setCamera(int index) {
    controller = CameraController(cameras![index], ResolutionPreset.max);

    controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    flutterTts.stop();
    controller?.dispose();
    super.dispose();
  }

  String updateText(int value) {
    setState(() {
      question = _guidecontroller!.quesList[value].question.toString();
    });
    return question;
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      body: videoView(),
    );
  }

  String displayNextQuestion() {
    _speakQuestion();
    var value;
    var question;
    setState(() {
      _start = 30;
      isVideoRecording = false;
      _isRecording = false;
      isVideoRecorded = false;
      displayCancelorRetake = 'Cancel';
      displayNextQuestorUploadVideo = 'Next\nQuestion';
      value = _guidecontroller?.changeListIndextoNext();
      question = _guidecontroller!.quesList[value].question.toString();
    });
    return question;
  }

  void reTake() {
    setState(() {
      _start = 30;
      isVideoRecording = false;
      _isRecording = false;
      isVideoRecorded = false;
      displayCancelorRetake = 'Cancel';
      displayNextQuestorUploadVideo = 'Next\nQuestion';
      _speakQuestion();
    });
  }

  Widget videoView() {
    question = updateText(_guidecontroller!.idx.value);
    return Stack(
      key: const ValueKey(1),
      children: [
        isVideoRecorded
            ? SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: videoUrl!.path.isEmpty
                    ? Center(
                        child: Text(
                          'Video URL is empty',
                          style: TextStyle(fontSize: 18, color: Colors.red),
                        ),
                      )
                    : Center(
                        child: VideoPlayerWidget(videoPath: videoUrl!.path),
                      ),
              )
            : SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: CameraPreview(controller!),
              ),
        Positioned(
          top: 0,
          child: Container(
            padding: const EdgeInsets.only(
                top: 40, bottom: 10.0, left: 7.0, right: 7.0),
            width: MediaQuery.of(context).size.width,
            color: widget.color,
            child: Column(
              children: [
                if (!isVideoRecorded)
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            _isRecording == false
                                ? '00:30'
                                : "00:" +
                                    '${_start.toString().padLeft(2, '0')}',
                            style: TextStyle(
                                color: widget.iconColor, fontSize: 22),
                          ),
                        ),
                      ),
                    ],
                  ),
                Center(
                  child: Text(
                    question,
                    style: TextStyle(
                      color: widget.iconColor,
                      fontSize: 21.0,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(20),
            color: widget.color,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (!_isRecording)
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        isVideoRecorded ? reTake() : Navigator.pop(context);
                      },
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text(
                          displayCancelorRetake,
                          style: TextStyle(
                              color: widget.iconColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ),
                if (!isVideoRecorded)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'VIDEO',
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(color: widget.iconColor, fontSize: 14.0),
                      ),
                      SizedBox(height: 10),
                      _isRecording
                          ? stopVideoButton()
                          : stopAndStartVideoButton(),
                    ],
                  ),
                if (!_isRecording)
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        isVideoRecorded ? uploadVideo() : displayNextQuestion();
                      },
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text(
                          displayNextQuestorUploadVideo,
                          style: TextStyle(
                            color: widget.iconColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget stopAndStartVideoButton() {
    IconData playOrPauseIcon = Icons.camera;
    return IconButton(
      onPressed: () {
        _start = 30;
        isVideoRecording = true;
        if (_isRecording == false) {
          startTimer();
          controller!.startVideoRecording();
          _isRecording = true;
          playOrPauseIcon = Icons.stop_circle;
        } else {
          controller!.stopVideoRecording().then((value) {
            // videoUrl = value;
            fetchVideoFilePath(value);
            widget.onVideoRecorded!(value);
          });
          _isRecording = false;
          playOrPauseIcon = Icons.play_circle;
        }
        //   setState(() {});
      },
      icon: Icon(
        playOrPauseIcon,
        color: Colors.white, // Changed to red
        size: 50,
      ),
    );
  }

  Widget stopVideoButton() {
    return IconButton(
      icon: Icon(
        isVideoRecorded ? Icons.play_arrow : Icons.stop_circle,
        color: Colors.red, // Changed to red
        size: 50,
      ),
      onPressed: () {
        isVideoRecording = false;
        displayCancelorRetake = "Retake";
        displayNextQuestorUploadVideo = 'Upload\nVideo';
        if (_isRecording == false) {
          startTimer();
          controller!.startVideoRecording();
          _isRecording = true;
        } else {
          controller!.stopVideoRecording().then((value) {
            fetchVideoFilePath(value);
          });
          _isRecording = false;
        }
      },
    );
  }

  Future<void> fetchVideoFilePath(XFile value) async {
    // Simulate a delay or actual file fetching logic
    //   await Future.delayed(Duration(seconds: 1));
    videoUrl = value;
    isVideoRecorded = true;
    final path = videoUrl?.path;
    print("path $path");
    getVideoDuration(path!);
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 00) {
          setState(() {
            _isRecording = false;
            timer.cancel();
          });
        } else {
          if (mounted) {
            setState(() {
              _start--;
            });
          }
        }
      },
    );
  }

  Future<void> getVideoDuration(String videoPath) async {
    VideoPlayerController controller = VideoPlayerController.network(videoPath);
    await controller.initialize();
    Duration duration = controller.value.duration;
    len = duration.inSeconds.toString();
    controller.dispose();
  }

  Future<void> uploadVideo() async {
    var currentId = _guidecontroller?.currentId =
        _guidecontroller?.quesList[_guidecontroller!.idx.value].id ??
            "1308b0cb-5921-420c-8bec-a3a26206c9b5";
    var currentQuestion = _guidecontroller?.currentQuestion =
        _guidecontroller?.quesList[_guidecontroller!.idx.value].question ??
            "Interview Question";

    final path = videoUrl?.path;
    if (path!.contains(".mp4")) {
      setState(() {
        isStartRecordingBtnEnabled = false;
        isStopRecordingBtnEnabled = false;
        isUploadRecordingBtnEnabled = true;
      });

      // Show loading indicator
      EasyLoading.show(status: 'Uploading...please wait');

      try {
        thumbnailPath = await VideoThumbnail.thumbnailFile(
          video: path,
          imageFormat: myVideoThumbNail.ImageFormat.PNG,
          maxHeight: 200,
          quality: 50,
        );

        HttpResponse httpResponse = await UserRepo().uploadVideos(
            currentQuestion!, len, thumbnailPath, path, currentId!);

        if (httpResponse.statusCode == 200 || httpResponse.statusCode == 201) {
          // Dismiss loading indicator
          EasyLoading.dismiss();

          Fluttertoast.showToast(
              msg: "Video Uploaded Successfully!!!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);

          setState(() {
            var value = _guidecontroller?.changeListIndextoNext();
            updateText(value!);
            displayCancelorRetake = "Cancel";
            displayNextQuestorUploadVideo = 'Next\nQuestion';
            _speakQuestion();
            _start = 30;
            videoUrl = null;
            isVideoRecording = false;
            _isRecording = false;
            isVideoRecorded = false;
            isStartRecordingBtnEnabled = false;
            isStopRecordingBtnEnabled = false;
            isUploadRecordingBtnEnabled = false;
          });
        } else {
          // Dismiss loading indicator and show error
          EasyLoading.dismiss();
          Fluttertoast.showToast(
              msg: "Something went wrong!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      } catch (e) {
        // Dismiss loading indicator and show error
        EasyLoading.dismiss();
        Fluttertoast.showToast(
            msg: "Something went wrong!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
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
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoPath;

  VideoPlayerWidget({required this.videoPath});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isPlaying = false;
  String filePath = "";

  @override
  void initState() {
    super.initState();

    filePath = widget.videoPath;

    _videoPlayerController = VideoPlayerController.file(
      File(filePath),
    )..initialize().then((_) {
        setState(() {});
      }).catchError((error) {
        print('Error initializing video player: $error');
      });

    _videoPlayerController.addListener(() {
      setState(() {
        _isPlaying = _videoPlayerController.value.isPlaying;
      });
    });
  }

  Future<void> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    setState(() {
      filePath = directory.path;
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _videoPlayerController.value.isInitialized
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    _isPlaying
                        ? _videoPlayerController.pause()
                        : _videoPlayerController.play();
                  });
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: _videoPlayerController.value.aspectRatio,
                      child: VideoPlayer(_videoPlayerController),
                    ),
                    if (!_isPlaying)
                      Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 100.0,
                      ),
                  ],
                ),
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
