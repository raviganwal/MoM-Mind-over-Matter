import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String avatarUrl;
  final String dateTime; // Change this to String
  final String content;
  final List<String> likedUsers;
  final String userId;
  final List<String> comments;
  final String userName;
  final String topicName;
  final Timestamp timeStamp;
  final bool isVerified; // New parameter

  Post({
    required this.id,
    required this.avatarUrl,
    required this.dateTime,
    required this.content,
    required this.likedUsers,
    required this.userId,
    required this.comments,
    required this.userName,
    required this.topicName,
    required this.timeStamp,
    bool? isVerified, // Optional parameter
  }) : isVerified = isVerified ?? false; // Set to false if null

  // Create a factory constructor to create a Post object from a Map
  factory Post.fromJson(String id, Map<String, dynamic> data) {
    return Post(
      id: id,
      avatarUrl: data['avatarUrl'] ?? '',
      dateTime: data['dateTime'] ?? '',
      content: data['content'] ?? '',
      likedUsers: List<String>.from(data['likedUsers'] ?? []),
      userId: data['userId'] ?? '',
      comments: List<String>.from(data['comments'] ?? []),
      userName: data['userName'] ?? '',
      topicName: data['topicName'],
      timeStamp: data['timeStamp'] ?? Timestamp.now(),
      isVerified: data['isVerified'], // Optionally set isVerified
    );
  }

  // Create a toJson method to convert a Post object to a Map for Firestore storage
  Map<String, dynamic> toJson() {
    return {
      'avatarUrl': avatarUrl,
      'dateTime': dateTime,
      'content': content,
      'likedUsers': likedUsers,
      'userId': userId,
      'comments': comments,
      'userName': userName,
      'topicName': topicName,
      'timeStamp': timeStamp,
      'isVerified': isVerified, // Include isVerified in the JSON
    };
  }
}
