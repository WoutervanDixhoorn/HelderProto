class TextInfo {
  int id;

  String content;
  String simplifiedContent;

  TextInfo({
    this.id = -1,

    required this.content,
    required this.simplifiedContent,
  });

  TextInfo.empty()
    : id = -1,
      content = '',
      simplifiedContent = '';

  factory TextInfo.fromMap(Map<String, Object?> map) {
    return TextInfo(
      id: map['Id'] as int? ?? -1,
      content: map['Content'] as String? ?? '',
      simplifiedContent: map['SimplifiedContent'] as String? ?? '',
    );
  }

  Map<String, Object?> toMap() {
    return {
      'Id': id,
      'Content': content,
      'SimplifiedContent': simplifiedContent,
    };
  }
}