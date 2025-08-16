import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//void main() => runApp(MyApp());

class CustomerSaysApp extends StatelessWidget {
  const CustomerSaysApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: CustomerSaysPage());
  }
}

//Creating a class user to store the data;
class User {
  final int id;
  final int userId;
  final String title;
  final String body;

  User({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });
}

class CustomerSaysPage extends StatefulWidget {
  @override
  _CustomerSaysState createState() => _CustomerSaysState();
}

class _CustomerSaysState extends State<CustomerSaysPage> {
  //Applying get request.

  Future<List<User>> getRequest() async {
    //replace your restFull API here.
    String url = "https://jsonplaceholder.typicode.com/posts";
    final response = await http.get(Uri.parse(url));

    var responseData = json.decode(response.body);
    

    //Creating a list to store input data;
    List<User> users = [];
    for (var singleUser in responseData) {
      User user = User(
        id: singleUser["id"],
        userId: singleUser["userId"],
        title: singleUser["title"],
        body: singleUser["body"],
      );

      //Adding user to the list.
      users.add(user);
    }
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 10),
        child: FutureBuilder(
          future: getRequest(),
          builder: (BuildContext ctx, AsyncSnapshot snapshot) {
            /* if (snapshot.data == null) {
              return Container(child: Center(child: LinearProgressIndicator()));
            } else */
            if (snapshot.error != null && snapshot.data == null) {
              return Container(
                // height: 150.0,
                //width: 190.0,
                padding: EdgeInsets.only(top: 40, bottom: 40),

                child: Center(
                  child: Image.asset('assets/images/server-error.png'),
                ),
              );
            } else if (snapshot.data == null) {
              return Container(child: Center(child: LinearProgressIndicator()));
            } else {
              return ListView.separated(
                itemCount: snapshot.data.length,

                itemBuilder: (ctx, int index) {
                  return Container(
                    //  height: 50,
                    padding: EdgeInsets.all(10),
                    color: Colors.greenAccent[index % 2 == 0 ? 100 : 200],
                    child: ListTile(
                      title: Text(snapshot.data[index].title),
                      subtitle: Text(snapshot.data[index].body),
                      contentPadding: EdgeInsets.only(bottom: 20.0),
                    ),
                  );
                },
                separatorBuilder:
                    (BuildContext context, int index) => const Divider(),
              );
            }
          },
        ),
      ),
    );
  }
}

class _ArticleDescription extends StatelessWidget {
  const _ArticleDescription({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  final int id;
  final int userId;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const Padding(padding: EdgeInsets.only(bottom: 2.0)),
        Expanded(
          child: Text(
            body,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12.0, color: Colors.black54),
          ),
        ),
        //  Text(id, style: const TextStyle(fontSize: 12.0, color: Colors.black87)),
      ],
    );
  }
}

class CustomListItemTwo extends StatelessWidget {
  const CustomListItemTwo({
    super.key,
    required this.thumbnail,
    required this.title,
    required this.userId,
    required this.body,
    required this.id,
  });

  final Widget thumbnail;
  final int id;
  final int userId;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        height: 100,
        child: Row(
          //crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            AspectRatio(aspectRatio: 1.0, child: thumbnail),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
                child: _ArticleDescription(
                  title: title,
                  id: id,
                  userId: userId,
                  body: body,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
