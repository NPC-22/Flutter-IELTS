import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:onboarding_app/widgets/custom_drawer.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import 'dart:math';

class IeltsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IELTS Speaking Prep',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SpeakingPrepScreen(),
    );
  }
}

class SpeakingPrepScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => CustomDrawer()),
            );
          },
        ),

        title: Text('IELTS Speaking Prep'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Image.asset(
                'assets/ielts.png',
                height: 100,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'IELTS Speaking Tips',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  TipCard(tipText: 'Look directly into the camera.'),
                  TipCard(tipText: 'Read each question carefully before answering.'),
                  TipCard(tipText: 'Keep your tone natural and conversational.'),
                  TipCard(tipText: 'Use a range of vocabulary to express yourself.'),
                  TipCard(tipText: 'Organize your answers with clear structure.'),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Navigate to Mock Test Screen
                final cameras = await availableCameras();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MockTestScreen(camera: cameras.first),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                child: Text(
                  'Start Mock Test',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TipCard extends StatelessWidget {
  final String tipText;

  const TipCard({required this.tipText});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4,
      shadowColor: Colors.grey.withOpacity(0.4),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.check_circle, color: Colors.blue),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                tipText,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MockTestScreen extends StatefulWidget {
  final CameraDescription camera;

  MockTestScreen({required this.camera});

  @override
  _MockTestScreenState createState() => _MockTestScreenState();
}

class _MockTestScreenState extends State<MockTestScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late VideoPlayerController? _videoController;
  bool isRecording = false;
  bool isVideoReady = false;
  String randomQuestion = '';
  final List<String> questions = [
    'Describe a memorable trip you took.',
    'What are the qualities of a good friend?',
    'How do you manage your time effectively?',
    'What is your favorite type of music and why?',
    'Describe a skill you want to learn.'
  ];
  Timer? _timer;
  int _seconds = 60;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
    getRandomQuestion();
  }

  @override
  void dispose() {
    _controller.dispose();
    _videoController?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void getRandomQuestion() {
    final random = Random();
    setState(() {
      randomQuestion = questions[random.nextInt(questions.length)];
    });
  }

  void startRecording() async {
    await _initializeControllerFuture;
    setState(() {
      isRecording = true;
      _seconds = 60;
      _startTimer();
    });
    await _controller.startVideoRecording();
  }

  void stopRecording() async {
    final file = await _controller.stopVideoRecording();
    setState(() {
      isRecording = false;
      isVideoReady = true;
      _videoController = VideoPlayerController.file(file as File);
    });
    await _videoController?.initialize();
    _videoController?.play();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        setState(() {
          _seconds--;
        });
      } else {
        stopRecording();
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mock Test'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              randomQuestion,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Text('Time Remaining: $_seconds seconds', style: TextStyle(fontSize: 16)),
          Expanded(
            child: FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(_controller);
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          SizedBox(height: 20),
          isVideoReady
              ? VideoPlayer(_videoController!)
              : ElevatedButton(
            onPressed: isRecording ? stopRecording : startRecording,
            child: Text(isRecording ? 'Stop Recording' : 'Start Recording'),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}