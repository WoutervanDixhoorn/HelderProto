import 'package:flutter/material.dart';
import 'package:helder_proto/features/result/scanresult_screen.dart';
import 'package:helder_proto/features/scanner/screens/payment.dart';
import 'package:helder_proto/models/helder_invoice.dart';
import 'package:provider/provider.dart';

import 'package:helder_proto/features/accounts/accounts.dart';
import 'package:helder_proto/features/scanner/screens/result.dart';
import 'package:helder_proto/features/scanner/screens/scanner.dart';
import 'package:helder_proto/utils/constants/colors.dart';

import 'package:helder_proto/providers/verhelder_provider.dart';
import 'package:helder_proto/features/scanner/controllers/scanner_provider.dart';

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
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context){
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => ScannerProvider()),
        ChangeNotifierProvider(create: (_) => VerhelderProvider())
      ],
      child: Scaffold(
        bottomNavigationBar: Consumer<NavigationProvider>(
          builder: (context, provider, child ) => NavigationBar(
            backgroundColor: HelderColors.darkGrey,
            height: 100,
            elevation: 0,
            selectedIndex: provider.selectedIndex,
            onDestinationSelected: (index) => provider.selectedIndex = index,
          
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
        body: Consumer<NavigationProvider>(
          builder: (context, provider, child ) { 
            return provider.screens[provider.selectedIndex]; 
          },
        ),
      ),
    );
  }
}

class NavigationProvider extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  
  //List<Widget> screens = [ScannerScreen(), AccountsScreen(), ResultScreen()];
  // ignore: prefer_const_constructors
  List<Widget> screens = [ScannerScreen(), AccountsScreen(), ScanResultScreen()];

  void setResultScreen(String recognizedText) {
    screens[1] = ResultScreen(letterContent: recognizedText);
    selectedIndex = 1;
    notifyListeners();
  }

  void setPaymentScreen(HelderInvoice data) {
    screens[1] = PaymentScreen(invoiceData: data);
    selectedIndex = 1;
    notifyListeners();
  }
}