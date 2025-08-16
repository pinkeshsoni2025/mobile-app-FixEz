import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Person {
  //final int albumId;
  final String id;
  final String name;
  final String description;

  const Person({
    // required this.albumId,
    required this.id,
    required this.name,
    required this.description,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      // albumId: json['albumId'] as int,
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
    );
  }
}

// Fetch content from the json file
Future<List<Person>> readJson() async {
  final String response = await rootBundle.loadString(
    'assets/data/person.json',
  );
  final data = await json.decode(response);
  final parsed = data["items"];
  // print(parsed);
  return parsed.map<Person>((json) => Person.fromJson(json)).toList();
  //return data["items"];
}

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
  // List _items = [];

  late Future<List<Person>> futurePerson;

  @override
  void initState() {
    super.initState();
    futurePerson = readJson();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Person>>(
      future: futurePerson,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('An error has occurred!'));
        } else if (snapshot.hasData) {
          return PersonsList(persons: snapshot.data!);
        } else {
          return const Center(child: LinearProgressIndicator());
        }
      },
    );
  }
}

class PersonsList extends StatelessWidget {
  const PersonsList({super.key, required this.persons});

  final List<Person> persons;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3,
      ),
      itemCount: persons.length,
      itemBuilder: (context, index) {
        final double width = MediaQuery.sizeOf(context).width;
        return ClipRect(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Card(
              key: ValueKey(persons[index].id),
              margin: const EdgeInsets.all(10),
              color: Colors.amber.shade100,
              child: ListTile(
                leading: Text(persons[index].id),
                title: Text(persons[index].name),
                subtitle: Text(persons[index].description),
              ),
            ),
          ),
        );
      },
    );
  }
}
