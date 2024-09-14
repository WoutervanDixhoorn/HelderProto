import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'package:helder_proto/providers/navigation_provider.dart';
import 'package:helder_proto/providers/ocr_controller.dart';
import 'package:helder_proto/utils/helpers/helper_functions.dart';


class CameraProvider extends ChangeNotifier with WidgetsBindingObserver {
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
  //final OcrController ocrController = OcrController();

  CameraProvider(){
    onInit();
  }

  void onInit() {
    WidgetsBinding.instance.addObserver(this);
    requestCameraPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    //ocrController.dispose();
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

  Future<XFile?> takePicture() async {
    if (!isCameraInitialized) return null;
    try {
      log("Taking picture!");
      return await cameraController!.takePicture();
    } catch (e) {
      return null;
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
