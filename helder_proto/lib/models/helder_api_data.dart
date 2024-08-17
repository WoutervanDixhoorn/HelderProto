import 'dart:convert';

HelderApiData helderDataFromJson(String completeLetter, String json) => HelderApiData.fromJson(completeLetter, jsonDecode(json));

class HelderApiData {

  String completeLetter;

  String party;
  String subject;
  String reason;

  double amount;

  HelderApiData({
    required this.completeLetter, 
    required this.party, 
    required this.subject,
    required this.reason,
    this.amount = 0.0
  });

  HelderApiData.empty()
    : completeLetter = '',
      party = '',
      subject = '',
      reason = '',
      amount = 0.0;

  factory HelderApiData.fromJson(String completeLetter, Map<String, dynamic> json) {
    return HelderApiData(
      completeLetter: completeLetter, 
      party: json['party'] as String, 
      subject: json['subject'] as String, 
      reason: json['reason'] as String,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0
    );
  }
}