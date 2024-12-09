import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;
import 'package:onboarding_app/widgets/custom_drawer.dart';

class ListeningPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IELTS Listening Prep',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ListeningPrepScreen(),
    );
  }
}

class ListeningPrepScreen extends StatefulWidget {
  @override
  _ListeningPrepScreenState createState() => _ListeningPrepScreenState();
}

class _ListeningPrepScreenState extends State<ListeningPrepScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  bool isMockTestStarted = false; // Flag to check if mock test is started
  String currentQuestion = '';
  String audioUrl = '';
  List<dynamic> questions = [];
  final List<String> tips = [
    'Listen for keywords and phrases.',
    'Practice summarizing what you hear.',
    'Focus on the speaker’s tone and emotion.',
    'Take notes while listening.',
    'Don’t be afraid to ask for clarification if needed.'
  ];

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    final response = await http.get(Uri.parse('https://api.example.com/questions'));
    if (response.statusCode == 200) {
      questions = json.decode(response.body);
      _getRandomQuestion();
    } else {
      throw Exception('Failed to load questions');
    }
  }

  void _getRandomQuestion() {
    final random = Random();
    setState(() {
      currentQuestion = questions[random.nextInt(questions.length)]['question'];
      audioUrl = 'https://api.example.com/text-to-speech?text=${Uri.encodeComponent(currentQuestion)}';
    });
  }

  Future<void> _playAudio() async {
    try {
      await _audioPlayer.setUrl(audioUrl);
      await _audioPlayer.play();
      setState(() {
        isPlaying = true;
      });
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  Future<void> _stopAudio() async {
    await _audioPlayer.pause();
    setState(() {
      isPlaying = false;
    });
  }

  void _startMockTest() {
    setState(() {
      isMockTestStarted = true; // Set the flag to true to show the mock test UI
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

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
        title: Text('IELTS Listening Prep'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isMockTestStarted ? _buildMockTestView() : _buildTipsView(),
      ),
    );
  }

  Widget _buildTipsView() {
    return Column(
      children: [
        Center(
          child: Text(
            'Listening Tips',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 20),
        Expanded(
          child: ListView(
            children: tips.map((tip) => TipCard(tipText: tip)).toList(),
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _startMockTest,
          child: Text('Start Mock Test'),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMockTestView() {
    return Column(
      children: [
        Center(
          child: Text(
            'Listening Practice ',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 20),
        Text(
          currentQuestion,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: isPlaying ? _stopAudio : _playAudio,
          child: Text(isPlaying ? 'Stop Audio' : 'Play Audio'),
        ),
        SizedBox(height: 20),
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Your Answer',
          ),
          maxLines: 3,
        ),
      ],
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





// import 'dart:convert';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:http/http.dart' as http;
// import 'package:onboarding_app/widgets/custom_drawer.dart';
//
// class ListeningPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'IELTS Listening Prep',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: ListeningPrepScreen(),
//     );
//   }
// }
//
// class ListeningPrepScreen extends StatefulWidget {
//   @override
//   _ListeningPrepScreenState createState() => _ListeningPrepScreenState();
// }
//
// class _ListeningPrepScreenState extends State<ListeningPrepScreen> {
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   bool isPlaying = false;
//   bool isMockTestStarted = false; // Flag to check if mock test is started
//   String currentQuestion = '';
//   String audioUrl = '';
//   List<dynamic> questions = [];
//   final List<String> tips = [
//     'Listen for keywords and phrases.',
//     'Practice summarizing what you hear.',
//     'Focus on the speaker’s tone and emotion.',
//     'Take notes while listening.',
//     'Don’t be afraid to ask for clarification if needed.'
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchQuestions();
//   }
//
//   Future<void> _fetchQuestions() async {
//     // Replace with your actual API endpoint
//     final response = await http.get(Uri.parse('https://api.example.com/questions'));
//     if (response.statusCode == 200) {
//       questions = json.decode(response.body);
//       _getRandomQuestion();
//     } else {
//       throw Exception('Failed to load questions');
//     }
//   }
//
//   void _getRandomQuestion() {
//     final random = Random();
//     setState(() {
//       currentQuestion = questions[random.nextInt(questions.length)]['question'];
//       audioUrl = 'https://api.example.com/text-to-speech?text=${Uri.encodeComponent(currentQuestion)}';
//     });
//   }
//
//   void _playAudio() async {
//     await _audioPlayer.setUrl(audioUrl);
//     await _audioPlayer.resume();
//     setState(() {
//       isPlaying = true;
//     });
//   }
//
//   void _stopAudio() async {
//     await _audioPlayer.pause();
//     setState(() {
//       isPlaying = false;
//     });
//   }
//
//   void _startMockTest() {
//     setState(() {
//       isMockTestStarted = true; // Set the flag to true to show the mock test UI
//     });
//   }
//
//   @override
//   void dispose() {
//     _audioPlayer.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => CustomDrawer()),
//             );
//           },
//         ),
//         title: Text('IELTS Listening Prep'),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: isMockTestStarted ? _buildMockTestView() : _buildTipsView(),
//       ),
//     );
//   }
//
//   Widget _buildTipsView() {
//     return Column(
//       children: [
//         Center(
//           child: Text(
//             'Listening Tips',
//             style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//           ),
//         ),
//         SizedBox(height: 20),
//         Expanded(
//           child: ListView(
//             children: tips.map((tip) => TipCard(tipText: tip)).toList(),
//           ),
//         ),
//         SizedBox(height: 20),
//         ElevatedButton(
//           onPressed: _startMockTest,
//           child: Text('Start Mock Test'),
//           style: ElevatedButton.styleFrom(
//             padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildMockTestView() {
//     return Column(
//       children: [
//         Center(
//           child: Text(
//             'Listening Practice ',
//             style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//           ),
//         ),
//         SizedBox(height: 20),
//         Text(
//           currentQuestion,
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           textAlign: TextAlign.center,
//         ),
//         SizedBox(height: 20),
//         ElevatedButton(
//           onPressed: isPlaying ? _stopAudio : _playAudio,
//           child: Text(isPlaying ? 'Stop Audio' : 'Play Audio'),
//         ),
//         SizedBox(height: 20),
//         TextField(
//           decoration: InputDecoration(
//             border: OutlineInputBorder(),
//             labelText: 'Your Answer',
//           ),
//           maxLines: 3,
//         ),
//       ],
//     );
//   }
// }
//
// class TipCard extends StatelessWidget {
//   final String tipText;
//
//   const TipCard({required this.tipText});
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12.0),
//       ),
//       elevation: 4,
//       shadowColor: Colors.grey.withOpacity(0.4),
//       margin: EdgeInsets.symmetric(vertical: 8.0),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Icon(Icons.check_circle, color: Colors.blue),
//             SizedBox(width: 10),
//             Expanded(
//               child: Text(
//                 tipText,
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.black87,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class MockTestScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Mock Test'),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Text(
//           'Mock Test Screen',
//           style: TextStyle(fontSize: 24),
//         ),
//       ),
//     );
//   }
// }