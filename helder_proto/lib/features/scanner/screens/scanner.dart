
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helder_proto/common/widgets/navigation_bar.dart';
import 'package:helder_proto/features/scanner/controllers/scanner_controller.dart';
import 'package:helder_proto/common/widgets/helder_buttons.dart';
import 'package:helder_proto/features/templates/header_page.dart';

class ScannerScreen extends StatelessWidget {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Scanner(),
    );
  }
}

class Scanner extends StatelessWidget {
  const Scanner({super.key});

  @override
  Widget build(BuildContext context) {
    final ScannerController controller = Get.put(ScannerController());

    return Obx(() {
      if (!controller.isPermissionGranted.value) {
        return const Scaffold(
          body: HeaderPageNav(
            currentIndex: 0,
            child: Text(
              'Camera permission denied',
              textAlign: TextAlign.center,
            ),
          ),
        );
      }

      if (!controller.isCameraInitialized.value) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      return Scaffold(
        body: ScannerCameraView(
              controller: controller,
        ),
        bottomNavigationBar: const NavigationMenu(currentIndex: 0),
      );
    });
  }
}

class ScannerCameraView extends StatelessWidget {
  final ScannerController controller;
  const ScannerCameraView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: controller.getDeviceRatio(),
          child: Transform(
            alignment: Alignment.center,
            transform: controller.getCameraViewTransform(),
            child: CameraPreview(controller.cameraController!),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: HelderScanButton(
            onPressed: controller.scanImage,
          ),
        ),
      ],
    );
  }
}