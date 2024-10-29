/*import 'package:flutter/material.dart';
import 'package:onboarding_app/presentation/guide/guide.dart';

class Home extends StatefulWidget {
  const Home({Key? key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Disable the back button press
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Text('Cuvasol Home Page'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display Image
              Image.asset(
                'assets/images/Telecommuting.png', // Replace with your image path
                width: 250,
                height: 250,
              ),

              // Display Text
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Cuvasol will help you to ace your virtual interview',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black, // You can adjust the text color here
                  ),
                ),
              ),

              // Display Button
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Guide()),
                        );
                        print('Continue button pressed');
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange,
                        onPrimary: Colors.white,
                      ),
                      child: const Text('Continue'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onboarding_app/presentation/dashboard/dashboard_screen.dart';
import 'package:onboarding_app/presentation/guide/guide.dart';

import '../../routes/app_pages.dart';

class Home extends StatefulWidget {
  const Home({Key? key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Cuvasol Home Page'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.offAllNamed(Routes.DASHBOARD);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/Telecommuting.png',
              width: 250,
              height: 250,
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Cuvasol will help you to ace your virtual interview',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Get.to(Guide());
                  print('Continue button pressed');
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.orange,
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  textStyle: TextStyle(fontSize: 16),
                ),
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}
