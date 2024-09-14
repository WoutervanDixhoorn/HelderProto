import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:helder_proto/navigation_menu.dart';

class AgreementController extends GetxController {
  static AgreementController get instance => Get.find();

  void doAgreeClick() {
    final deviceStorage = GetStorage();
    deviceStorage.write('isFirstTime', false);  	
    Get.offAll(const NavigationMenu());
  }
}