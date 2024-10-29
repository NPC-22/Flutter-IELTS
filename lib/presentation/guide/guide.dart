/*import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:onboarding_app/controllers/GuideController/guide-controller.dart';
import 'package:onboarding_app/presentation/guide/guidepage2/guidepage2.dart';
import 'guidepage/guidepage.dart';
import 'guidepage2/guidepage2.dart';


class Guide extends StatelessWidget {

  Guide({super.key});

  final GuideController? _controller = Get.put(GuideController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            const Text(
              'Video Interviews tips:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.orange,
              ),
            ),
            SizedBox(height: 10),
            Image.asset(
              'assets/images/Telecommuting.png', // Replace with the path to your image asset
              height: 150, // Adjust the height as needed
              width: 300, // Adjust the width as needed
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildBulletPoint('Make sure you are comfortable using the software before the interview'),
                  buildBulletPoint('Dress professionally, use good body language, and smile'),
                  buildBulletPoint('Set up your mobile/computer in a quiet space with a clean, professional background (i.e., clear wall)'),
                  buildBulletPoint('Be confident'),
                  buildBulletPoint('Give suitable answers'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: ()async{
                      await _controller?.getUserAgent();
                      if(_controller?.httpResponse.statusCode == 200 || _controller?.httpResponse.statusCode == 201){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GuidePage()),
                      );}
                      else{
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => guidepage2()),

                        //ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Server issues, Check again later')));
                     );}
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange,
                      onPrimary: Colors.white,
                    ),
                    child: Text('Take a Trail Interview'),
                  ),
                  SizedBox(height: 20)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('•', style: TextStyle(color: Colors.orange)),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 18, color: Colors.orange),
            ),
          ),
        ],
      ),
    );
  }
}

 */
/*import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onboarding_app/controllers/GuideController/guide-controller.dart';
import '../dashboard/dashboard_screen.dart';
import 'guidepage/guidepage.dart';
import 'guidepage2/guidepage2.dart';

class Guide extends StatelessWidget {
  Guide({Key? key});

  final GuideController? _controller = Get.put(GuideController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to black
      appBar: AppBar(
        backgroundColor: Colors.white, // Set app bar background color to black
        title: const Text('Tips and Tricks'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.offAll(DashboardScreen());
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              const Text(
                'Video Interviews tips:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.orange,
                ),
              ),
              SizedBox(height: 10),
              Image.asset(
                'assets/images/Telecommuting.png',
                height: 150,
                width: 300,
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    buildBulletPoint('Make sure you are comfortable using the software before the interview'),
                    buildBulletPoint('Dress professionally, use good body language, and smile'),
                    buildBulletPoint('Set up your mobile/computer in a quiet space with a clean, professional background (i.e., clear wall)'),
                    buildBulletPoint('Be confident'),
                    buildBulletPoint('Give suitable answers'),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        await _controller?.getUserAgent();
                        if (_controller?.httpResponse.statusCode == 200 ||
                            _controller?.httpResponse.statusCode == 201) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => GuidePage()),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => guidepage2()),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange,
                        onPrimary: Colors.white,
                      ),
                      child: Text('Take a Trial Interview'),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('•', style: TextStyle(color: Colors.orange)),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 18, color: Colors.orange),
            ),
          ),
        ],
      ),
    );
  }
}

 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onboarding_app/controllers/GuideController/guide-controller.dart';

import '../../routes/app_pages.dart';
import 'guidepage/guidepage.dart';
import 'guidepage2/guidepage2.dart';

class Guide extends StatelessWidget {
  Guide({Key? key});

  final GuideController? _controller = Get.put(GuideController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to black
      appBar: AppBar(
        backgroundColor: Colors.white, // Set app bar background color to black
        title: Text(
          'Tips and Tricks',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Set the font weight to bold
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.offAllNamed(Routes.DASHBOARD);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              const Text(
                'Video Interviews tips:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.orange,
                ),
              ),
              SizedBox(height: 10),
              Image.asset(
                'assets/images/Telecommuting.png',
                height: 150,
                width: 300,
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    buildBulletPoint(
                        'Make sure you are comfortable using the software before the interview'),
                    buildBulletPoint(
                        'Dress professionally, use good body language, and smile'),
                    buildBulletPoint(
                        'Set up your mobile/computer in a quiet space with a clean, professional background (i.e., clear wall)'),
                    buildBulletPoint('Be confident'),
                    buildBulletPoint('Give suitable answers'),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        await _controller?.getUserAgent();
                        if (_controller?.httpResponse.statusCode == 200 ||
                            _controller?.httpResponse.statusCode == 201) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GuidePage()),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => guidepage2()),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.orange,
                        backgroundColor: Colors.white,
                      ),
                      child: Text('Take a Trial Interview'),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('•', style: TextStyle(color: Colors.black)),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
