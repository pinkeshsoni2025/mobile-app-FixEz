import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:alpha_easy_fix/models/category_model.dart';

Future<List<Category>> readJson() async {
  final String response = await rootBundle.loadString(
    'assets/data/category.json',
  );
  final data = await json.decode(response);
  final parsed = data["records"];
  // print(parsed);
  return parsed.map<Category>((json) => Category.fromJson(json)).toList();
  //return data["items"];
}

