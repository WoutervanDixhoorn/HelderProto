import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';

import 'package:helder_proto/providers/app_provider.dart';

class HelderApp extends StatelessWidget {
  const HelderApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider())
      ],

      child: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            home: appProvider.mainApplicationWidget
          );
        }
      )
    );
  }

}