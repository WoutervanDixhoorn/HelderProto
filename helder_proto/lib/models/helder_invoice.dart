import 'dart:convert';

import 'package:helder_proto/models/helder_letter.dart';
import 'package:helder_proto/data/services/database_service.dart';

HelderInvoice helderInvoiceFromJson(String content, String json) => HelderInvoice.fromJson(content, jsonDecode(json));

class HelderInvoice {

  HelderLetter letter;
  num amount;
  bool isPaymentDue;
  String paymentReference;
  DateTime paymentDeadline;
  
  bool isPayed;
  DateTime paymentDate = DateTime(1);

  HelderInvoice({
    required this.letter, 
    required this.amount, 
    required this.isPaymentDue,
    required this.paymentReference,
    required this.paymentDeadline,
    this.isPayed = false
  });

  HelderInvoice.empty()
    : letter = HelderLetter.empty(),
      amount = 0.0,
      isPaymentDue = false,
      paymentReference = '',
      paymentDeadline = DateTime(1),
      isPayed = false;

  static Future<HelderInvoice> fromMap(Map<String, Object?> map) async {
    HelderInvoice invoice = HelderInvoice.empty();

    invoice.letter = await DatabaseService.instance.getLetter(map['letterId'] as int);
    invoice.amount = map['amount'] as num? ?? 0.0;
    invoice.isPaymentDue = map['sender'] as bool? ?? false;
    invoice.paymentReference = map['paymentReference'] as String? ?? '';
    invoice.paymentDeadline = DateTime.parse(map['paymentDeadline'] as String);
    invoice.isPayed = (map['isPayed'] as int? ?? 0) == 1;

    return invoice;
  }

  factory HelderInvoice.fromJson(String content, Map<String, dynamic> json) {
    HelderLetter letter = helderLetterFromJson(content, jsonEncode(json));

    return HelderInvoice(
      letter: letter,
      amount: json['amount'] as num, 
      isPaymentDue: json['isPaymentDue'] as bool, 
      paymentReference: json['paymentReference'] as String,
      paymentDeadline: DateTime.parse(json['paymentDeadline'] as String), 
      isPayed: false 
    );
  }
}