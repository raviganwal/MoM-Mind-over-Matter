class Topic {
  Topic({
    required this.topicId,
    required this.title,
    required this.description,
    required this.imgUrl,
    this.color, // optional color parameter
  });

  String topicId;
  String title;
  String description;
  String imgUrl;
  String? color; // nullable color property

  factory Topic.fromJson(Map<String, dynamic> json) => Topic(
        topicId: json["topicId"],
        title: json["title"],
        description: json["description"],
        imgUrl: json["imgUrl"],
        color: json["color"], // parse optional color property from JSON
      );

  Map<String, dynamic> toJson() => {
        "topicId": topicId,
        "title": title,
        "description": description,
        "imgUrl": imgUrl,
        "color": color, // include optional color property in JSON
      };
}
