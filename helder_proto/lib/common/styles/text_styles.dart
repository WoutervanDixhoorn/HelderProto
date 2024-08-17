// TextStyles
import 'package:flutter/material.dart';

import '../../utils/constants/colors.dart';

abstract final class HelderText {
  static const TextStyle pageTitleTextStyle = TextStyle(color: HelderColors.white, fontFamily: 'Rota', fontWeight: FontWeight.w800, fontSize: 36);
  static const TextStyle titleTextStyle = TextStyle(color: Colors.black, fontFamily: 'Rota', fontWeight: FontWeight.w800, fontSize: 24);
  static const TextStyle headBreadStyle = TextStyle(color: Colors.black, fontFamily: 'Rota', fontWeight: FontWeight.bold, fontSize: 16);
  static const TextStyle breadStyle = TextStyle(color: Colors.black, fontFamily: 'Rota', fontWeight: FontWeight.w300, fontSize: 16);
  static const TextStyle smallButtonStyle = TextStyle(color: HelderColors.white, fontFamily: 'Rota', fontWeight: FontWeight.w800, fontSize: 18);
  static const TextStyle bigButtonStyle = TextStyle(color: HelderColors.white, fontFamily: 'Rota', fontWeight: FontWeight.w800, fontSize: 22);
}