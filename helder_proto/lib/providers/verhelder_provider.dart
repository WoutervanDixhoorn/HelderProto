import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:helder_proto/models/helder_invoice.dart';
import 'package:helder_proto/models/helder_letter.dart';
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
  HelderInvoice helderData = HelderInvoice.empty();

  _resetWidget() async {
    isLoading = true;
    error = '';
    helderData = HelderInvoice.empty();
    notifyListeners();
  }

  processLetterWithProxy(String completeLetter) async {
    
    Future.microtask(_resetWidget);

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

    isLoading = false;
    notifyListeners();
  }
}