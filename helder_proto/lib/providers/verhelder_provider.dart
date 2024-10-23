import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:helder_proto/models/helder_renderable_data.dart';
import 'package:http/http.dart' as http;

import 'package:helder_proto/data/services/database_service.dart';
import 'package:helder_proto/models/helder_invoice_data.dart';
import 'package:helder_proto/models/helder_allowance_data.dart';
import 'package:helder_proto/models/helder_letter_data.dart';
import 'package:helder_proto/models/helder_tax_data.dart';
import 'package:helder_proto/models/helder_text_info_data.dart';
import 'package:helder_proto/utils/constants/enums.dart';

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
  HelderRenderableData? helderData;

  reset() async {
    isLoading = true;
    error = '';
    helderData = null;
    isDuplicate = false;
    notifyListeners();
  }

  processLetterWithProxy(String completeLetter) async {
    
    Future.microtask(reset);

    Map<String, dynamic> helderKindsJsonData = helderKindToJson();
    String helderKindsJsonString = jsonEncode(helderKindsJsonData);

    Map<String, dynamic> specificKindsJsonData = allKindsToJson();
    String specificKindsJsonString = jsonEncode(specificKindsJsonData);

    Map<String, dynamic> requestBody = {
      'LetterContent': completeLetter,
      'LetterKinds': helderKindsJsonString,
      'SpecificKinds': specificKindsJsonString
    };

    try {
      var response = await http.post(
        baseUrl, 
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody)
      );

      if(response.statusCode == 200) {
        await handleApiResponse(response.body, completeLetter);
      } else {
        error = response.statusCode.toString();
      }
    } catch(e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> handleApiResponse(String responseBody, String completeLetter) async {
    var jsonResponse = jsonDecode(responseBody);

    String letterKind = jsonResponse['LetterKind'];
    
    TextInfo info = TextInfo(
      content: completeLetter,
      simplifiedContent: jsonResponse['TextInfo']['SimplifiedContent'],
      sender: jsonResponse['TextInfo']['Sender'],
      subject: jsonResponse['TextInfo']['Subject']
    );

    switch (letterKind) {
      case 'Toeslag':
        HelderAllowance allowance = HelderAllowance.fromMap(jsonResponse, info);
        isDuplicate = await isAllowanceDuplicate(allowance);
        log('Allowance created: ${allowance.amount}');
        helderData = allowance;
        break;

      case 'Factuur':
        HelderInvoice invoice = HelderInvoice.fromMap(jsonResponse, info);
        isDuplicate = await isInvoiceDuplicate(invoice);
        log('Invoice created: ${invoice.amount}');
        helderData = invoice;
        break;

      case 'Belasting':
        HelderTax tax = HelderTax.fromMap(jsonResponse, info);
        isDuplicate = await isTaxDuplicate(tax);
        log('Tax created: ${tax.amount}');
        helderData = tax;
        break;

      case 'Brief':
        HelderLetter letter = HelderLetter.fromMap(jsonResponse, info);
        isDuplicate = await isLetterDuplicate(letter);
        log('Letter created: ${letter.textInfo.subject}');
        break;

      default:
        log('Unknown LetterKind: $letterKind');
        break;
    }
  }

  Future<bool> isInvoiceDuplicate(HelderInvoice invoice) async {
    List<HelderInvoice> invoices = await DatabaseService.instance.getInvoices();

    for (var existingInvoice in invoices) {
      if (existingInvoice.paymentDeadline == invoice.paymentDeadline &&
          existingInvoice.kind == invoice.kind &&
          existingInvoice.amount == invoice.amount) {
        helderData = existingInvoice;
        print('Duplicate invoice detected, skipping insertion.');
        return true;
      }
    }

    return false;
  }

  Future<bool> isTaxDuplicate(HelderTax tax) async {
    List<HelderTax> taxes = await DatabaseService.instance.getTaxes();

    for (var existingTax in taxes) {
      if (existingTax.paymentDeadline == tax.paymentDeadline &&
          existingTax.kind == tax.kind &&
          existingTax.amount == tax.amount) {
        helderData = existingTax;
        print('Duplicate tax detected, skipping insertion.');
        return true;
      }
    }

    return false;
  }

  Future<bool> isAllowanceDuplicate(HelderAllowance allowance) async {
    List<HelderAllowance> allowances = await DatabaseService.instance.getAllowances();

    for (var existingAllowance in allowances) {
      if (existingAllowance.startDate == allowance.startDate &&
          existingAllowance.endDate == allowance.endDate &&
          existingAllowance.kind == allowance.kind &&
          existingAllowance.amount == allowance.amount) {
        helderData = existingAllowance;
        print('Duplicate allowance detected, skipping insertion.');
        return true; 
      }
    }

    return false;
  }

  Future<bool> isLetterDuplicate(HelderLetter letter) async {
    List<HelderLetter> letters = await DatabaseService.instance.getLetters();

    for (var existingLetter in letters) {
      if (existingLetter.textInfo.sender == letter.textInfo.sender &&
          existingLetter.textInfo.subject == letter.textInfo.subject) {
        print('Duplicate letter detected, skipping insertion.');
        return true;
      }
    }

    return false;
  }
}