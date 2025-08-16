import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Photo>> fetchPhotos(http.Client client) async {
  final response = await client
      .get(Uri.parse('https://picsum.photos/v2/list'))
      .timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          return http.Response(
            'Error',
            408,
          ); // Request Timeout response status code
        },
      );
  print(response.statusCode);
  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parsePhotos, response.body);
}

// A function that converts a response body into a List<Photo>.
List<Photo> parsePhotos(String responseBody) {
  final parsed =
      (jsonDecode(responseBody) as List).cast<Map<String, dynamic>>();

  return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
}

class Photo {
  //final int albumId;
  final String id;
  final String author;
  final String url;
  final String download_url;

  const Photo({
    // required this.albumId,
    required this.id,
    required this.author,
    required this.url,
    required this.download_url,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      // albumId: json['albumId'] as int,
      id: json['id'] as String,
      author: json['author'] as String,
      url: json['url'] as String,
      download_url: json['download_url'] as String,
    );
  }
}

//void main() => runApp(const MyApp());

class PhotoLists extends StatelessWidget {
  const PhotoLists({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Image';

    return const MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Photo>> futurePhotos;

  @override
  void initState() {
    super.initState();
    futurePhotos = fetchPhotos(http.Client());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Photo>>(
      future: futurePhotos,
      builder: (context, snapshot) {
        if (snapshot.error != null && snapshot.data == null) {
          return Container(
            // height: 150.0,
            //width: 190.0,
            padding: EdgeInsets.only(top: 40, bottom: 40),

            child: Center(child: Image.asset('assets/images/server-error.png')),
          );
        } else if (snapshot.data == null) {
          return Container(child: Center(child: LinearProgressIndicator()));
        } else {
          return PhotosList(photos: snapshot.data!);
        }
      },
    );
  }
}

class PhotosList extends StatelessWidget {
  const PhotosList({super.key, required this.photos});

  final List<Photo> photos;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        final double width = MediaQuery.sizeOf(context).width;
        return ClipRect(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: SizedBox(
              width: width,
              height: width,
              child: Card.filled(
                child: Image(
                  fit: BoxFit.cover,
                  image: NetworkImage(photos[index].download_url),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
