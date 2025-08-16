import 'package:alpha_easy_fix/help_list.dart';
import 'package:alpha_easy_fix/profile_app.dart';
import 'package:flutter/material.dart';
//import 'package:alpha_easy_fix/app_bar_app.dart';
import 'package:alpha_easy_fix/home.dart';
import 'package:alpha_easy_fix/happy_customer.dart';
import 'package:alpha_easy_fix/login_app.dart';
import 'package:alpha_easy_fix/photo_lists.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  static const appTitle = 'FixEz';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: appTitle,
      home: MyHomePage1(title: appTitle),
    );
  }
}

class MyHomePage1 extends StatefulWidget {
  const MyHomePage1({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage1> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage1> {
  int _selectedIndex = 0;
  final storage = FlutterSecureStorage();
  bool isLoading = false;
  String nameStorage = 'User';
  
  static const List<Widget> _widgetOptions = <Widget>[
    Home(),
    LoginPageForm(),
    HappyCustomerList(),
    PhotoLists(),
   HelpList(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final name = await storage.read(key: 'name');
    setState(() {
      nameStorage = name ?? 'User';
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final double width = MediaQuery.sizeOf(context).width;

    
      return Scaffold(
      appBar: AppBar(
        title: new Center(
          child: new Text(
            widget.title,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Color.fromRGBO(35, 132, 215, 1),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            tooltip: 'Notifications',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('This is a snackbar')),
              );
            },
          ),
          
        ],
        leading: Builder(
          builder: (context) {
            return IconButton(
              color: Colors.white,
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: Center(child: _widgetOptions[_selectedIndex]),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            Container(
              // height: 150.0,
              //width: 190.0,
              padding: EdgeInsets.only(top: 40, bottom: 40),

              child: Center(child: Image.asset('assets/images/logo.png')),
            ),

            ListTile(
              leading: Icon(Icons.home, color: Color.fromRGBO(35, 132, 215, 1)),
              title: const Text('Home'),
              selected: _selectedIndex == 0,
              onTap: () {
                // Update the state of the app
                _onItemTapped(0);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
             ListTile(
              leading: Icon(
                Icons.account_circle_sharp,
                color: Color.fromRGBO(35, 132, 215, 1),
              ),
              title: Text(nameStorage),
              selected: _selectedIndex == 1,
              onTap: () {
                // Update the state of the app
                _onItemTapped(1);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.emoji_emotions_outlined,
                color: Color.fromRGBO(35, 132, 215, 1),
              ),
              title: const Text('Happy Customer'),
              selected: _selectedIndex == 2,
              onTap: () {
                // Update the state of the app
                _onItemTapped(2);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.photo_album_sharp,
                color: Color.fromRGBO(35, 132, 215, 1),
              ),
              title: const Text('Photo list'),
              selected: _selectedIndex == 3,
              onTap: () {
                // Update the state of the app
                _onItemTapped(3);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.support_agent,
                color: Color.fromRGBO(35, 132, 215, 1),
              ),
              title: const Text('Help Center'),
              selected: _selectedIndex == 4,
              onTap: () {
                // Update the state of the app
                _onItemTapped(4);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
    
  }
}
