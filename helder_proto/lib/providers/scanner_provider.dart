import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helder_proto/providers/ocr_controller.dart';

import 'package:helder_proto/providers/verhelder_provider.dart';
import 'package:provider/provider.dart';

class ScannerProvider extends ChangeNotifier {
  final OcrController ocrController = OcrController();

  bool _apiCallMade = false;
  bool get apiCallMade => _apiCallMade;

  bool isLoading = true;
  String error = "";
  late String recognizedText;

  void reset() {
    isLoading = false;
    error = '';
    recognizedText = '';
    _apiCallMade = false;
    notifyListeners();
  }

  Future<void> scanImageAndSendToApi(BuildContext context, XFile pictureFile) async {
    final verhelderProvider = Provider.of<VerhelderProvider>(context, listen: false);

    if(_apiCallMade) {
      return;
    }

    try {
      final file = File(pictureFile.path);
      recognizedText = await ocrController.extractTextFromFile(file);
      isLoading = false;

      verhelderProvider.processLetterWithProxy(recognizedText);
      _apiCallMade = true;
    } catch (e) {
      error = 'Something went wrong while scanning the document';
      Get.snackbar('Error', 'An error occurred when scanning text');
    }
  }

  @override
  void dispose() {
    ocrController.dispose();
    super.dispose();
  }
}
