// To parse this JSON data, do
//
//     final checkin = checkinFromJson(jsonString);

import 'dart:convert';

Checkin checkinFromJson(String str) => Checkin.fromJson(json.decode(str));

String checkinToJson(Checkin data) => json.encode(data.toJson());

class Checkin {
  Checkin({
    required this.mood,
    required this.sleep,
    required this.userId,
    required this.datetime,
    required this.sleepStart,
    required this.sleepEnd,
  });

  String mood;
  String sleep;
  String userId;
  String datetime;
  String sleepStart;
  String sleepEnd;

  factory Checkin.fromJson(Map<String, dynamic> json) => Checkin(
        mood: json["mood"],
        sleep: json["sleep"],
        userId: json["userId"],
        datetime: json["datetime"],
        sleepStart: json["sleepStart"],
        sleepEnd: json["sleepEnd"],
      );

  Map<String, dynamic> toJson() => {
        "mood": mood,
        "sleep": sleep,
        "userId": userId,
        "datetime": datetime,
        "sleepStart": sleepStart,
        "sleepEnd": sleepEnd,
      };
}
