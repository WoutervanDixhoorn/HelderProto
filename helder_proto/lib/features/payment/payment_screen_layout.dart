import 'package:flutter/material.dart';

import 'package:helder_proto/common/widgets/helder_header_screen.dart';
import 'package:helder_proto/utils/constants/colors.dart';
import 'package:helder_proto/utils/helpers/helper_functions.dart';

class PaymentScreenLayout extends StatelessWidget {
  final Widget paymentCard;
  final Widget infoBlock;

  final Widget paymentButtons;

  const PaymentScreenLayout({
    super.key,

    required this.paymentCard,
    required this.infoBlock,

    required this.paymentButtons
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
          final double infoBlockHeight = (5.5 / 14) * totalHeight;

          final double remainingHeight = totalHeight -
              (paymentCardHeight + infoBlockHeight);

          return Column(
            children: [

              Container(
                height: paymentCardHeight,
                padding: const EdgeInsets.only(top: 30),
                child: paymentCard
              ),

              SizedBox( //Info text
                height: infoBlockHeight,
                child: Container(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  alignment: Alignment.topLeft,
                  child: infoBlock
                )
              ),

              SizedBox( //Buttons
                height: remainingHeight,
                child: Container(
                  width: THelperFunctions.screenWidth(),
                  color: HelderColors.lightGrey,
                  child: paymentButtons
                )
              )

            ],
          );
          
        }
      ),
    );
  }

}