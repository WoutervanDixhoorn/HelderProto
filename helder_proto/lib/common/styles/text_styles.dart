// TextStyles
import 'package:flutter/material.dart';

import '../../utils/constants/colors.dart';

abstract final class HelderText {
  static const TextStyle pageTitleTextStyle = TextStyle(color: HelderColors.white, fontFamily: 'Rota', fontWeight: FontWeight.w800, fontSize: 36);
  static const TextStyle titleTextStyle = TextStyle(color: HelderColors.darkGrey, fontFamily: 'Rota', fontWeight: FontWeight.w800, fontSize: 24);
  static const TextStyle headBreadStyle = TextStyle(color: HelderColors.darkGrey, fontFamily: 'Rota', fontWeight: FontWeight.bold, fontSize: 16);
  static const TextStyle breadStyle = TextStyle(color: HelderColors.darkGrey, fontFamily: 'Rota', fontWeight: FontWeight.w400, fontSize: 16);
  static const TextStyle smallButtonStyle = TextStyle(color: HelderColors.white, fontFamily: 'Rota', fontWeight: FontWeight.w800, fontSize: 18);
  static const TextStyle bigButtonStyle = TextStyle(color: HelderColors.white, fontFamily: 'Rota', fontWeight: FontWeight.w800, fontSize: 22);
  static const TextStyle expandableButtonStyle = TextStyle(color: HelderColors.darkGrey, fontFamily: 'Rota', fontWeight: FontWeight.w900, fontSize: 22);

  static const TextStyle amountEuroCardTextStyle = TextStyle(color: HelderColors.darkGrey, fontFamily: 'Rota', fontWeight: FontWeight.bold, fontSize: 36);
  static const TextStyle amountCentsCardTextStyle = TextStyle(color: HelderColors.darkGrey, fontFamily: 'Rota', fontWeight: FontWeight.bold, fontSize: 16);
  static const TextStyle payToTextStyle = breadStyle;
  static const TextStyle smallTitleTextStyle = TextStyle(color: HelderColors.darkGrey, fontFamily: 'Rota', fontWeight: FontWeight.bold, fontSize: 16);
  
  static const TextStyle remissionStyle = TextStyle(color: HelderColors.purple, fontFamily: 'Rota', fontWeight: FontWeight.w800, fontSize: 16, height: 1.24, textBaseline: TextBaseline.alphabetic);
  static const TextStyle remissionStyleClickable = TextStyle(color: HelderColors.purple, fontFamily: 'Rota', fontWeight: FontWeight.w800, fontSize: 16, decoration: TextDecoration.underline);

}