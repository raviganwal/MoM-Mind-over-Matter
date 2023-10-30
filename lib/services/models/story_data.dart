class StoryContent {
  StoryContent({
    required this.type,
    this.content,
  });

  final StoryContentType type;
  final String? content;
}

enum StoryContentType {
  QUOTE,
  VIDEO,
  PODCAST,
  COMPLETION,
}
