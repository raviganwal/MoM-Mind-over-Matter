class Comment {
  String id;
  String userId;
  String name;
  String datetime;
  String comment;
  String userImgUrl;
  final bool isVerified;

  Comment({
    required this.id,
    required this.userId,
    required this.name,
    required this.datetime,
    required this.comment,
    required this.userImgUrl,
    bool? isVerified,
  }) : isVerified = isVerified ?? false;

  // Create a method to convert the comment to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'datetime': datetime,
      'comment': comment,
      'userImgUrl': userImgUrl,
      'isVerified': isVerified,
    };
  }

  // Create a factory method to create a Comment instance from a JSON map
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      datetime: json['datetime'],
      comment: json['comment'],
      userImgUrl: json['userImgUrl'],
      isVerified: json['isVerified'],
    );
  }
}
