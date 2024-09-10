import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'package:helder_proto/navigation_menu.dart';
import 'package:helder_proto/features/scanner/controllers/ocr_provider.dart';
import 'package:helder_proto/utils/helpers/helper_functions.dart';


class ScannerProvider extends ChangeNotifier with WidgetsBindingObserver {
  var _isPermissionGranted = false;
  bool get isPermissionGranted => _isPermissionGranted;
  set isPermissionGranted(bool value) {
    _isPermissionGranted = value;
    notifyListeners();
  }

  var _isCameraInitialized = false;
  bool get isCameraInitialized => _isCameraInitialized;
  set isCameraInitialized(bool value) {
    _isCameraInitialized = value;
    notifyListeners();
  }

  CameraController? cameraController;
  final OcrController ocrController = OcrController();

  ScannerProvider(){
    log('ScannerProvider is initialized');
    onInit();
  }

  void onInit() {
    WidgetsBinding.instance.addObserver(this);
    requestCameraPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    ocrController.dispose();
    cameraController?.dispose();
    super.dispose();
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
    isPermissionGranted = status == PermissionStatus.granted;
    if (isPermissionGranted) {
      await initializeCamera();
    }
  }

  Future<void> initializeCamera() async {
    log('initialize Camera from scannerProvider');

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
    isCameraInitialized = cameraController!.value.isInitialized;
  }

  Future<void> scanImage(BuildContext context) async {
    if (cameraController == null) return;
    final navigationProvider = Provider.of<NavigationProvider>(context, listen: false);  

    try {
      final pictureFile = await cameraController!.takePicture();
      final file = File(pictureFile.path);
      final recognizedText = await ocrController.extractTextFromFile(file);
      
      navigationProvider.setResultScreen(recognizedText);
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
