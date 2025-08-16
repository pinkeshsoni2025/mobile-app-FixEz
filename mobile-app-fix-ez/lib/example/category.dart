import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:alpha_easy_fix/models/category_model.dart';

// Fetch content from the json file
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

void main() {
  runApp(const CategoryApp());
}

class CategoryApp extends StatelessWidget {
  const CategoryApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Hide the debug banner
      debugShowCheckedModeBanner: false,
      title: 'Category',
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

  late Future<List<Category>> futureCategory;

  @override
  void initState() {
    super.initState();
    futureCategory = readJson();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Category>>(
      future: futureCategory,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('An error has occurred!'));
        } else if (snapshot.hasData) {
          return CategoriesList(categories: snapshot.data!);
        } else {
          return const Center(child: LinearProgressIndicator());
        }
      },
    );
  }
}

class CategoriesList extends StatelessWidget {
  const CategoriesList({super.key, required this.categories});

  final List<Category> categories;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        var info = categories[index].icon;
        return ClipRect(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Card(
              key: ValueKey(categories[index].id),
              margin: const EdgeInsets.all(10),
              color:
                  (index % 2 == 0)
                      ? Color.fromARGB(255, 244, 226, 218)
                      : Color.fromARGB(255, 236, 221, 238),
              child: GridView.count(
                primary: false,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
                crossAxisCount: 1,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.indigo,
                        child: Icon(
                          IconData(
                            int.parse(info!),
                            fontFamily: 'MaterialIcons',
                          ),
                          size: 25,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        categories[index].name,
                        style: TextStyle(color: Colors.indigo, fontSize: 20),
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.indigo),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                          ),
                        ),
                        child: Text(
                          categories[index].sub_category.join(", "),
                          style: TextStyle(
                            color: Colors.indigoAccent,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      //Text(int.parse(info) as String),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
