import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:alpha_easy_fix/example/register/register_service.dart';
import 'package:alpha_easy_fix/example/register/models/signup_model.dart';

class DataClass extends ChangeNotifier {
  bool loading = false;
  bool isBack = false;
  Future<void> postData(body) async {
    // print(body);
    loading = true;
    notifyListeners();
    http.Response response = (await register(body))!;
    if (response.statusCode == 200) {
      isBack = true;
    }
    loading = false;
    notifyListeners();
  }
}
