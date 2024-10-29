import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onboarding_app/controllers/drawer_navigation-controller.dart';
import 'package:onboarding_app/controllers/loading_controller.dart';
import 'package:onboarding_app/flutter_camera.dart';

import '../../../controllers/GuideController/guide-controller.dart';
import '../../../controllers/bottom_navigation-controller.dart';
import '../../cameraPage/camera_page.dart';

class guidepage2 extends StatelessWidget {
  final DrawerNavigationController _controller_ =
      Get.put(DrawerNavigationController());
  final GuideController? _controller = Get.put(GuideController());
  final BottomNavController bottomNavController =
      Get.put(BottomNavController());
  final LoadingController loadingController = Get.put(LoadingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Video Interview'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/Company_interview.png',
              height: 250, // Adjust the height as needed
            ),
            SizedBox(height: 20),
            GetBuilder<DrawerNavigationController>(
              builder: (_controller_) {
                if (_controller_.userProfile.data?.name != null) {
                  return Text(
                    'Welcome ${_controller_.userProfile.data!.name!.capitalizeFirst}\n ',
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
            SizedBox(height: 20),
            const Text(
              'Feel the Virtual interview experience & Ace your Interviews',
              style: TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            const Text(
              ' \n\n Record and submit your video',
              style: TextStyle(
                fontSize: 22,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Align(
          alignment: Alignment.bottomRight,
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: EdgeInsets.all(16),
            ),
            onPressed: () async {
              // Add functionality for the button click
              await _controller?.getInterviewQuestions();
              _controller?.currentId = _controller?.quesList[_controller!.idx.value].id ??
                  "1308b0cb-5921-420c-8bec-a3a26206c9b5";
              _controller?.currentQuestion = _controller?.quesList[_controller!.idx.value].question ??
                  "Interview Question";
             // Navigator.of(context).pop();
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => CameraPage(question: _controller!.currentQuestion),
                ),
              );
             /* Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FlutterCamera(color: Colors.grey[850]),
                ),
              );*/
              /* await _controller?.getInterviewQuestions();
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return StatefulBuilder(
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
                            _controller?.currentId = _controller?.quesList[_controller!.idx.value].id ??
                                "1308b0cb-5921-420c-8bec-a3a26206c9b5";
                            _controller?.currentQuestion = _controller?.quesList[_controller!.idx.value].question ??
                                "Interview Question";
                            Navigator.of(context).pop();
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => CameraPage(question: _controller!.currentQuestion),
                              ),
                            );
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
                  );
                },
              );*/
            },
            child: const Text(
              'Next',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/*import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:onboarding_app/controllers/drawer_navigation-controller.dart';
import 'package:onboarding_app/network/models/userprofile_model.dart';
import '../../../controllers/GuideController/guide-controller.dart';
import '../../../controllers/bottom_navigation-controller.dart';
import '../../cameraPage/camera_page.dart';


class guidepage2 extends StatelessWidget {
  final DrawerNavigationController _controller_ = Get.put(DrawerNavigationController());
  final GuideController? _controller = Get.put(GuideController());
  final BottomNavController bottomNavController = Get.put(BottomNavController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Video Interview'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/Company_interview.png',
              height: 250, // Adjust the height as needed
            ),
            SizedBox(height: 20),
            _controller_.userProfile.data != null
                ? Text(
              'Welcome ${_controller_.userProfile.data?.name?.capitalizeFirst}!\n ',
              style: const TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            )
                : CircularProgressIndicator(),
          ],
        ),
      ),

      SizedBox(height: 20),
            const Text(
              'Feel the Virtual interview experience & Ace your Interviews',
              style: TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 20),
            const Text(
              ' \n\n Record and submit your video',
              style: TextStyle(
                fontSize: 22,
                color: Colors.black,
              ),
            ),
          ],
        ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Align(
          alignment: Alignment.bottomRight,
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: EdgeInsets.all(16),
            ),
            onPressed: () async{
              // Add functionality for the button click
              await _controller?.getInterviewQuestions();
              showDialog(context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context){
                    return StatefulBuilder(
                      builder: (BuildContext context, setState) => AlertDialog(
                        title: Obx(() => Text(
                          _controller!.quesList[_controller!.idx.value].question.toString(),
                          style: const TextStyle(
                              color: Colors.black
                          ),
                        ),
                        ),
                        actions: [
                          TextButton(onPressed: (){
                            _controller?.changeListIndex();
                          },
                            child: const Text("Change Question",
                              style: TextStyle(
                                  color: Colors.orange
                              ),
                            ),
                          ),
                          TextButton(onPressed: (){
                            _controller?.currentId = _controller?.quesList[_controller!.idx.value].id ?? "1308b0cb-5921-420c-8bec-a3a26206c9b5";
                            _controller?.currentQuestion = _controller?.quesList[_controller!.idx.value].question ?? "Interview Question";
                            Navigator.of(context).pop();
                            Navigator.push(context, CupertinoPageRoute(builder:(context) => CameraPage(question: _controller!.currentQuestion,)));},
                            child: const Text("Go",
                              style: TextStyle(
                                  color: Colors.orange
                              ),),
                          ),
                          TextButton(onPressed: (){
                            Navigator.of(context).pop();
                            //Navigator.of(context).pop();
                            //bottomNavController.currentIndex = 1.obs;
                          },
                            child: const Text("Cancel",
                              style: TextStyle(
                                  color: Colors.orange
                              ),),)
                        ],
                      ),
                    );
                  });
            },
            child: const Text(
              'Next',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}


 */

/*import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:onboarding_app/controllers/drawer_navigation-controller.dart';
import 'package:onboarding_app/network/models/userprofile_model.dart';
import '../../../controllers/GuideController/guide-controller.dart';
import '../../../controllers/bottom_navigation-controller.dart';
import '../../cameraPage/camera_page.dart';

class guidepage2 extends StatelessWidget {
  final DrawerNavigationController _controller_ = Get.put(DrawerNavigationController());
  final GuideController _controller = Get.put(GuideController());
  final BottomNavController bottomNavController = Get.put(BottomNavController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Video Interview'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/Company_interview.png',
              height: 250,
            ),
            SizedBox(height: 20),
            FutureBuilder(
              future: _controller_.getUserProfile(), // Fetch user profile asynchronously
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // Show loading indicator while fetching data
                } else {
                  return Text(
                    'Welcome ${_controller_.userProfile.data?.name?.capitalizeFirst ?? ''}!\n',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  );
                }
              },
            ),
            SizedBox(height: 20),
            const Text(
              'Feel the Virtual interview experience & Ace your Interviews',
              style: TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            const Text(
              ' \n\n Record and submit your video',
              style: TextStyle(
                fontSize: 22,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Align(
          alignment: Alignment.bottomRight,
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: EdgeInsets.all(16),
            ),
            onPressed: () async {
              await _controller?.getInterviewQuestions();
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return StatefulBuilder(
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
                            _controller?.currentId = _controller?.quesList[_controller!.idx.value].id ?? "1308b0cb-5921-420c-8bec-a3a26206c9b5";
                            _controller?.currentQuestion = _controller?.quesList[_controller.idx.value].question ?? "Interview Question";
                            Navigator.of(context).pop();
                            Navigator.push(context, CupertinoPageRoute(builder:(context) => CameraPage(question: _controller!.currentQuestion,)));
                          },
                          child: const Text(
                            "Go",
                            style: TextStyle(color: Colors.orange),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "Cancel",
                            style: TextStyle(color: Colors.orange),
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            },
            child: const Text(
              'Next',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

 */
/*import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onboarding_app/controllers/drawer_navigation-controller.dart';
import '../../../controllers/GuideController/guide-controller.dart';
import '../../../controllers/bottom_navigation-controller.dart';
import '../../cameraPage/camera_page.dart';

class guidepage2 extends StatelessWidget {
  final DrawerNavigationController _controller_ =
  Get.put(DrawerNavigationController());
  final GuideController? _controller = Get.put(GuideController());
  final BottomNavController bottomNavController =
  Get.put(BottomNavController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Video Interview'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/Company_interview.png',
              height: 250, // Adjust the height as needed
            ),
            SizedBox(height: 20),
            _buildUserProfileWidget(), // Call a method to build the user profile widget
            SizedBox(height: 20),
            const Text(
              'Feel the Virtual interview experience & Ace your Interviews',
              style: TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            const Text(
              ' \n\n Record and submit your video',
              style: TextStyle(
                fontSize: 22,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Align(
          alignment: Alignment.bottomRight,
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: EdgeInsets.all(16),
            ),
            onPressed: () async {
              // Add functionality for the button click
              await _controller?.getInterviewQuestions();
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (BuildContext context, setState) => AlertDialog(
                      title: Obx(
                            () => Text(
                          _controller!.quesList[_controller!.idx.value]
                              .question
                              .toString(),
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
                                _controller
                                    ?.quesList[_controller!.idx.value].id ??
                                    "1308b0cb-5921-420c-8bec-a3a26206c9b5";
                            _controller?.currentQuestion =
                                _controller
                                    ?.quesList[_controller!.idx.value]
                                    .question ??
                                    "Interview Question";
                            Navigator.of(context).pop();
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => CameraPage(
                                  question: _controller!.currentQuestion,
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            "Go",
                            style: TextStyle(color: Colors.orange),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "Cancel",
                            style: TextStyle(color: Colors.orange),
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            },
            child: const Text(
              'Next',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserProfileWidget() {
    return Obx(() {
      if (_controller_.userProfile.data != null) {
        return Text(
          'Welcome ${_controller_.userProfile.data?.name?.capitalizeFirst}!\n ',
          style: const TextStyle(
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        );
      } else {
        return CircularProgressIndicator(); // Display circular progress indicator while loading
      }
    });
  }
}

 */

/*import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onboarding_app/controllers/drawer_navigation-controller.dart';
import 'package:onboarding_app/network/models/userprofile_model.dart';
import '../../../controllers/GuideController/guide-controller.dart';
import '../../../controllers/bottom_navigation-controller.dart';
import '../../cameraPage/camera_page.dart';
import 'package:onboarding_app/network/models/userprofile_model.dart';
import 'userprofile_model.dart';



class guidepage2 extends StatelessWidget {
  final DrawerNavigationController _controller_ =
  Get.put(DrawerNavigationController());
  final GuideController? _controller = Get.put(GuideController());
  final BottomNavController bottomNavController =
  Get.put(BottomNavController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Video Interview'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/Company_interview.png',
              height: 250, // Adjust the height as needed
            ),
            SizedBox(height: 20),
            FutureBuilder(
              future: _controller_.getUserProfile(), // Assuming getUserProfile() fetches the user profile data
              builder: (context, AsyncSnapshot<UserProfileModel?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // Display a circular progress indicator while waiting for data
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Text(
                    'Welcome ${snapshot.data?.name?.capitalizeFirst}!\n ',
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  );
                }
              },
            ),
            SizedBox(height: 20),
            const Text(
              'Feel the Virtual interview experience & Ace your Interviews',
              style: TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            const Text(
              ' \n\n Record and submit your video',
              style: TextStyle(
                fontSize: 22,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Align(
          alignment: Alignment.bottomRight,
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: EdgeInsets.all(16),
            ),
            onPressed: () async {
              // Add functionality for the button click
              await _controller?.getInterviewQuestions();
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (BuildContext context, setState) => AlertDialog(
                      title: Obx(
                            () => Text(
                          _controller!.quesList[_controller!.idx.value]
                              .question
                              .toString(),
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
                            _controller?.currentId = _controller
                                ?.quesList[_controller!.idx.value].id ??
                                "1308b0cb-5921-420c-8bec-a3a26206c9b5";
                            _controller?.currentQuestion = _controller
                                ?.quesList[_controller!.idx.value]
                                .question ??
                                "Interview Question";
                            Navigator.of(context).pop();
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => CameraPage(
                                  question: _controller!.currentQuestion,
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            "Go",
                            style: TextStyle(color: Colors.orange),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "Cancel",
                            style: TextStyle(color: Colors.orange),
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            },
            child: const Text(
              'Next',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

 */

/*import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onboarding_app/controllers/drawer_navigation-controller.dart';
import 'package:onboarding_app/controllers/GuideController/guide-controller.dart';
import 'package:onboarding_app/controllers/bottom_navigation-controller.dart';
import '../../cameraPage/camera_page.dart';

class guidepage2 extends StatelessWidget {
  final DrawerNavigationController _drawerController = Get.put(DrawerNavigationController());
  final GuideController _guideController = Get.put(GuideController());
  final BottomNavController bottomNavController = Get.put(BottomNavController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Video Interview'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/Company_interview.png',
              height: 250,
            ),
            SizedBox(height: 20),
            FutureBuilder(
              future: _drawerController.getUserProfile(), // Fetch user profile asynchronously
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // Show loading indicator while fetching data
                } else {
                  return Text(
                    'Welcome ${_drawerController.userProfile.data?.name?.capitalizeFirst ?? ''}!\n',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  );
                }
              },
            ),
            SizedBox(height: 20),
            const Text(
              'Feel the Virtual interview experience & Ace your Interviews',
              style: TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            const Text(
              ' \n\n Record and submit your video',
              style: TextStyle(
                fontSize: 22,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Align(
          alignment: Alignment.bottomRight,
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: EdgeInsets.all(16),
            ),
            onPressed: () async {
              await _guideController.getInterviewQuestions();
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (BuildContext context, setState) => AlertDialog(
                      title: Obx(
                            () => Text(
                          _guideController.quesList[_guideController.idx.value].question.toString(),
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            _guideController.changeListIndex();
                          },
                          child: const Text(
                            "Change Question",
                            style: TextStyle(color: Colors.orange),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            _guideController.currentId = _guideController.quesList[_guideController.idx.value].id ?? "1308b0cb-5921-420c-8bec-a3a26206c9b5";
                            _guideController.currentQuestion = _guideController.quesList[_guideController.idx.value].question ?? "Interview Question";
                            Navigator.of(context).pop();
                            Navigator.push(context, CupertinoPageRoute(builder: (context) => CameraPage(question: _guideController.currentQuestion,)));
                          },
                          child: const Text(
                            "Go",
                            style: TextStyle(color: Colors.orange),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "Cancel",
                            style: TextStyle(color: Colors.orange),
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            },
            child: const Text(
              'Next',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}


 */

/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:onboarding_app/controllers/drawer_navigation-controller.dart';
import 'package:onboarding_app/network/models/userprofile_model.dart';
import '../../../controllers/GuideController/guide-controller.dart';
import '../../../controllers/bottom_navigation-controller.dart';
import '../../cameraPage/camera_page.dart';


class guidepage2 extends StatelessWidget {
  final DrawerNavigationController _controller_ = Get.put(DrawerNavigationController());
  final GuideController? _controller = Get.put(GuideController());
  final BottomNavController bottomNavController = Get.put(BottomNavController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Video Interview'),
      ),
      body:  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
             'assets/images/Company_interview.png',
              height: 250, // Adjust the height as needed
            ),
            SizedBox(height: 20),
              Text(
              'Welcome ${_controller_.userProfile.data?.name?.capitalizeFirst}!\n ',

              style: const TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 20),
              const Text(
              'Feel the Virtual interview experience & Ace your Interviews',
              style: TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 20),
             const Text(
              ' \n\n Record and submit your video',
              style: TextStyle(
                fontSize: 22,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Align(
          alignment: Alignment.bottomRight,
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: EdgeInsets.all(16),
            ),
            onPressed: () async{
              // Add functionality for the button click
              await _controller?.getInterviewQuestions();
              showDialog(context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context){
                    return StatefulBuilder(
                      builder: (BuildContext context, setState) => AlertDialog(
                        title: Obx(() => Text(
                          _controller!.quesList[_controller!.idx.value].question.toString(),
                          style: const TextStyle(
                              color: Colors.black
                          ),
                        ),
                        ),
                        actions: [
                          TextButton(onPressed: (){
                            _controller?.changeListIndex();
                          },
                            child: const Text("Change Question",
                              style: TextStyle(
                                  color: Colors.orange
                              ),
                            ),
                          ),
                          TextButton(onPressed: (){
                            _controller?.currentId = _controller?.quesList[_controller!.idx.value].id ?? "1308b0cb-5921-420c-8bec-a3a26206c9b5";
                            _controller?.currentQuestion = _controller?.quesList[_controller!.idx.value].question ?? "Interview Question";
                            Navigator.of(context).pop();
                            Navigator.push(context, CupertinoPageRoute(builder:(context) => CameraPage(question: _controller!.currentQuestion,)));},
                            child: const Text("Go",
                              style: TextStyle(
                                  color: Colors.orange
                              ),),
                          ),
                          TextButton(onPressed: (){
                            Navigator.of(context).pop();
                            //Navigator.of(context).pop();
                            //bottomNavController.currentIndex = 1.obs;
                            },
                            child: const Text("Cancel",
                              style: TextStyle(
                                  color: Colors.orange
                              ),),)
                        ],
                      ),
                    );
                  });
            },
            child: const Text(
              'Next',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

 */
