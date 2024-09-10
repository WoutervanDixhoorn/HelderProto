
import 'package:flutter/material.dart';
import 'package:helder_proto/common/styles/text_styles.dart';
import 'package:helder_proto/utils/constants/colors.dart';

class HelderAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  
  const HelderAppbar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HelderColors.purple,
      height: 135,
      child: Stack(
        children: [

          Positioned(
            top: 45,
            left: 40,
            right: 0,
            child: getText()
          )

        ],
      ),
    );
  }
  
  getText() {
    return Text(
      title,
      style: HelderText.pageTitleTextStyle,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(135);

}