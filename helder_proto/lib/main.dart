import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';

//FOR DELETING DATABASE ONLY
import 'package:helder_proto/data/services/database_service.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:helder_proto/app.dart';

Future<void> main() async {
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // FOR DEVELOPMENT ONLY - DELETES DATABASE
  // final databaseService = DatabaseService.instance;
  // final databaseDirPath = await getDatabasesPath();
  // final databasePath = join(databaseDirPath, "master_db.db");
  // await databaseService.deleteDatabase(databasePath);

  await GetStorage.init();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await initializeDateFormatting('nl_NL', null);

  runApp(const HelderApp());
}

