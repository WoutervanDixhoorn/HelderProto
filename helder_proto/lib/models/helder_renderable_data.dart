
import 'dart:async';

import 'package:helder_proto/common/widgets/payment_card.dart';
import 'package:helder_proto/data/services/database_service.dart';

abstract class HelderRenderableData {
  int getId();
  String getSubject(); 
  String getFullText(); 
  String getSimplifiedContent();

  Future<void> insertOrUpdate(DatabaseService databaseService);
  Future<void> markAsPayed(DatabaseService databaseService);
  Future<void> markAsNotPayed(DatabaseService databaseService);

  Paymentcard toPaymentCard(); 
}