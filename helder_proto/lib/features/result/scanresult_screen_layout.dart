import 'package:flutter/material.dart';

import 'package:helder_proto/common/widgets/helder_header_screen.dart';
import 'package:helder_proto/utils/helpers/helper_functions.dart';

class ScanResultScreenLayout extends StatelessWidget {
  final Widget paymentCard;
  final Widget infoBlock;
  final Widget expandableText;
  final Widget nextButton;

  const ScanResultScreenLayout({
    super.key,

    required this.paymentCard,
    required this.infoBlock,
    required this.expandableText,
    required this.nextButton
  });

  @override
  Widget build(BuildContext context) {
    return HeaderPage(
      title: "Rekening", 
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double totalHeight = constraints.maxHeight;

          // Calculate heights based on the flex ratios
          final double paymentCardHeight = (4 / 14) * totalHeight;
          final double infoBlockHeight = (5 / 14) * totalHeight;
          final double nextButtonHeight = (2 / 14) * totalHeight;

          final double remainingHeight = totalHeight -
              (paymentCardHeight + infoBlockHeight + nextButtonHeight);

          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: paymentCardHeight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: paymentCard
                  )
                ),
            
                SizedBox(
                  height: infoBlockHeight,
                  child: Container(
                    padding: const EdgeInsets.only(top: 10, left: 30, right: 30),
                    alignment: Alignment.topLeft,
                    child: infoBlock
                  )
                ),

                Container(
                  constraints: BoxConstraints(
                    maxWidth: THelperFunctions.screenWidth() * 0.85,
                    minHeight: remainingHeight,
                  ),
                  child: expandableText
                ),

                SizedBox(
                  height: nextButtonHeight,
                  child: nextButton
                ),
            
              ],
            ),
          );

        },
      ),
    );
  }
}