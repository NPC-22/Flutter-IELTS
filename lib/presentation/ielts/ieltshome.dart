import 'package:flutter/material.dart';
import 'package:onboarding_app/presentation/ielts/ielts.dart';
import 'package:onboarding_app/presentation/ielts/listen.dart';
import 'package:onboarding_app/presentation/ielts/read.dart';
import 'package:onboarding_app/presentation/ielts/writing.dart';

class IeltsHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("IELTS Exam Prep"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to the previous screen
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "What would you like to practice today?",
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 40),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1, // Ensures all cards are square
                padding: EdgeInsets.all(16.0),
                children: <Widget>[
                  _buildOptionCard(
                    icon: Icons.perm_camera_mic_sharp,
                    title: "Look into camera and Speak",
                    subtitle: "Speaking section",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => IeltsPage()),
                      );
                    },
                  ),
                  _buildOptionCard(
                    icon: Icons.headset,
                    title: "Listen to audio and answer questions",
                    subtitle: "Listening section",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ListeningPage()),
                      );// Navigate to the listening practice screen
                    },
                  ),
                  _buildOptionCard(
                    icon: Icons.book,
                    title: "Read a passage and answer questions",
                    subtitle: "Reading section",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ReadingPage()),
                      );// Navigate to the reading practice screen
                    },
                  ),
                  _buildOptionCard(
                    icon: Icons.edit,
                    title: "Write an essay",
                    subtitle: "Writing section",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WritingPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icon, size: 40),
              SizedBox(height: 10),
              Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Text(subtitle, style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}