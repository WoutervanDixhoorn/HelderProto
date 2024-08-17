import 'package:flutter/material.dart';
import 'package:helder_proto/utils/constants/colors.dart';
import 'package:helder_proto/common/styles/text_styles.dart';
import 'package:helder_proto/utils/helpers/helper_functions.dart';

class BaseHeaderPage extends StatelessWidget {
  final Widget child;
  final Widget? bottomNavigationBar;

  const BaseHeaderPage({
    super.key, 
    this.child = const Text("Empty"),
    this.bottomNavigationBar
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HelderColors.purple,
        toolbarHeight: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 20),
            width:  THelperFunctions.screenWidth(),
            height: 80,
            decoration: const BoxDecoration(
              color: HelderColors.purple,
            ),
            child: const Text(
              "Helder", 
              style: HelderText.pageTitleTextStyle
            )
          ),
          Expanded(
            child: Center(
              child: child,
            )
          )
        ],
      ),
      bottomNavigationBar: bottomNavigationBar
    );
  }
}