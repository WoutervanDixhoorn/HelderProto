import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const String assetName = 'assets/svg/warning.svg';
final Widget warningSvg = SvgPicture.asset(
  assetName,
  semanticsLabel: 'Warning Logo',
  
);