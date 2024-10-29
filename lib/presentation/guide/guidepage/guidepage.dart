import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../controllers/GuideController/guide-controller.dart';
import '../../../controllers/bottom_navigation-controller.dart';
import '../../../flutter_camera.dart';
import '../../../flutter_camera_latest.dart';
import '../../cameraPage/camera_page.dart';


class GuidePage extends StatelessWidget {
  //final DrawerNavigationController _controller = Get.put(DrawerNavigationController());
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
             'assets/images/Company_interview.png', // Replace with the path to your image asset
              height: 250, // Adjust the height as needed
            ),
            
            SizedBox(height: 20),
             RichText(
             textAlign: TextAlign.center,
              text: TextSpan(
               style: const TextStyle(
               fontSize: 24,
               color: Colors.black,
               fontWeight: FontWeight.bold,
               ),
               children: [
             TextSpan(
                text: 'Welcome ${_controller?.userAgent.data?.agentUserMap?[0].userName}!\n ',
               ),
             TextSpan(
                text: _controller?.userAgent.data!.agentUserMap?[0].companyName,
                style: TextStyle(
                color: Colors.blue[900], // Dark blue color for company name
               ),
              ),
             const TextSpan(
               text: ' has invited you to submit a video interview for the following job opening:',
                 ),
               ],
              ),
             ),


            
            SizedBox(height: 20),
             Text(
              'Role: ${_controller?.userAgent.data!.agentUserMap?[0].description}  \n\n Record and submit your video',
              style: const TextStyle(
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FlutterCameraLatest(color: Colors.grey[850]),
                ),
              );
            /*  showDialog(context: context,
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
                  });*/
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


