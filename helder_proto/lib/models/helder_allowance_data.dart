import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:helder_proto/common/styles/text_styles.dart';
import 'package:helder_proto/common/widgets/helder_remission_text.dart';
import 'package:helder_proto/common/widgets/payment_card.dart';
import 'package:helder_proto/data/services/database_service.dart';
import 'package:helder_proto/models/helder_renderable_data.dart';
import 'package:helder_proto/models/helder_text_info_data.dart';
import 'package:helder_proto/utils/constants/enums.dart';
import 'package:helder_proto/utils/constants/text_strings.dart';

class HelderAllowance extends HelderRenderableData{
  int id;

  TextInfo textInfo;
  AllowanceKind kind;
  double amount;
  DateTime startDate;
  DateTime endDate;

  HelderAllowance({
    this.id = -1,
    
    required this.textInfo,
    required this.kind,
    required this.amount,
    required this.startDate,
    required this.endDate,
  });

  HelderAllowance.empty()
    : id = -1,
      textInfo = TextInfo.empty(),
      kind = AllowanceKind.overigeToeslag,
      amount = 0.0,
      startDate = DateTime(1),
      endDate = DateTime(1);

  factory HelderAllowance.fromMap(Map<String, Object?> map, TextInfo textInfo) {
    return HelderAllowance(
      id: map['Id'] as int? ?? -1,
      textInfo: textInfo,
      kind: AllowanceKind.values.byName(map['SpecificKind'] as String? ?? 'overigeToeslag'),
      amount: double.tryParse(map['Amount']?.toString() ?? '') ?? 0.0,
      startDate: DateTime.parse(map['StartDate'] as String? ?? '1970-01-01'),
      endDate: DateTime.parse(map['EndDate'] as String? ?? '1970-01-01'),
    );
  }

  Map<String, Object?> toMap() {
    return {
      'Id': id,
      'TextInfo': textInfo.toMap(),
      'SpecificKind': kind.name,
      'Amount': amount,
      'StartDate': startDate.toIso8601String(),
      'EndDate': endDate.toIso8601String(),
    };
  }

  @override
  int getId() => id;
  
  @override
  TextInfo getTextInfo() => textInfo;

  @override
  bool isRecievingMoney() => true;

  @override
  bool getIsPayed() => true;

  @override
  HelderRemissionText getRemissionText() {
    return const HelderRemissionText(
      remissionText: <TextSpan> [
        //Empty, Allowance's dont have remissions.
        //Maybe this could house some other informatic text.
      ]
    );
  }

  @override
  Widget getPaymentScreenInfoBlock() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              TTexts.benefitsReminderText,
              style: HelderText.breadStyle
            ),
          ),
      
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                textAlign: TextAlign.center,
                TTexts.allowanceBottomInfo(amount), 
                style: HelderText.remissionStyle,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Paymentcard toPaymentCard() {
    return Paymentcard(
      helderData: this,

      amount: amount.toString(),
      letterSource: textInfo.sender,

      paymentDate: startDate,
      paymentEndDate: endDate,

      isRecievingMoney: true,
    );
  }

  @override
  Future<void> insertOrUpdate(DatabaseService databaseService) async {
    if (id == -1) {
      int insertedId = await databaseService.addAllowance(this);
      log('Inserted new allowance with ID: $insertedId');
      id = insertedId;
    }
  }

  @override
  Future<void> markAsPayed(DatabaseService databaseService) async {
    log("Allowanaces cant be payed!");
  }

  @override
  Future<void> markAsNotPayed(DatabaseService databaseService) async {
    log("Allowanaces cant be payed!");
  }
}
