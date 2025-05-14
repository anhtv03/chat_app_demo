class MessageDTO {
  final String? content;
  final List<String> files;
  final List<String> images;

  MessageDTO({
    this.content,
    this.files = const [],
    this.images = const [],
  });
}

