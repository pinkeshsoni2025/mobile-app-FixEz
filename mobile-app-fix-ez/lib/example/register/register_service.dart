import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:alpha_easy_fix/example/register/models/signup_model.dart';

Future<http.Response?> register(data) async {
  //print(data);
  http.Response? response;
  try {
    response = await http.post(
      Uri.parse("http://127.0.0.1:8000/api/auth/signin"),
      headers: {HttpHeaders.contentTypeHeader: "application/json"},
      body: jsonEncode(data),
    );
  } catch (e) {
    log(e.toString());
  }

  return response;
}
