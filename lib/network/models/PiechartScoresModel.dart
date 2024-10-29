/*
class PiechartScoresModel {
  bool status;
  int code;
  Data data;

  PiechartScoresModel({required this.status, required this.code, required this.data});

  PiechartScoresModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    data = (json['data'] != null ? new Data.fromJson(json['data']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String emotion;
  String content;
  String verbal;
  String posture;
  String score;

  Data({required this.emotion, required this.content, required this.verbal, required this.posture, required this.score});

  // Data.fromJson(Map<String, dynamic> json) {
  //   emotion = json['emotion'];
  //   content = json['content'];
  //   verbal = json['verbal'];
  //   posture = json['posture'];
  //   score = json['score'];
  // }

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
*/
