class TextInfo {
  int id;

  String content;
  String simplifiedContent;

  String sender;
  String subject;

  TextInfo({
    this.id = -1,

    required this.content,
    required this.simplifiedContent,

    required this.sender,
    required this.subject
  });

  TextInfo.empty()
    : id = -1,
      content = '',
      simplifiedContent = '',
      sender = '',
      subject = '';

  factory TextInfo.fromMap(Map<String, Object?> map) {
    return TextInfo(
      id: map['Id'] as int? ?? -1,
      content: map['Content'] as String? ?? '',
      simplifiedContent: map['SimplifiedContent'] as String? ?? '',
      sender: map['Sender'] as String? ?? '',
      subject: map['Subject'] as String? ?? '',
    );
  }

  Map<String, Object?> toMap() {
    return {
      'Content': content,
      'SimplifiedContent': simplifiedContent,
      'Sender': sender,
      'Subject': subject
    };
  }
}