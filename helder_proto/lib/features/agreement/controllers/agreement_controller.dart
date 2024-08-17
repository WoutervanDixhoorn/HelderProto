import 'package:get/get.dart';
import 'package:helder_proto/features/scanner/screens/scanner.dart';

class AgreementController extends GetxController {
  static AgreementController get instance => Get.find();

  void doAgreeClick() {
    // Do some agreeing and saving of values
    Get.to(const ScannerScreen());
  }
}