import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:helder_proto/features/agreement/screens/agreement.dart';

void main() {
  runApp(const HelderApp());
}
  
class HelderApp extends StatelessWidget {
  const HelderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      title: 'Helder',
      home: AgreementScreen(),
    );
  }
}