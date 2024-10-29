import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../network/models/HttpReposonceHandler.dart';
import '../../network/models/PieChartModel.dart';
import '../../network/repository/auth/auth_repo.dart';
import '../guide/guidepage2/guidepage2.dart';

class PieChartDisplay extends StatefulWidget {
  PieChartDisplay({Key? key});

  @override
  PieChartDisplayState createState() => PieChartDisplayState();
}

class PieChartDisplayState extends State<PieChartDisplay> {
  var isLoading = false.obs;
  UserRepo userRepo = UserRepo();
  late HttpResponse httpResponse;
  var emotionValue = 0.00;
  var contentValue = 0.00;
  var verbalValue = 0.00;
  var postureValue = 0.00;
  var scoreValue = 0.00;
  bool isEmptyData = true;

  PieChartModel piechartScoresModel = PieChartModel();

  @override
  void initState() {
    super.initState();
    fetchPieChartData();
  }

  void fetchPieChartData() async {
    HttpResponse httpResponse = await userRepo.getVideosScore();
    piechartScoresModel = PieChartModel.fromJson(httpResponse.data);
    setState(() {
      scoreValue =
          double.parse(piechartScoresModel.data!.score!.toStringAsFixed(2))!;
      if (httpResponse.data.isEmpty || scoreValue == 0.00 || scoreValue == 0) {
        isEmptyData = true;
      } else {
        isEmptyData = false;
        emotionValue =
            double.parse(piechartScoresModel.data!.emotion!.toStringAsFixed(2));
        contentValue =
            double.parse(piechartScoresModel.data!.content!.toStringAsFixed(2));
        verbalValue =
            double.parse(piechartScoresModel.data!.verbal!.toStringAsFixed(2));
        postureValue =
            double.parse(piechartScoresModel.data!.posture!.toStringAsFixed(2));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Interview Score',
              style: const TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.w500)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: isEmptyData
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.mic, size: 100, color: Colors.grey),
                    SizedBox(height: 20),
                    Text(
                      'Start Recording and\nComeback to Check your Scores',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => guidepage2()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      child: Text(
                        'Start Recording',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 300,
                      height: 300,
                      padding: EdgeInsets.all(16),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          PieChart(
                            PieChartData(
                              sections: [
                                PieChartSectionData(
                                  color: Colors.blueGrey,
                                  value: emotionValue,
                                  title: emotionValue.toString(),
                                  radius: 50,
                                  titleStyle: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                PieChartSectionData(
                                  color: Colors.orangeAccent,
                                  value: contentValue,
                                  title: contentValue.toString(),
                                  radius: 50,
                                  titleStyle: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                PieChartSectionData(
                                  color: Colors.green,
                                  value: verbalValue,
                                  title: verbalValue.toString(),
                                  radius: 50,
                                  titleStyle: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                PieChartSectionData(
                                  color: Colors.redAccent,
                                  value: postureValue,
                                  title: postureValue.toString(),
                                  radius: 50,
                                  titleStyle: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                              borderData: FlBorderData(show: false),
                              sectionsSpace: 2,
                              centerSpaceRadius: 60,
                            ),
                          ),
                          Positioned(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Score : $scoreValue',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 5),
                        Container(
                          width: 20,
                          height: 20,
                          color: Colors.blueGrey,
                        ),
                        Text(
                          "Emotion",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ), // Space between boxes
                        Container(
                          width: 20,
                          height: 20,
                          color: Colors.orangeAccent,
                        ),
                        Text(
                          "Content",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ), // Space between boxes
                        Container(
                          width: 20,
                          height: 20,
                          color: Colors.green,
                        ),
                        Text(
                          "Verbal",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ), // Space between boxes
                        Container(
                          width: 20,
                          height: 20,
                          color: Colors.redAccent,
                        ),
                        Text(
                          "Posture",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ), // Space between boxes
                        SizedBox(width: 5),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
