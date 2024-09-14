import 'package:flutter/material.dart';
import 'package:helder_proto/common/styles/text_styles.dart';
import 'package:helder_proto/utils/constants/colors.dart';

class HelderBigButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  final EdgeInsets margin;
  final Color color;
  final BorderRadius borderRadius;

  const HelderBigButton({
    super.key, this.text = "", 
    required this.onPressed, 
    this.margin = const EdgeInsets.only(top: 100.0),
    this.color = HelderColors.purple,
    this.borderRadius = const BorderRadius.all(Radius.circular(30))
  });

  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: margin,
      width: 240, //Measurements from figma
      height: 50, //Measurements from figma
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius 
      ),
      child: MaterialButton(
        onPressed: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15.0), 
          child: Text(text, style: HelderText.bigButtonStyle)),
      )
    );
  }
}

class HelderScanButton extends StatelessWidget {
  final void Function() onPressed;

  const HelderScanButton({
    super.key,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder()
        ),
        child: const Text('II'),
    );
  }
}