import 'package:flutter/material.dart';
import 'package:helder_proto/utils/constants/colors.dart';
import 'package:helder_proto/common/styles/text_styles.dart';
import 'package:helder_proto/utils/helpers/helper_functions.dart';

class InfoCard extends StatelessWidget {

  final String text;
  const InfoCard({super.key, this.text = "infoText"});

  @override
  Widget build(BuildContext context) {
    return Container(
    width: THelperFunctions.screenWidth(),
    margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    decoration: BoxDecoration(
      color: HelderColors.lightGrey,
      borderRadius: BorderRadius.circular(12.0), // Curved edges
    ),
    child: Text(text, style: HelderText.breadStyle),
  );
  }
}