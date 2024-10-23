import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_shadow/simple_shadow.dart';

import 'package:helder_proto/common/styles/text_styles.dart';
import 'package:helder_proto/common/widgets/helder_buttons.dart';
import 'package:helder_proto/models/helder_renderable_data.dart';
import 'package:helder_proto/providers/navigation_provider.dart';
import 'package:helder_proto/utils/constants/colors.dart';
import 'package:helder_proto/common/shapes/warning_shape_svg.dart';
import 'package:helder_proto/features/infoscreens/info_screen_layout.dart';

class IsDuplicateScreen extends StatelessWidget {
  final HelderRenderableData helderData;

  const IsDuplicateScreen({
    super.key,

    required this.helderData
  });

  @override
  Widget build(BuildContext context) {
    NavigationProvider navigationProvider = Provider.of<NavigationProvider>(context);

    return InfoScreenLayout(

      infoLogo: Padding(
        padding: const EdgeInsets.only(top: 50, left: 15),
        child: SimpleShadow(
          opacity: 0.6,
          color: HelderColors.darkGrey,
          child: warningSvg,
        )
      ),

      infoText: getInfoText(),

      infoButton: Container(
        margin: const EdgeInsets.only(top: 20),
        width: 240,
        height: 50,
        child: HelderBigButton(
          text: 'Terug',
          onPressed: () => onHelderButton(navigationProvider)
        ),
      ),

    );
  }

  onHelderButton(NavigationProvider navigationProvider) {
    navigationProvider.setAccountsScreen(false);
  }

  getInfoText() {
    return RichText(
      textAlign: TextAlign.center,
      text: const TextSpan(
        children: <TextSpan> [

          TextSpan(
            text: "Deze brief is al gescand.\n",
            style: HelderText.bigBoldTextStyleDark
          ),

          TextSpan(
            text: "Neem een kijkje of je deze al hebt betaald.\n\n",
            style: HelderText.w300TextStyleDark
          ),

          TextSpan(
            text: "Kom je er niet uit?\nVraag om hulp in je omgeving.",
            style: HelderText.w300TextStyleDark
          )

        ]
      )
    );
  }

}