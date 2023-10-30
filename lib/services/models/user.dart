// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.userId,
    required this.gender,
    required this.country,
    required this.dateOfBirth,
    required this.proValidity,
    required this.enrolledTopic,
    required this.activeSprint,
  });

  String firstName;
  String lastName;
  String email;
  String userId;
  String gender;
  String country;
  String dateOfBirth;
  String proValidity;
  String enrolledTopic;
  String activeSprint;

  factory User.fromJson(Map<String, dynamic> json) => User(
      firstName: json["firstName"],
      lastName: json["lastName"],
      email: json["email"],
      userId: json["userId"],
      gender: json["gender"],
      country: json["country"],
      dateOfBirth: json["dateOfBirth"],
      proValidity: json["proValidity"],
      enrolledTopic: json["enrolledTopic"],
      activeSprint: json["activeSprint"]);

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "userId": userId,
        "gender": gender,
        "country": country,
        "dateOfBirth": dateOfBirth,
        "proValidity": proValidity,
        "enrolledTopic": enrolledTopic,
        "activeSprint": activeSprint,
      };
}
