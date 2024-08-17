import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helder_proto/features/scanner/screens/result.dart';
import 'package:helder_proto/features/scanner/screens/scanner.dart';
import 'package:helder_proto/utils/constants/colors.dart';

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
              color: isSelected ? Colors.white : Colors.white,
            ),
    );
  }
}

class NavigationMenu extends StatelessWidget {
  final int currentIndex;
  const NavigationMenu({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context){
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: NavBarItem(iconPath: 'assets/icons/scan.png', isSelected: currentIndex == 0),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: NavBarItem(iconPath: 'assets/icons/rekening.png', isSelected: currentIndex == 1),
          label: ''
        ),
        BottomNavigationBarItem(
          icon: NavBarItem(iconPath: 'assets/icons/brief.png', isSelected: currentIndex == 2),
          label: ''
        ),
      ],
      currentIndex: currentIndex,
      onTap: (value) => {
        if(value == 0){
          Get.to(() => const ScannerScreen())
        }else if(value == 1){
          Get.to(() => const ResultScreen())
        }else if(value == 2){
          Get.to(() => const ResultScreen())
        }
      },
      showSelectedLabels: false,
      showUnselectedLabels: false,
      iconSize: 40.0,
      backgroundColor: HelderColors.darkGrey
    );
  }
}