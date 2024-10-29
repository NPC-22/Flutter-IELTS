
class PieChartModel {
  bool? status;
  int? code;
  Data? data;

  PieChartModel({this.status, this.code, this.data});

  PieChartModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  num? emotion;
  num? content;
  num? verbal;
  num? posture;
  num? score;

  Data(
      {this.emotion,
        this.content,
        this.verbal,
        this.posture,
        this.score});

  Data.fromJson(Map<String, dynamic> json) {
    emotion = json['emotion'];
    content = json['content'];
    verbal = json['verbal'];
    posture = json['posture'];
    score = json['score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['emotion'] = this.emotion;
    data['content'] = this.content;
    data['verbal'] = this.verbal;
    data['posture'] = this.posture;
    data['score'] = this.score;
    return data;
  }
}

