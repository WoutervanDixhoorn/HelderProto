import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:helder_proto/common/styles/text_styles.dart';
import 'package:helder_proto/utils/constants/colors.dart';
import 'package:helder_proto/utils/helpers/helper_functions.dart';

class Paymentcard extends StatelessWidget {
  final String amount;
  final String reciever;
  final DateTime payDate;
  final bool isPayed;

  const Paymentcard({
    super.key,

    required this.amount,
    required this.reciever,
    required this.payDate,
    this.isPayed = false
  });

  @override
  Widget build(BuildContext context){

    return Center(
      child: Container(
        width: THelperFunctions.screenWidth() * 0.85, //Got measurements from Figma
        height: THelperFunctions.screenHeight() * 0.17, //Got measurements from Figma

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 5
            )
          ]
        ),

        child: Row(
          children: [
            getLeftPanel(),
            getRightPanel()
          ],
        ),
      ),
    );
  }

  getLeftPanel() {
    PanelColors colors = getLeftPanelColors();

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: colors.panelColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            bottomLeft: Radius.circular(16),
          ),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Expanded(
              child: Align(
                alignment: Alignment.topLeft,
                child: getLeftPanelTop(colors.textColor)
              )
            ),

            Expanded(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: getLeftPanelBottom(colors.textColor)
              )
            )
            

          ],
        ),
      ),
    );
  }

  PanelColors getLeftPanelColors() {
    int daysLeft = payDate.difference(DateTime.now()).inDays;

    PanelColors colors = PanelColors();
    colors.panelColor = HelderColors.yellow;

    if(daysLeft <= 28) { //Binnen vier weken betalen
      colors.panelColor = HelderColors.orange;
    }

    if(daysLeft <= 7) { //Binnen een week betalen
      colors.panelColor = HelderColors.red;
    }

    if(isPayed) {
      colors.panelColor = HelderColors.green;
      colors.textColor = HelderColors.white;
    }

    return colors;
  }

  getLeftPanelTop(Color textColor) {
    final euros = amount.split('.')[0];
    final cents = amount.split('.')[1];

    TextStyle euroStyle = TextStyle(
      color: textColor, 
      fontFamily: 'Rota', 
      fontWeight: FontWeight.bold, 
      fontSize: 36
    );

    TextStyle centsStyle = TextStyle(
      color: textColor, 
      fontFamily: 'Rota', 
      fontWeight: FontWeight.bold, 
      fontSize: 16
    );
  
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '- €$euros,',
            style: euroStyle 
          ),
          WidgetSpan(
            alignment: PlaceholderAlignment.top,
            child: Text(
              cents,
              style: centsStyle,
            ),
          )
        ],
      ),
    );
  }

  getLeftPanelBottom(Color textColor) {
    TextStyle payToStyle = TextStyle(
      color: textColor, 
      fontFamily: 'Rota', 
      fontWeight: FontWeight.w300, 
      fontSize: 16
    );

    TextStyle recieverStyle = TextStyle(
      color: textColor, 
      fontFamily: 'Rota', 
      fontWeight: FontWeight.bold,
      fontSize: 16
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          "Betalen aan:",
          style: payToStyle,
        ),

        Flexible(
          child: Text(
            reciever,
            textAlign: TextAlign.start,
            overflow: TextOverflow.visible,
            style: recieverStyle
          ),
        )

      ]
    );
  }

  getRightPanel() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),

        decoration: const BoxDecoration(
          color: HelderColors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            
            Expanded(
              child: Align(
                alignment: Alignment.topRight,
                child: getRightPanelTop()
              )
            ),

            Expanded(
              child: Align(
                alignment: Alignment.bottomRight,
                child: getRightPanelBottom(),
              )
            )

          ],
        )

      ),
    );
  }

  getRightPanelTop() {
    String formattedDate = DateFormat('d MMMM yyyy', 'nl').format(payDate);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [

        const Text(
          "Betalen voor:",
          style: HelderText.payToTextStyle,
        ),

        Flexible(
          child: Text(
            formattedDate,
            textAlign: TextAlign.start,
            overflow: TextOverflow.visible,
            style: HelderText.smallTitleTextStyle
          ),
        )

      ]
    );
  }

  getRightPanelBottom() {
    int daysLeft = payDate.difference(DateTime.now()).inDays;

    return RichText(
      textAlign: TextAlign.right,
      text: TextSpan(
        text: "nog ",
        style: HelderText.payToTextStyle,
        children: [
          TextSpan(
            text: "$daysLeft dagen\n",
            style: HelderText.smallTitleTextStyle
          ),
          const TextSpan(
            text: " om te betalen.",
            style: HelderText.payToTextStyle
          )
        ]
      ),
    );
  }

}

class PanelColors {
  Color textColor = HelderColors.darkGrey;
  Color panelColor = HelderColors.green;
}