import 'package:flutter/material.dart';
import 'package:helder_proto/common/widgets/navigation_bar.dart';
import 'package:helder_proto/features/templates/base_header_page.dart';

class HeaderPage extends StatelessWidget {
  final Widget child;
  const HeaderPage({super.key, this.child = const Text("Empty")});

  @override
  Widget build(BuildContext context) {
    return BaseHeaderPage(
      child: child,
    ); 
  }
}

class HeaderPageNav extends StatelessWidget {
  final Widget child;
  final int currentIndex;

  const HeaderPageNav({
    super.key,
    required this.currentIndex,
    this.child = const Text("Empty")
  });

  @override
  Widget build(BuildContext context) {
    return BaseHeaderPage(
      bottomNavigationBar: NavigationMenu(currentIndex: currentIndex),
      child: child,
    ); 
  }
}