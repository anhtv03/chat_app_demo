import 'dart:io';

class   MessageDTO {
  final String? content;
  final List<File>? files;
  final List<File>? images;

  MessageDTO({
    this.content,
    this.files = const [],
    this.images = const [],
  });
}

