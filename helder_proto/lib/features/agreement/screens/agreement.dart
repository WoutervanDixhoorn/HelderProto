import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helder_proto/common/widgets/helder_buttons.dart';
import 'package:helder_proto/features/agreement/controllers/agreement_controller.dart';
import 'package:helder_proto/features/templates/header_page.dart';
import 'package:helder_proto/common/styles/text_styles.dart';
import 'package:helder_proto/common/widgets/info_card.dart';
import 'package:helder_proto/utils/constants/text_strings.dart';

class AgreementScreen extends StatelessWidget {
  const AgreementScreen({super.key});

  @override
  Widget build(BuildContext context){
    return const HeaderPage(
      child: Agreement(),
    );
  }
}

class Agreement extends StatelessWidget {
  const Agreement({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AgreementController());

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 30.0),
          child: const Text(
            TTexts.agreementTitle,
            style: HelderText.titleTextStyle,
          ),
        ),
        Column(
          children: TTexts.agreementPoints.map((info) => InfoCard(text: info)).toList(),
        ),
        HelderBigButton(
          text: 'akkoord en sluiten',
          onPressed: controller.doAgreeClick,
        ),
      ],
    );
  }
}