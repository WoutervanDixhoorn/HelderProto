import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:helder_proto/features/scanner/controllers/ocr_controller.dart';
import 'package:helder_proto/features/scanner/screens/result.dart';
import 'package:helder_proto/utils/helpers/helper_functions.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';

class ScannerController extends GetxController with WidgetsBindingObserver {
  var isPermissionGranted = false.obs;
  var isCameraInitialized = false.obs;
  CameraController? cameraController;
   final OcrController ocrController = OcrController();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    requestCameraPermission();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    ocrController.dispose();
    cameraController?.dispose();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      stopCamera();
    } else if (state == AppLifecycleState.resumed) {
      startCamera();
    }
  }

  Future<void> requestCameraPermission() async {
    final status = await Permission.camera.request();
    isPermissionGranted.value = status == PermissionStatus.granted;
    if (isPermissionGranted.value) {
      await initializeCamera();
    }
  }

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      await cameraSelected(cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back,
          orElse: () => cameras.first));
    }
  }

  void startCamera() {
    if (cameraController != null) {
      cameraSelected(cameraController!.description);
    }
  }

  void stopCamera() {
    cameraController?.dispose();
  }

  Future<void> cameraSelected(CameraDescription camera) async {
    cameraController = CameraController(camera, ResolutionPreset.max, enableAudio: false);
    await cameraController?.initialize();
    isCameraInitialized.value = cameraController!.value.isInitialized;
  }

  Future<void> scanImage() async {
    if (cameraController == null) return;
    try {
      final pictureFile = await cameraController!.takePicture();
      final file = File(pictureFile.path);
      final recognizedText = await ocrController.extractTextFromFile(file);

      Get.to(() => ResultScreen(text: recognizedText));
    } catch (e) {
      Get.snackbar('Error', 'An error occurred when scanning text');
    }
  }

  double getDeviceRatio() {
      final size = THelperFunctions.screenSize();
      final deviceRatio = size.width / size.height;
      
      return deviceRatio;
  }

  Matrix4 getCameraViewTransform() {
      return Matrix4.diagonal3Values(cameraController!.value.aspectRatio, 1, 1);
  }
  
}
