import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:helder_proto/common/styles/text_styles.dart';
import 'package:helder_proto/common/widgets/helder_buttons.dart';
import 'package:helder_proto/common/widgets/payment_card.dart';
import 'package:helder_proto/features/payment/payment_controller.dart';
import 'package:helder_proto/features/payment/payment_screen_layout.dart';
import 'package:helder_proto/models/helder_invoice.dart';
import 'package:helder_proto/providers/navigation_provider.dart';
import 'package:helder_proto/utils/constants/text_strings.dart';


class PaymentScreen extends StatelessWidget {
  late PaymentController controller;
  final HelderInvoice invoice;

  PaymentScreen({super.key, HelderInvoice? invoice}) 
    : invoice = invoice ?? HelderInvoice.empty();

  @override
  Widget build(BuildContext context) {
    controller = PaymentController(
      invoice: invoice
    );

    return Center(
      child: PaymentScreenLayout(
        
        paymentCard: Paymentcard(
          amount: invoice.amount.toString(),
          reciever: invoice.letter.sender,
          payDate: invoice.paymentDeadline,
        ),

        infoBlock: getInfoBlock(),

        paymentButtons: getPayOptionBlock(context),

      ),
    );
    
  }

  Widget getInfoBlock() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
      
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              TTexts.canYouPayNowText,
              style: HelderText.breadStyle
            ),
          ),
      
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(
              textAlign: TextAlign.center,
              TTexts.dontNeedToPayToday('19 juni'),
              style: HelderText.remissionStyle,
            ),
          )
        ],
      ),
    );
  }

  Widget getPayOptionBlock(BuildContext context) {
    NavigationProvider navigationProvider = Provider.of<NavigationProvider>(context, listen: false); 

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        
        Container(
          padding: const EdgeInsets.only(top: 20),
          width: 310, // Measurements from figma
          child: const Text(
            "Ik betaal...",
            style: HelderText.expandableButtonStyle,
          ),
        ),

        HelderBigButton(
          margin: const EdgeInsets.only(top: 20, bottom: 10),
          text: "Nog even niet",
          onPressed: () => controller.onPayLater(navigationProvider)
        ),

        HelderBigButton(
          margin: const EdgeInsets.only(bottom: 20),
          text: "Meteen",
          onPressed: () => controller.onPayNow(navigationProvider)
        ),

      ],
    );
  }

}