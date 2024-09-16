import 'dart:developer';

import 'package:helder_proto/common/widgets/payment_card.dart';
import 'package:helder_proto/data/services/database_service.dart';
import 'package:helder_proto/models/helder_renderable_data.dart';
import 'package:helder_proto/models/helder_text_info_data.dart';
import 'package:helder_proto/utils/constants/enums.dart';

class HelderTax extends HelderRenderableData {
  int id;
  
  TextInfo textInfo;
  TaxKind kind;
  num amount;
  DateTime paymentDeadline;
  DateTime? isPayedDate;
  bool isPayed;

  HelderTax({
    this.id = -1,

    required this.textInfo,
    required this.kind,
    required this.amount,
    required this.paymentDeadline,

    this.isPayedDate,
    required this.isPayed,
  });

  HelderTax.empty()
    : id = -1,
      textInfo = TextInfo.empty(),
      kind = TaxKind.inkomstenBelasting,
      amount = 0.0,
      paymentDeadline = DateTime(1),
      isPayedDate = DateTime(1),
      isPayed = false;

  factory HelderTax.fromMap(Map<String, Object?> map, TextInfo textInfo) {
    return HelderTax(
      id: map['Id'] as int? ?? -1,
      textInfo: textInfo,
      kind: TaxKind.values.byName(map['TaxKind'] as String? ?? 'overigeBelasting'),
      amount: map['Amount'] as num? ?? 0.0,
      paymentDeadline: DateTime.parse(map['PaymentDeadline'] as String? ?? '1970-01-01'),
      isPayedDate:  DateTime.parse(map['IsPayedDate'] as String? ?? '1970-01-01'),
      isPayed: (map['IsPayed'] as int? ?? 0) == 1,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'Id': id,
      'TextInfo': textInfo.toMap(),
      'TaxKind': kind.name,
      'Amount': amount,
      'PaymentDeadline': paymentDeadline.toIso8601String(),
      'IsPayedDate': isPayedDate?.toIso8601String() ?? '',
      'IsPayed': isPayed ? 1 : 0,
    };
  }

  @override
  int getId() {
    return id;
  }

  @override
  Future<void> insertOrUpdate(DatabaseService databaseService) async {
    if (id == -1) {
      int insertedId = await databaseService.addTax(this);
      log('Inserted new tax with ID: $insertedId');
      id = insertedId;
    } else {
      await databaseService.updateTax(this);
      log('Updated tax with ID: $id');
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
  String getFullText() {
    return textInfo.content;
  }

  @override
  String getSimplifiedContent() {
    return textInfo.simplifiedContent;
  }

  @override
  String getSubject() {
    return kind.kindName;
  }

  @override
  Paymentcard toPaymentCard() {
    return Paymentcard(
      helderData: this,

      isPayed: isPayed,
      isPayedDate: isPayedDate,

      amount: amount.toString(), 
      letterSource: "Belastingdienst", //TODO: Misschien dit ook uit de json van de chatgpt krijgen 
      paymentDate: paymentDeadline
    );
  }
}
