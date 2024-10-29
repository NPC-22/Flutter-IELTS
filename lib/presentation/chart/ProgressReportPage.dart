//Shows Score at The Top of the Bar
import 'dart:convert';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../guide/guidepage2/guidepage2.dart';

class ProgressReportPage extends StatefulWidget {
  @override
  _ProgressReportPageState createState() => _ProgressReportPageState();
}

class _ProgressReportPageState extends State<ProgressReportPage> {
  List<charts.Series<RatingData, String>> _seriesBarData = [];
  bool isLoading = true;
  bool isEmptyData = false;
  int currentStartIndex = 0;
  final int maxVisibleItems = 4;

  @override
  void initState() {
    super.initState();
    _fetchProgressReport();
  }

  Future<void> _fetchProgressReport() async {
    try {
      final box = GetStorage();
      var response = await http.get(
        Uri.parse('https://api.cuvasol.com/api/videos/progress'),
        headers: {
          'Authorization': 'Bearer ${box.read('token')}',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == true && responseData['code'] == 201) {
          final data = responseData['data']['progress'] as List<dynamic>;
          _processData(data);
        } else {
          throw Exception('Unexpected response structure');
        }
      } else {
        throw Exception('Failed to load progress report');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching progress report: $e')),
      );
    }
  }

  void _processData(List<dynamic> data) {
    if (data.isEmpty) {
      setState(() {
        isEmptyData = true;
        isLoading = false;
      });
      return;
    }

    final List<RatingData> myRating = [];
    final List<RatingData> otherStudentsRating = [];

    for (var item in data) {
      double myRatingValue = item['my_rating'] is String
          ? double.parse(item['my_rating'])
          : (item['my_rating'] as num).toDouble();

      double otherStudentsRatingValue = item['other_students_rating'] is String
          ? double.parse(item['other_students_rating'])
          : (item['other_students_rating'] as num).toDouble();

      myRating.add(RatingData(_splitLabel(item['title']), myRatingValue));
      otherStudentsRating.add(
          RatingData(_splitLabel(item['title']), otherStudentsRatingValue));
    }

    setState(() {
      _seriesBarData.add(
        charts.Series(
          domainFn: (RatingData rating, _) => rating.question,
          measureFn: (RatingData rating, _) => rating.rating,
          id: 'My Rating',
          data: myRating,
          colorFn: (_, __) => charts.MaterialPalette.deepOrange.shadeDefault,
          labelAccessorFn: (RatingData rating, _) =>
              '${rating.rating.toStringAsFixed(1)}',
          // Format the score
          insideLabelStyleAccessorFn: (RatingData rating, _) =>
              charts.TextStyleSpec(
            color: charts.MaterialPalette.black,
            fontSize: 12,
          ),
          outsideLabelStyleAccessorFn: (RatingData rating, _) =>
              charts.TextStyleSpec(
            color: charts.MaterialPalette.black,
            fontSize: 12,
          ),
        ),
      );

      _seriesBarData.add(
        charts.Series(
          domainFn: (RatingData rating, _) => rating.question,
          measureFn: (RatingData rating, _) => rating.rating,
          id: 'Other Students Rating',
          data: otherStudentsRating,
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          labelAccessorFn: (RatingData rating, _) =>
              '${rating.rating.toStringAsFixed(1)}',
          // Format the score
          insideLabelStyleAccessorFn: (RatingData rating, _) =>
              charts.TextStyleSpec(
            color: charts.MaterialPalette.black,
            fontSize: 12,
          ),
          outsideLabelStyleAccessorFn: (RatingData rating, _) =>
              charts.TextStyleSpec(
            color: charts.MaterialPalette.black,
            fontSize: 12,
          ),
        ),
      );

      isLoading = false;
    });
  }

  String _splitLabel(String label) {
    const int maxLength = 5;
    final words = label.split(' ');
    String newLabel = '';
    String currentLine = '';

    for (String word in words) {
      if (currentLine.length + word.length <= maxLength) {
        currentLine += (currentLine.isEmpty ? '' : ' ') + word;
      } else {
        newLabel += (newLabel.isEmpty ? '' : '\n') + currentLine;
        currentLine = word;
      }
    }

    newLabel += (newLabel.isEmpty ? '' : '\n') + currentLine;
    return newLabel;
  }

  void _nextPage() {
    setState(() {
      if (currentStartIndex + maxVisibleItems <
          _seriesBarData.first.data.length) {
        currentStartIndex += maxVisibleItems;
      }
    });
  }

  void _previousPage() {
    setState(() {
      if (currentStartIndex - maxVisibleItems >= 0) {
        currentStartIndex -= maxVisibleItems;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Progress Report'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : isEmptyData
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
                            MaterialPageRoute(
                                builder: (context) => guidepage2()),
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
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: screenHeight * 0.5,
                            child: charts.BarChart(
                              _seriesBarData,
                              animate: true,
                              barGroupingType: charts.BarGroupingType.grouped,
                              defaultRenderer: charts.BarRendererConfig(
                                barRendererDecorator:
                                    charts.BarLabelDecorator<String>(),
                              ),
                              behaviors: [
                                charts.SeriesLegend(
                                  position: charts.BehaviorPosition.top,
                                  outsideJustification: charts
                                      .OutsideJustification.middleDrawArea,
                                  horizontalFirst: false,
                                  desiredMaxRows: 2,
                                  cellPadding:
                                      EdgeInsets.only(right: 4.0, bottom: 4.0),
                                  entryTextStyle: charts.TextStyleSpec(
                                    color: charts.MaterialPalette.black,
                                    fontFamily: 'Georgia',
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                              domainAxis: charts.OrdinalAxisSpec(
                                viewport: charts.OrdinalViewport(
                                    _seriesBarData
                                        .first.data[currentStartIndex].question,
                                    maxVisibleItems),
                                renderSpec: charts.SmallTickRendererSpec(
                                  labelStyle: charts.TextStyleSpec(
                                    fontSize: 10,
                                    color: charts.MaterialPalette.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _previousPage,
                            icon: Icon(Icons.arrow_back, color: Colors.black),
                            label: Text('Previous',
                                style: TextStyle(color: Colors.black)),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: Colors.white,
                              minimumSize: Size(150, 45),
                            ),
                          ),
                          SizedBox(width: 20),
                          ElevatedButton.icon(
                            onPressed: _nextPage,
                            icon:
                                Icon(Icons.arrow_forward, color: Colors.black),
                            label: Text('Next',
                                style: TextStyle(color: Colors.black)),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: Colors.white,
                              minimumSize: Size(150, 45),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }
}

class RatingData {
  final String question;
  final double rating;

  RatingData(this.question, this.rating);
}
