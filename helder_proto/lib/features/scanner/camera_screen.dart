import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:helder_proto/common/shapes/rouded_corner_border_camera.dart';
import 'package:helder_proto/providers/navigation_provider.dart';
import 'package:helder_proto/utils/constants/colors.dart';
import 'package:helder_proto/providers/camera_provider.dart';
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
    return Consumer<CameraProvider>(
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

class ScannerCameraView extends StatefulWidget {
  const ScannerCameraView({super.key});

  @override
  State<ScannerCameraView> createState() => _ScannerCameraViewState();
}

class _ScannerCameraViewState extends State<ScannerCameraView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final navigationProvider = Provider.of<NavigationProvider>(context, listen: false);
      navigationProvider.resetProviders(context);
    });
  }

  @override
  Widget build(BuildContext context) {
  
    return Consumer<CameraProvider>(
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  
                  const RoundedCornerBorderContainer(),

                  //Padding
                  const SizedBox(
                    height: 30
                  ),

                  Container(
                    width: 150,
                    height: 25,
                    decoration: BoxDecoration(
                      color: HelderColors.darkGrey,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: const Center(
                      child: Text(
                        'scan de brief',
                        style: TextStyle(
                          color: HelderColors.white
                        ),
                      ),
                    ),
                  ),
              
                  //BUTTON
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5, top: 15),
                    child: HelderScanButton(
                      onPressed: () async {
                        XFile? pictureFile = await provider.takePicture();
                    
                        if (!mounted) return;
                    
                        if(pictureFile != null){
                          // ignore: use_build_context_synchronously
                          final navigationProvider = Provider.of<NavigationProvider>(context, listen: false);
                          navigationProvider.setResultScreen(pictureFile);
                        }
                      },
                    ),
                  ),
              
                ],
              ),
            ),

          ],
        );
      }
    );
  }
}