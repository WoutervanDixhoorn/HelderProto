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
import 'package:intl/intl.dart';

class HelderInvoice extends HelderRenderableData {
  int id;

  TextInfo textInfo;
  InvoiceKind kind;
  double amount;
  DateTime paymentDeadline;
  DateTime? isPayedDate;
  bool isPayed;

  HelderInvoice({
    this.id = -1,

    required this.textInfo,
    required this.kind,
    required this.amount,
    required this.paymentDeadline,

    this.isPayedDate,
    required this.isPayed,
  });

  HelderInvoice.empty()
    : id = -1,
      textInfo = TextInfo.empty(),
      kind = InvoiceKind.overig,
      amount = 0.0,
      paymentDeadline = DateTime(1),
      isPayedDate = DateTime(1),
      isPayed = false;

  factory HelderInvoice.fromMap(Map<String, Object?> map, TextInfo textInfo) {
    return HelderInvoice(
      id: map['Id'] as int? ?? -1,
      textInfo: textInfo,
      kind: InvoiceKind.values.byName(map['SpecificKind'] as String? ?? 'dienst'),
      amount: double.tryParse(map['Amount']?.toString() ?? '') ?? 0.0,
      paymentDeadline: DateTime.parse(map['PaymentDeadline'] as String? ?? '1970-01-01'),
      isPayedDate:  DateTime.parse(map['IsPayedDate'] as String? ?? '1970-01-01'),
      isPayed: (map['IsPayed'] as int? ?? 0) == 1,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'Id': id,
      'TextInfo': textInfo.toMap(),
      'SpecificKind': kind.name,
      'Amount': amount,
      'PaymentDeadline': paymentDeadline.toIso8601String(),
      'IsPayedDate': isPayedDate?.toIso8601String() ?? DateTime(0).toIso8601String(),
      'IsPayed': isPayed ? 1 : 0,
    };
  }

  @override
  int getId() => id;
  
  @override
  TextInfo getTextInfo() => textInfo;

  @override
  bool isRecievingMoney() => false;

  @override
  bool getIsPayed() => isPayed;

  @override
  HelderRemissionText getRemissionText() {
    return const HelderRemissionText(
      remissionText: <TextSpan> [
          //Empty for now, invoice doesnt have possibilty for remision. 
          //Maybe another helpful text could be shown here!
      ]
    );
  }

  @override
  Widget getPaymentScreenInfoBlock() {
    String formattedDate = DateFormat('d MMMM', 'nl').format(paymentDeadline);

    String bottomExtraInfo = TTexts.dontNeedToPayToday(formattedDate);
    if(paymentDeadline.isBefore(DateTime.now())){
      bottomExtraInfo = TTexts.paymentTooLate(formattedDate);
    }

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (!isPayed) ...[
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                TTexts.canYouPayNowText,
                style: HelderText.breadStyle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                textAlign: TextAlign.center,
                bottomExtraInfo,
                style: HelderText.remissionStyle,
              ),
            ),
          ] else ...[
            const Padding(
              padding: EdgeInsets.only(top: 40),
              child: Text(
                textAlign: TextAlign.center,
                "Deze rekening is al betaalt. Goed bezig!",
                style: HelderText.remissionStyle,
              )
            )
          ]
        ]
      ),
    );
  }

  @override
  Future<void> insertOrUpdate(DatabaseService databaseService) async {
    if (id == -1) {
      int insertedId = await databaseService.addInvoice(this);
      log('Inserted new invoice with ID: $insertedId');
      id = insertedId;
    } else {
      await databaseService.updateInvoice(this);
      log('Updated invoice with ID: $id');
    }
  }

  @override
  Future<void> markAsPayed(DatabaseService databaseService) async {
    isPayed = true;
    isPayedDate = DateTime.now();
    await insertOrUpdate(databaseService);
  }

  @override
  Future<void> markAsNotPayed(DatabaseService databaseService) async {
    isPayed = false;
    await insertOrUpdate(databaseService);
  }

  @override
  Paymentcard toPaymentCard() {
    return Paymentcard(
      helderData: this,

      isPayed: isPayed,
      isPayedDate: isPayedDate,

      amount: amount.toString(), 
      letterSource: textInfo.sender, 
      paymentDate: paymentDeadline,
    );
  }
}
