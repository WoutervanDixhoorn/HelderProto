import 'package:flutter/material.dart';
import 'package:helder_proto/providers/navigation_provider.dart';
import 'package:helder_proto/providers/scanner_provider.dart';
import 'package:provider/provider.dart';

import 'package:helder_proto/utils/constants/colors.dart';
import 'package:helder_proto/providers/verhelder_provider.dart';
import 'package:helder_proto/providers/camera_provider.dart';

class NavBarItem extends StatelessWidget {
  final String iconPath;
  final bool isSelected;

  const NavBarItem({super.key, required this.iconPath, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: isSelected
        ? const BoxDecoration(
            color: HelderColors.purple, // Background color for selected item
            shape: BoxShape.circle,
        )
        : null,
      child: ImageIcon(
        AssetImage(iconPath),
        size: 40.0,
        color: HelderColors.white,
      ),
    );
  }
}

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context){
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => CameraProvider()),
        ChangeNotifierProvider(create: (_) => ScannerProvider()),
        ChangeNotifierProvider(create: (_) => VerhelderProvider())
      ],
      child: Scaffold(
        bottomNavigationBar: Consumer<NavigationProvider>(
          builder: (context, provider, child ) => ClipRRect(
            
            child: NavigationBar(
              backgroundColor: HelderColors.darkGrey,
              height: 100,
              selectedIndex: provider.selectedIndex,
              onDestinationSelected: (index) => provider.selectedIndexWithReset(context, index),
            
              destinations: [
                NavigationDestination(
                  icon: NavBarItem(iconPath: 'assets/icons/scan.png', isSelected: provider.selectedIndex == 0),
                  label: ''
                ),
                NavigationDestination(
                  icon: NavBarItem(iconPath: 'assets/icons/rekening.png', isSelected: provider.selectedIndex == 1),
                  label: ''
                ),
                NavigationDestination(
                  icon: NavBarItem(iconPath: 'assets/icons/brief.png', isSelected: provider.selectedIndex == 2),
                  label: ''
                ),
              ],
            ),
            
          ),
        ),
        body: Consumer<NavigationProvider>(
          builder: (context, provider, child ) { 
            return provider.screens[provider.selectedIndex]; 
          },
        ),
      ),
    );
  }
}