// To parse this JSON data, do
//
//     final userProfile = userProfileFromJson(jsonString);

import 'dart:convert';

UserProfile userProfileFromJson(String str) => UserProfile.fromJson(json.decode(str));

String userProfileToJson(UserProfile data) => json.encode(data.toJson());

class UserProfile {
  bool? status;
  int? code;
  Data? data;

  UserProfile({
    this.status,
    this.code,
    this.data,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    status: json["status"],
    code: json["code"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "code": code,
    "data": data?.toJson(),
  };
}

class Data {
  int? id;
  int? planId;
  String? name;
  String? planName;
  int? videoCount;
  int? recordLimit;
  int? planPeriodInMonths;
  int? contactEmailVerified;
  dynamic contactEmail;
  dynamic phoneNumber;
  dynamic major;
  dynamic degree;
  String? limitReached;

  Data({
    this.id,
    this.planId,
    this.name,
    this.planName,
    this.videoCount,
    this.recordLimit,
    this.planPeriodInMonths,
    this.contactEmailVerified,
    this.contactEmail,
    this.phoneNumber,
    this.major,
    this.degree,
    this.limitReached,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    planId: json["plan_id"],
    name: json["name"],
    planName: json["plan_name"],
    videoCount: json["video_count"],
    recordLimit: json["record_limit"],
    planPeriodInMonths: json["plan_period_in_months"],
    contactEmailVerified: json["contact_email_verified"],
    contactEmail: json["contact_email"],
    phoneNumber: json["phone_number"],
    major: json["major"],
    degree: json["degree"],
    limitReached: json["limit_reached"],
  );

  get agentUserMap => null;

  Map<String, dynamic> toJson() => {
    "id": id,
    "plan_id": planId,
    "name": name,
    "plan_name": planName,
    "video_count": videoCount,
    "record_limit": recordLimit,
    "plan_period_in_months": planPeriodInMonths,
    "contact_email_verified": contactEmailVerified,
    "contact_email": contactEmail,
    "phone_number": phoneNumber,
    "major": major,
    "degree": degree,
    "limit_reached": limitReached,
  };
}
