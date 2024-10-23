import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:helder_proto/models/helder_renderable_data.dart';
import 'package:helder_proto/providers/navigation_provider.dart';
import 'package:helder_proto/common/styles/text_styles.dart';
import 'package:helder_proto/features/result/scanresult_screen_layout.dart';
import 'package:helder_proto/providers/verhelder_provider.dart';
import 'package:helder_proto/utils/constants/colors.dart';
import 'package:helder_proto/utils/helpers/helper_functions.dart';

// ignore: must_be_immutable
class ScanResultScreen extends StatelessWidget {
  final HelderRenderableData helderData;
  
  const ScanResultScreen({
    super.key,
    
    required this.helderData
  });

  @override
  Widget build(BuildContext context) {

    return ScanResultScreenLayout(
      paymentCard: helderData.toPaymentCard(),

      infoBlock: getInfoBlock(),

      expandableText: getExpandableText(),

      nextButton: getNextButton(context)
    );
  }

  Widget getInfoBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HelderTextBlock(title: 'onderwerp', text: helderData.getTextInfo().subject),
        
        !helderData.isRecievingMoney() ?
          	HelderTextBlock(title: 'waarom moet ik betalen', text: helderData.getTextInfo().simplifiedContent) :
            HelderTextBlock(title: 'waarom ontvang ik geld', text: helderData.getTextInfo().simplifiedContent),

          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: helderData.getRemissionText(),
          )
      ]
    );
  }

  Widget getExpandableText() {
    return HelderExpandableText(
      title: "Volledige brief",
      text: helderData.getTextInfo().content,
    );
  }

  Widget getNextButton(BuildContext context) {
    return Center(
      child: MaterialButton(
        onPressed: () => nextStep(context),
        child: Container(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          width: THelperFunctions.screenWidth() * 0.62, //Meaurements from figma

          decoration: const BoxDecoration(
            color: HelderColors.purple,
            borderRadius: BorderRadius.all(Radius.circular(30))
          ),

          child: const Text(
            "Volgende", 
            textAlign: TextAlign.center,
            style: HelderText.bigButtonStyle
          )
        ),
      ),
    );
  }

  void nextStep(BuildContext context) {
    final verhelderProvider = Provider.of<VerhelderProvider>(context, listen: false);
    final navigationProvider = Provider.of<NavigationProvider>(context, listen: false);

    navigationProvider.setPaymentScreen(verhelderProvider.helderData!);
  }

}

class HelderTextBlock extends StatelessWidget {
  final String title;
  final String text; 

  
  const HelderTextBlock({
    super.key,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: HelderText.smallTitleTextStyle,),
          Text(text, style: HelderText.breadStyle)
        ],
      ),
    );
  }
}

class HelderExpandableText extends StatelessWidget {
  final String title;
  final String text;


  const HelderExpandableText({
    super.key,

    required this.title,
    required this.text
  });

    @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min, // Center vertically
        children: [
          ExpansionTile(
            title: const Text('Volledige brief'),
            backgroundColor: HelderColors.lightGrey,
            collapsedBackgroundColor: HelderColors.lightGrey,
            collapsedShape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                ), 
              ),
            ],
          ),
        ],
      ),
    );
  }
}