// To parse this JSON data, do
//
//     final story = storyFromJson(jsonString);

import 'dart:convert';

Story storyFromJson(String str) => Story.fromJson(json.decode(str));

String storyToJson(Story data) => json.encode(data.toJson());

class Story {
  Story({
    required this.id,
    required this.day,
    required this.quote,
    required this.author,
    required this.imgUrl,
    required this.videoUrl,
    required this.podcastUrl,
    required this.shareCount,
  });

  String id;
  String day;
  String quote;
  String author;
  String imgUrl;
  String videoUrl;
  String podcastUrl;
  int shareCount;

  factory Story.fromJson(Map<String, dynamic> json) => Story(
        id: json["id"],
        day: json["day"],
        quote: json["quote"],
        author: json["author"],
        imgUrl: json["imgUrl"],
        videoUrl: json["videoUrl"],
        podcastUrl: json["podcastUrl"],
        shareCount: json["shareCount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "day": day,
        "quote": quote,
        "author": author,
        "imgUrl": imgUrl,
        "videoUrl": videoUrl,
        "podcastUrl": podcastUrl,
        "shareCount": shareCount,
      };

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'day': day,
      'quote': quote,
      'author': author,
      'videoUrl': videoUrl,
      'podcastUrl': podcastUrl,
      'shareCount': shareCount,
      'imgUrl': imgUrl,
    };
  }
}
