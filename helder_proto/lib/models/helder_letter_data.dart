import 'package:helder_proto/utils/constants/enums.dart';
import 'package:helder_proto/models/helder_text_info_data.dart';

class HelderLetter {
  TextInfo textInfo;
  String sender;
  String subject;
  LetterKind kind;

  HelderLetter({
    required this.textInfo,
    required this.sender,
    required this.subject,
    required this.kind,
  });

  HelderLetter.empty()
    : textInfo = TextInfo.empty(),
      sender = '',
      subject = '',
      kind = LetterKind.normaal;

  factory HelderLetter.fromMap(Map<String, Object?> map) {
    return HelderLetter(
      textInfo: TextInfo.fromMap(map),
      sender: map['Sender'] as String? ?? '',
      subject: map['Subject'] as String? ?? '',
      kind: LetterKind.values.byName(map['Kind'] as String? ?? 'normaal'),
    );
  }

  Map<String, Object?> toMap() {
    return {
      'TextInfo': textInfo.toMap(),
      'Sender': sender,
      'Subject': subject,
      'Kind': kind.name,
    };
  }
}
