import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_storage/get_storage.dart';

import 'package:helder_proto/navigation_menu.dart';
import 'package:helder_proto/features/agreement/screens/agreement.dart';
import 'package:helder_proto/utils/constants/colors.dart';

class AppProvider extends ChangeNotifier {
  Widget _mainApplicationWidget = const Scaffold(
    backgroundColor: HelderColors.purple,
    body: Center(child: CircularProgressIndicator(color: HelderColors.white)),
  );
  
  Widget get mainApplicationWidget => _mainApplicationWidget;

  set mainApplicationWidget(Widget widget) {
    _mainApplicationWidget = widget;
    notifyListeners();
  }

  final deviceStorage = GetStorage();
  
  AppProvider() {
    onInit();
  } 

  void onInit() {
    FlutterNativeSplash.remove();
    startApplication();
  }

  startApplication() async {
    deviceStorage.writeIfNull('isFirstTime', true);
    bool isFirstTime = deviceStorage.read('isFirstTime');
  
    if (isFirstTime) {
      mainApplicationWidget = const AgreementScreen();
    } else {
      mainApplicationWidget = const NavigationMenu();
    }
  }

}