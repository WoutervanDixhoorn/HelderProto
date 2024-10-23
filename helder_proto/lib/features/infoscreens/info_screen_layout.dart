import 'package:flutter/material.dart';
import 'package:helder_proto/common/widgets/helder_header_screen.dart';
import 'package:helder_proto/utils/constants/colors.dart';

class InfoScreenLayout extends StatelessWidget {
  final Widget infoLogo;
  final Widget infoText;
  final Widget infoButton;

  const InfoScreenLayout({
    super.key,
  
    required this.infoLogo,
    required this.infoText,
    required this.infoButton
  });

  @override
  Widget build(BuildContext context) {
    return HeaderPage(
      title: 'Pas op!', 
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double totalHeight = constraints.maxHeight;

          final double infoLogoHeight = (7 / 14) * totalHeight;
          final double infoTextHeight = (5 / 14) * totalHeight;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Center(
                child: SizedBox(
                  height: infoLogoHeight,
                  width: 280,
                  child: infoLogo,
                ),
              ),
        
              SizedBox(
                height: infoTextHeight,
                width: 280,
                child: infoText,
              ),

              infoButton

            ],
          );
        },
      )
    );
  }
}