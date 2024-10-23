
import 'dart:async';
import 'package:flutter/material.dart';

import 'package:helder_proto/common/widgets/helder_remission_text.dart';
import 'package:helder_proto/common/widgets/payment_card.dart';
import 'package:helder_proto/data/services/database_service.dart';
import 'package:helder_proto/models/helder_text_info_data.dart';

abstract class HelderRenderableData {
  int getId();
  TextInfo getTextInfo();

  HelderRemissionText getRemissionText();
  Widget getPaymentScreenInfoBlock();

  bool isRecievingMoney();
  bool getIsPayed();

  Paymentcard toPaymentCard(); 

  Future<void> insertOrUpdate(DatabaseService databaseService);
  Future<void> markAsPayed(DatabaseService databaseService);
  Future<void> markAsNotPayed(DatabaseService databaseService);
}