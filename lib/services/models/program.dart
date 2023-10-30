class Program {
  Program({
    required this.topicId,
    required this.title,
    required this.description,
    required this.day,
    required this.isAudio,
    required this.isVideo,
    required this.isText,
    required this.videoUrl,
    required this.audioUrl,
    required this.textContent,
    this.quizlink, // Optional parameter
  });

  String topicId;
  String title;
  String description;
  int day;
  bool isAudio;
  bool isVideo;
  bool isText;
  String videoUrl;
  String audioUrl;
  String textContent;
  String? quizlink; // Optional parameter with nullable type

  factory Program.fromJson(Map<String, dynamic> json) => Program(
        topicId: json["topicId"],
        title: json["title"],
        description: json["description"],
        day: json["day"],
        isAudio: json["isAudio"],
        isVideo: json["isVideo"],
        isText: json["isText"],
        videoUrl: json["videoUrl"],
        audioUrl: json["audioUrl"],
        textContent: json["textContent"],
        quizlink: json["quizlink"] ?? "", // Add the parsing for quizlink
      );

  Map<String, dynamic> toJson() => {
        "topicId": topicId,
        "title": title,
        "description": description,
        "day": day,
        "isAudio": isAudio,
        "isVideo": isVideo,
        "isText": isText,
        "videoUrl": videoUrl,
        "audioUrl": audioUrl,
        "textContent": textContent,
        "quizlink": quizlink, // Add the serialization for quizlink
      };
}
