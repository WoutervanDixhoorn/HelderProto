import 'package:helder_proto/utils/constants/enums.dart';
import 'package:helder_proto/models/helder_text_info_data.dart';

class HelderLetter {
  TextInfo textInfo;
  LetterKind kind;

  HelderLetter({
    required this.textInfo,
    required this.kind,
  });

  HelderLetter.empty()
    : textInfo = TextInfo.empty(),
      kind = LetterKind.normaal;

  factory HelderLetter.fromMap(Map<String, Object?> map, TextInfo textInfo) {
    return HelderLetter(
      textInfo: textInfo,
      kind: LetterKind.values.byName(map['SpecificKind'] as String? ?? 'normaal'),
    );
  }

  Map<String, Object?> toMap() {
    return {
      'TextInfo': textInfo.toMap(),
      'SpecificKind': kind.name,
    };
  }
}
