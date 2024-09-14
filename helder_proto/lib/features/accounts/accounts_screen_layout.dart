import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:helder_proto/common/widgets/helder_header_screen.dart';

class AccountsScreenLayout extends StatelessWidget {
  final Widget toggleSwitch;
  final Widget paymentCards;

  const AccountsScreenLayout({
    super.key,

    required this.toggleSwitch,
    required this.paymentCards
  });

  @override
  Widget build(BuildContext context) {
    return HeaderPage(
      title: "Rekeningen",
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double totalHeight = constraints.maxHeight;
          final double toggleSwitchHeight = (2 / 14) * totalHeight;

        return Stack(
            children: [

              paymentCards,

              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: toggleSwitchHeight,
                child: Center(
                  child: toggleSwitch,
                ),
              ),
            ],
          );
        }

      )
    );
  }
}