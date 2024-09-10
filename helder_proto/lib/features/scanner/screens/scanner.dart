import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:helder_proto/features/scanner/controllers/scanner_provider.dart';
import 'package:helder_proto/common/widgets/helder_buttons.dart';

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
    return Consumer<ScannerProvider>(
      builder: (context, provider, child ) {
      if (!provider.isPermissionGranted) {
        return const Scaffold(
          body: Text(
            'Camera permission denied',
            textAlign: TextAlign.center,
          ),
        );
      }

      if (!provider.isCameraInitialized) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      return const ScannerCameraView();
    });
  }
}

class ScannerCameraView extends StatelessWidget {
  const ScannerCameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ScannerProvider>(
      builder: (context, provider, child ) {
        return Stack(
          children: [
            AspectRatio(
              aspectRatio: provider.getDeviceRatio(),
              child: Transform(
                alignment: Alignment.center,
                transform: provider.getCameraViewTransform(),
                child: CameraPreview(provider.cameraController!),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: HelderScanButton(
                onPressed: () => provider.scanImage(context),
              ),
            ),
          ],
        );
      }
    );
  }
}