class UserAgent {
  bool? status;
  int? code;
  Data? data;

  UserAgent({this.status, this.code, this.data});

  UserAgent.fromJson(Map<String, dynamic> json) {
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
  String? message;
  List<AgentUserMap>? agentUserMap;

  Data({this.message, this.agentUserMap});

  Data.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['agent_user_map'] != null) {
      agentUserMap = <AgentUserMap>[];
      json['agent_user_map'].forEach((v) {
        agentUserMap!.add(new AgentUserMap.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.agentUserMap != null) {
      data['agent_user_map'] =
          this.agentUserMap!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AgentUserMap {
  String? email;
  String? companyName;
  int? interviewId;
  String? description;
  String? referenceCode;
  int? agentId;
  int? userId;
  int? planId;
  String? userName;
  String? planName;

  AgentUserMap(
      {this.email,
        this.companyName,
        this.interviewId,
        this.description,
        this.referenceCode,
        this.agentId,
        this.userId,
        this.planId,
        this.userName,
        this.planName});

  AgentUserMap.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    companyName = json['company_name'];
    interviewId = json['interview_id'];
    description = json['description'];
    referenceCode = json['reference_code'];
    agentId = json['agent_id'];
    userId = json['user_id'];
    planId = json['plan_id'];
    userName = json['user_name'];
    planName = json['plan_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['company_name'] = this.companyName;
    data['interview_id'] = this.interviewId;
    data['description'] = this.description;
    data['reference_code'] = this.referenceCode;
    data['agent_id'] = this.agentId;
    data['user_id'] = this.userId;
    data['plan_id'] = this.planId;
    data['user_name'] = this.userName;
    data['plan_name'] = this.planName;
    return data;
  }
}