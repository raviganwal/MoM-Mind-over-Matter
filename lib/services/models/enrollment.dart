// To parse this JSON data, do
//
//     final enrollment = enrollmentFromJson(jsonString);

import 'dart:convert';

Enrollment enrollmentFromJson(String str) => Enrollment.fromJson(json.decode(str));

String enrollmentToJson(Enrollment data) => json.encode(data.toJson());

class Enrollment {
  Enrollment({
    required this.userId,
    required this.topicId,
    required this.isCompleted,
    required this.enrolledOn,
    required this.completedOn,
  });

  String userId;
  String topicId;
  bool isCompleted;
  String enrolledOn;
  String completedOn;

  factory Enrollment.fromJson(Map<String, dynamic> json) => Enrollment(
        userId: json["userId"],
        topicId: json["topicId"],
        isCompleted: json["isCompleted"],
        enrolledOn: json["enrolledOn"],
        completedOn: json["completedOn"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "topicId": topicId,
        "isCompleted": isCompleted,
        "enrolledOn": enrolledOn,
        "completedOn": completedOn,
      };
}
