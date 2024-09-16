import 'dart:developer';

import 'package:helder_proto/common/widgets/payment_card.dart';
import 'package:helder_proto/data/services/database_service.dart';
import 'package:helder_proto/models/helder_renderable_data.dart';
import 'package:helder_proto/models/helder_text_info_data.dart';
import 'package:helder_proto/utils/constants/enums.dart';

class HelderAllowance extends HelderRenderableData{
  int id;

  TextInfo textInfo;
  AllowanceKind kind;
  num amount;
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
      kind: AllowanceKind.values.byName(map['AllowanceKind'] as String? ?? 'overigeToeslag'),
      amount: map['Amount'] as num? ?? 0.0,
      startDate: DateTime.parse(map['StartDate'] as String? ?? '1970-01-01'),
      endDate: DateTime.parse(map['EndDate'] as String? ?? '1970-01-01'),
    );
  }

  Map<String, Object?> toMap() {
    return {
      'Id': id,
      'TextInfo': textInfo.toMap(),
      'AllowanceKind': kind.name,
      'Amount': amount,
      'StartDate': startDate.toIso8601String(),
      'EndDate': endDate.toIso8601String(),
    };
  }

  @override
  int getId() {
    return id;
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

  @override
  String getSubject() {
    return kind.kindName;
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
  Paymentcard toPaymentCard() {
    return Paymentcard(
      helderData: this,

      amount: amount.toString(),
      letterSource: kind.kindName, //TODO: Get source from TextInfo when added!

      paymentDate: startDate,
      paymentEndDate: endDate,

      isRecievingMoney: true,
    );
  }
}
