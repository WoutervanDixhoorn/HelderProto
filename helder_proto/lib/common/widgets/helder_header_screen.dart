import 'package:flutter/material.dart';
import 'package:helder_proto/common/widgets/helder_appbar.dart';

class HeaderPage extends StatelessWidget {
  final String title;
  final Widget child;

  const HeaderPage({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HelderAppbar(title: title),
      body: child,
    );
  }

}