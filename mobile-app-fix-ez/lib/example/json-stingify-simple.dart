import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Hide the debug banner
      debugShowCheckedModeBanner: false,
      title: 'dbestech',
      theme: ThemeData(useMaterial3: true, primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _items = [];

  // Fetch content from the json file
  Future<void> readJson() async {
    final String response = await rootBundle.loadString(
      'assets/data/person.json',
    );
    final data = await json.decode(response);
    setState(() {
      _items = data["items"];
      print("..number of items ${_items.length}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('dbestech')),
      body: Column(
        children: [
          _items.isNotEmpty
              ? Expanded(
                child: ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    return Card(
                      key: ValueKey(_items[index]["id"]),
                      margin: const EdgeInsets.all(10),
                      color: Colors.amber.shade100,
                      child: ListTile(
                        leading: Text(_items[index]["id"]),
                        title: Text(_items[index]["name"]),
                        subtitle: Text(_items[index]["description"]),
                      ),
                    );
                  },
                ),
              )
              : ElevatedButton(
                onPressed: () {
                  readJson();
                },
                child: Center(child: Text("Load Json")),
              ),
        ],
      ),
    );
  }
}
