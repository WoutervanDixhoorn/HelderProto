import 'dart:developer';

import 'package:helder_proto/common/widgets/payment_card.dart';
import 'package:helder_proto/data/services/database_service.dart';
import 'package:helder_proto/models/helder_renderable_data.dart';
import 'package:helder_proto/models/helder_text_info_data.dart';
import 'package:helder_proto/utils/constants/enums.dart';

class HelderInvoice extends HelderRenderableData {
  int id;

  TextInfo textInfo;
  InvoiceKind kind;
  String sender;
  String subject;
  num amount;
  DateTime paymentDeadline;
  DateTime? isPayedDate;
  bool isPayed;

  HelderInvoice({
    this.id = -1,

    required this.textInfo,
    required this.kind,
    required this.sender,
    required this.subject,
    required this.amount,
    required this.paymentDeadline,

    this.isPayedDate,
    required this.isPayed,
  });

  HelderInvoice.empty()
    : id = -1,
      textInfo = TextInfo.empty(),
      kind = InvoiceKind.overig,
      sender = "",
      subject = "",
      amount = 0.0,
      paymentDeadline = DateTime(1),
      isPayedDate = DateTime(1),
      isPayed = false;

  factory HelderInvoice.fromMap(Map<String, Object?> map, TextInfo textInfo) {
    return HelderInvoice(
      id: map['Id'] as int? ?? -1,
      textInfo: textInfo,
      kind: InvoiceKind.values.byName(map['Kind'] as String? ?? 'dienst'),
      sender: map['Sender'] as String,
      subject: map['Subject'] as String,
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
      'Kind': kind.name,
      'Sender': sender,
      'Subject': subject,
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
  String getFullText() {
    return textInfo.content;
  }

  @override
  String getSimplifiedContent() {
    return textInfo.simplifiedContent;
  }

  @override
  String getSubject() {
    return subject;
  }

  @override
  Paymentcard toPaymentCard() {
    return Paymentcard(
      helderData: this,

      isPayed: isPayed,
      isPayedDate: isPayedDate,

      amount: amount.toString(), 
      letterSource: sender, 
      paymentDate: paymentDeadline,
    );
  }
}
