import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiController {

  static Uri baseUrl = Uri(
    scheme: 'http',
    host: '10.0.2.2',
    port: 8090,
    path: 'verhelder'
  );


  static Future<String> processLetter(String letterContent) async {
    var response = await http.post(
      baseUrl, 
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'letterContent': letterContent,
      }),
    );
    return response.body;
    // http.post(
    //   buildUri('verhelder'),
    //   headers: <String, String>{
    //     'Content-Type': 'application/json; charset=UTF-8',
    //   },
    //   body: jsonEncode(<String, String>{
    //     'letterContent': letterContent,
    //   }),
    // );
  }
}