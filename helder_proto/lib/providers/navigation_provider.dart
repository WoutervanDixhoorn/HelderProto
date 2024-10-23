import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:helder_proto/features/accounts/accounts_screen.dart';
import 'package:helder_proto/features/infoscreens/is_duplicate_screen.dart';
import 'package:helder_proto/features/payment/payment_screen.dart';
import 'package:helder_proto/features/result/result.dart';
import 'package:helder_proto/features/scanner/camera_screen.dart';
import 'package:helder_proto/models/helder_renderable_data.dart';
import 'package:helder_proto/providers/scanner_provider.dart';
import 'package:helder_proto/providers/verhelder_provider.dart';
import 'package:provider/provider.dart';

class NavigationProvider extends ChangeNotifier {
  int _selectedIndex = 0;
  bool _resetProvidersOnSwitch = false;

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  // ignore: prefer_const_constructors
  final List<Widget> initialScreens = [ScannerScreen(), AccountsScreen(), AccountsScreen()];
  // ignore: prefer_const_constructors
  List<Widget> _screens = [ScannerScreen(), AccountsScreen(), AccountsScreen()];

  set screens(List<Widget> screens) {
    _screens = screens;
  }

  List<Widget> get screens => _screens;

  void setResultScreen(XFile pictureFile) {
    screens[1] = ResultScreen(pictureFile: pictureFile);
    _resetProvidersOnSwitch = true;
    selectedIndex = 1;
    notifyListeners();
  }

  void setPaymentScreen(HelderRenderableData helderData) {
    screens[1] = PaymentScreen(helderData: helderData);
    _resetProvidersOnSwitch = true;
    selectedIndex = 1;
    notifyListeners();
  }

  void setAccountsScreen(bool payedAccounts) {
    screens[1] = AccountsScreen(payedAccounts: payedAccounts);
    selectedIndex = 1;
    notifyListeners();
  }

  void setIsDuplicateScreen(HelderRenderableData helderData) {
    screens[1] = IsDuplicateScreen(helderData: helderData);
    _resetProvidersOnSwitch = true;
    selectedIndex = 1;
    notifyListeners();
  }

  void resetState(BuildContext context) {
    resetProviders(context);

    screens = initialScreens;
    notifyListeners();
  }

  void resetProviders(BuildContext context) {
    final scannerProvider = Provider.of<ScannerProvider>(context, listen: false);
    final verhelderProvider = Provider.of<VerhelderProvider>(context, listen: false);

    scannerProvider.reset();
    verhelderProvider.reset();
  }

  void requestResetOnSwitch() {
    _resetProvidersOnSwitch = true;
  }

  void selectedIndexWithReset(BuildContext context, int index) {
    if (_resetProvidersOnSwitch) {
      resetState(context);
      _resetProvidersOnSwitch = false;
    }
    selectedIndex = index;
  }
}