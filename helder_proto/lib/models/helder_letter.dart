import 'dart:convert';

import 'package:helder_proto/utils/constants/enums.dart';

HelderLetter helderLetterFromJson(String content, String json) => HelderLetter.fromJson(content, jsonDecode(json));

class HelderLetter {

  String content;
  String sender;
  String simplifiedContent;
  LetterKind kind;

  HelderLetter({
    required this.content, 
    required this.sender, 
    required this.simplifiedContent,
    required this.kind
  });

  HelderLetter.empty()
    : content = '',
      sender = '',
      simplifiedContent = '',
      kind = LetterKind.regular;

  factory HelderLetter.fromJson(String content, Map<String, dynamic> json) {
    final letterJson = json['letter'] as Map<String, dynamic>;

    return HelderLetter(
      content: content, 
      sender: letterJson['sender'] as String, 
      simplifiedContent: letterJson['simplifiedContent'] as String, 
      kind: LetterKind.values.byName(letterJson['kind']) 
    );
  }
}