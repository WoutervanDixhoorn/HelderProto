
import 'package:flutter/material.dart';

class HelderRemissionText extends StatelessWidget {
  final List<TextSpan> remissionText;

  const HelderRemissionText({
    super.key,

    required this.remissionText
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.start,
      text: TextSpan(
        children: [
          ...remissionText
        ]
      ),
    );
  }


}