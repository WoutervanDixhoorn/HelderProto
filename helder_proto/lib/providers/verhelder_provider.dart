import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart' as fuzz;
import 'package:helder_proto/data/services/database_service.dart';
import 'package:helder_proto/models/helder_invoice.dart';
import 'package:helder_proto/models/helder_letter.dart';
import 'package:helder_proto/utils/constants/enums.dart';
import 'package:http/http.dart' as http;


class VerhelderProvider extends ChangeNotifier {

  static Uri baseUrl = Uri(
    scheme: 'http',
    host: '10.0.2.2',
    port: 8090,
    path: 'verhelder'
  );

  bool isLoading = true;
  String error = '';
  bool isDuplicate = false;
  HelderInvoice helderData = HelderInvoice.empty();

  reset() async {
    isLoading = true;
    error = '';
    helderData = HelderInvoice.empty();
    isDuplicate = false;
    notifyListeners();
  }

  processLetterWithProxy(String completeLetter) async {
    
    Future.microtask(reset);

    try {
      var response = await http.post(
        baseUrl, 
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{'letterContent': completeLetter})
      );

      if(response.statusCode == 200) {
        helderData = helderInvoiceFromJson(completeLetter, response.body);
      } else {
        error = response.statusCode.toString();
      }
    } catch(e) {
      error = e.toString();
    }

    isDuplicate = await checkForDuplicate();

    isLoading = false;
    notifyListeners();
  }

  Future<bool> checkForDuplicate() async {
    DateTime paymentDeadline = helderData.paymentDeadline;
    num amount = helderData.amount;
    LetterKind kind = helderData.letter.kind;

    List<HelderInvoice> invoices = await DatabaseService.instance.getInvoices();
    for(var invoice in invoices) {  
      if (invoice.paymentDeadline == paymentDeadline &&
          invoice.amount == amount &&
          invoice.letter.kind == kind) {
        return true; // Return true immediately when a match is found
      }
    }

    return false;
  }


}