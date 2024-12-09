import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:onboarding_app/widgets/custom_drawer.dart';

class WritingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IELTS Writing Prep',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WritingPrepScreen(),
    );
  }
}

class WritingPrepScreen extends StatefulWidget {
  @override
  _WritingPrepScreenState createState() => _WritingPrepScreenState();
}

class _WritingPrepScreenState extends State<WritingPrepScreen> {
  String writingPrompt = '';
  bool isWritingTestStarted = false;

  final List<String> tips = [
    'Understand the task requirements.',
    'Plan your essay structure before writing.',
    'Use a variety of vocabulary and sentence structures.',
    'Make sure to answer all parts of the question.',
    'Proofread your work for grammar and spelling mistakes.'
  ];

  @override
  void initState() {
    super.initState();
    _fetchWritingData();
  }

  Future<void> _fetchWritingData() async {
    // Replace with your actual API endpoint
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));

    if (response.statusCode == 200) {
      setState(() {
        writingPrompt = json.decode(response.body)['body'];
      });
    } else {
      throw Exception('Failed to load writing data');
    }
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
        title: Text('IELTS Writing Prep'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isWritingTestStarted ? _buildWritingTestView() : _buildWritingTipsView(),
      ),
    );
  }

  Widget _buildWritingTipsView() {
    return Column(
      children: [
        Center(
          child: Text(
            'Writing Tips',
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
          onPressed: () {
            setState(() {
              isWritingTestStarted = true;
            });
          },
          child: Text('Start Writing Test'),
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

  Widget _buildWritingTestView() {
    return Column(
      children: [
        Center(
          child: Text(
            'Writing Prompt',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 20),
        Text(
          writingPrompt,
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 20),
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Your Response',
          ),
          maxLines: 10,
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