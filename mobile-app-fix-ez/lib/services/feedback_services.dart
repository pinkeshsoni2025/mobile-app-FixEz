import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:alpha_easy_fix/models/feedback_model.dart';

Future<List<HappyCustomer>> loadFeedbackData() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/feedback.json');
      final List<dynamic> jsonData = jsonDecode(jsonString);
     // print(jsonData);
      return jsonData.map((e) => HappyCustomer.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Error loading feedback data: $e');
      return [];
    }
  }
