import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:helder_proto/models/helder_api_data.dart';

class VerhelderProvider extends ChangeNotifier {

  static Uri baseUrl = Uri(
    scheme: 'http',
    host: '10.0.2.2',
    port: 8090,
    path: 'verhelder'
  );

  bool isLoading = true;
  String error = '';
  HelderApiData helderData = HelderApiData.empty();

  processLetterWithProxy(String completeLetter) async {
    //Reset widget when calling api
    Future.microtask(() {
      isLoading = true;
      error = '';
      helderData = HelderApiData.empty();
      notifyListeners();
    });

    try {
      var response = await http.post(
        baseUrl, 
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{'letterContent': completeLetter})
      );

      if(response.statusCode == 200) {
        helderData = helderDataFromJson(completeLetter, response.body);
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