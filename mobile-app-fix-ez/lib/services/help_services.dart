import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:alpha_easy_fix/models/help_model.dart';

Future<List<Help>> loadHelpData() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/help.json');
      final List<dynamic> jsonData = jsonDecode(jsonString);
      return jsonData.map((e) => Help.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Error loading help data: $e');
      return [];
    }
  }
