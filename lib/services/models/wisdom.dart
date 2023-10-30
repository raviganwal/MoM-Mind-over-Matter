// To parse this JSON data, do
//
//     final wisdom = wisdomFromJson(jsonString);

import 'dart:convert';

Wisdom wisdomFromJson(String str) => Wisdom.fromJson(json.decode(str));

String wisdomToJson(Wisdom data) => json.encode(data.toJson());

class Wisdom {
  Wisdom({
    required this.id,
    required this.category,
    required this.content,
    required this.imgUrl,
    required this.title,
    required this.contentType,
    required this.description,
  });

  String id;
  String category;
  String content;
  String imgUrl;
  String title;
  String contentType;
  String description;

  factory Wisdom.fromJson(Map<String, dynamic> json) => Wisdom(
        id: json["id"],
        category: json["category"],
        content: json["content"],
        imgUrl: json["imgUrl"],
        title: json["title"],
        contentType: json["contentType"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category": category,
        "content": content,
        "imgUrl": imgUrl,
        "title": title,
        "contentType": contentType,
        "description": description,
      };
}
