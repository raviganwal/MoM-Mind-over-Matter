// To parse this JSON data, do
//
//     final sprint = sprintFromJson(jsonString);

import 'dart:convert';

Sprint sprintFromJson(String str) => Sprint.fromJson(json.decode(str));

String sprintToJson(Sprint data) => json.encode(data.toJson());

class Sprint {
  Sprint({
    required this.userId,
    required this.topicId,
    required this.day,
    required this.isCompleted,
    required this.completedOn,
  });

  String userId;
  String topicId;
  int day;
  bool isCompleted;
  String completedOn;

  factory Sprint.fromJson(Map<String, dynamic> json) => Sprint(
        userId: json["userId"],
        topicId: json["topicId"],
        day: json["day"],
        isCompleted: json["isCompleted"],
        completedOn: json["completedOn"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "topicId": topicId,
        "day": day,
        "isCompleted": isCompleted,
        "completedOn": completedOn,
      };
}
