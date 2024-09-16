import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:helder_proto/common/styles/text_styles.dart';
import 'package:helder_proto/common/widgets/helder_buttons.dart';
import 'package:helder_proto/features/payment/payment_controller.dart';
import 'package:helder_proto/models/helder_invoice_data.dart';
import 'package:helder_proto/models/helder_renderable_data.dart';
import 'package:helder_proto/features/payment/payment_screen_layout.dart';
import 'package:helder_proto/models/helder_tax_data.dart';
import 'package:helder_proto/providers/navigation_provider.dart';
import 'package:helder_proto/utils/constants/text_strings.dart';



class PaymentScreen extends StatelessWidget {
  late PaymentController paymentController;
  final HelderRenderableData helderData;

  PaymentScreen({
    super.key,
    required this.helderData
  }); 

  @override
  Widget build(BuildContext context) {
    paymentController = PaymentController(
      helderData: helderData
    );

    return Center(
      child: PaymentScreenLayout(
        
        paymentCard: helderData.toPaymentCard(),

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
              TTexts.dontNeedToPayToday('19 juni'), //TODO: Add paydate to HelderRenerableData
              style: HelderText.remissionStyle,
            ),
          )
        ],
      ),
    );
  }
  
  Widget getPayOptionBlock(BuildContext context) {
    NavigationProvider navigationProvider = Provider.of<NavigationProvider>(context, listen: false); 

    if (helderData is! HelderInvoice && helderData is! HelderTax) {
      return HelderBigButton(
        margin: const EdgeInsets.only(bottom: 20),
        text: "Oke",
        onPressed: () => paymentController.onAllowanceOkay(navigationProvider),
      );
    }

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
          onPressed: () => paymentController.onPayLater(navigationProvider)
        ),

        HelderBigButton(
          margin: const EdgeInsets.only(bottom: 20),
          text: "Meteen",
          onPressed: () => paymentController.onPayNow(navigationProvider)
        ),

      ],
    );
  }

}