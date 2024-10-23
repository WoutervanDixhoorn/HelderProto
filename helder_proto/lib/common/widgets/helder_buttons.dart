import 'package:flutter/material.dart';
import 'package:helder_proto/common/styles/text_styles.dart';
import 'package:helder_proto/utils/constants/colors.dart';

class HelderBigButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  final Color color;
  final BorderRadius borderRadius;

  const HelderBigButton({
    super.key, this.text = "", 
    required this.onPressed, 
    this.color = HelderColors.purple,
    this.borderRadius = const BorderRadius.all(Radius.circular(30))
  });

  @override
  Widget build(BuildContext context) {
    return  ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 240,
        maxHeight: 50,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius 
        ),
        child: MaterialButton(
          onPressed: onPressed,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15.0), 
            child: Text(text, style: HelderText.bigButtonStyle)),
        ),
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
    return OutlinedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(eccentricity: 0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        side: const BorderSide(width: 2, color: HelderColors.white),
        minimumSize: const Size(65, 65)
      ),
      child: Container(
        width: 53,
        height: 53,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: HelderColors.white
        ),
      )
    );  
  }
}