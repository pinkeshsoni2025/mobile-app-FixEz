import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:alpha_easy_fix/api_router.dart';
import 'package:alpha_easy_fix/dialog_builder.dart';
import 'package:alpha_easy_fix/my_home.dart';
import 'package:alpha_easy_fix/login_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ProfileApp extends StatefulWidget {
  const ProfileApp({Key? key}) : super(key: key);

  @override
  State<ProfileApp> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileApp> {
  final storage = FlutterSecureStorage();
  String result = '';
  var _isLoading = false;
  // Controllers for form fields
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _locationController = TextEditingController();
  final _rolesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var token = null;
  final String apiUrl = RoutingBalance.CHANGE_PROFILE;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> _profileUpdate(BuildContext context) async {
    result = '';
    setState(() => _isLoading = true);
    try {
      final response = await http
          .put(
            Uri.parse(apiUrl+ _usernameController.text),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(<String, dynamic>{
              'name': _nameController.text,
              'email': _emailController.text,
              'location': _locationController.text,
              // Add any other data you want to send in the body
            }),
          )
          .timeout(const Duration(seconds: 10));
      // print(response.body);
      var statusCode = response.statusCode;
      if (statusCode == 200 || statusCode == 201) {
        final data = jsonDecode(response.body);
        await storage.write(key: 'accessToken', value: data['accessToken']);
        await storage.write(key: 'refreshToken', value: data['refreshToken']);
        await storage.write(key: 'tokenType', value: data['tokenType']);
        await storage.write(key: 'username', value: data['username']);
        await storage.write(key: 'email', value: data['email']); // roles is a List
        await storage.write(key: 'location', value: data['location']);
        await storage.write(key: 'name', value: data['name']);
        setState(() {
          _isLoading = false;
        });
        dialogBuilder(context,'Congratulations!','Profile has been saved successfully.');
        
      } else {
        final errorBody = jsonDecode(response.body);
        final errorMessage = errorBody['message'] ?? 'Something went wrong.';
        throw errorMessage;
      }
    } on http.ClientException catch (e) {
      setState(() {
        result = "The server is not reachable. Please try again later";
        _isLoading = false;
      });
    } catch (e) {
      var message;
      if (e is TimeoutException) {
        message = 'Internal server Error';
      } else if (e is SocketException) {
        message = 'The server is not reachable. Please try again later';
      } else {
        message = e;
      }
      setState(() {
        result = '$message';
        _isLoading = false;
      });
    }
  }

  Future<void> loadUserData() async {
    final name = await storage.read(key: 'name');
    final username = await storage.read(key: 'username');
    final email = await storage.read(key: 'email');
    final location = await storage.read(key: 'location');
    final roles = (await storage.read(key: 'roles'));
    final accessToken = (await storage.read(key: 'accessToken'));

    setState(() {
      _nameController.text = name ?? '';
      _usernameController.text = username ?? '';
      _emailController.text = email ?? '';
      _locationController.text = location ?? '';
      isLoading = false;
      _rolesController.text = roles ?? '';
      token = accessToken ?? null;
    });
  }

  Future<void> _logout() async {
    await storage.deleteAll(); // Clear all secure data

    // Navigate to Login and remove all previous routes
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MyHomePage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [_header(context), _inputField(context)],
              ),
            ),
          ),
        );
  }

  _inputField(context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (result != "welcome")
                      Container(
                        margin: EdgeInsets.only(bottom: 10),

                        child: Text(
                          result,
                          style: TextStyle(fontSize: 16.0, color: Colors.red),
                        ),
                      ),
                    TextFormField(
                      controller: _usernameController,
                      keyboardType: TextInputType.phone,
                      readOnly: true,
                      decoration: InputDecoration(
                        label: const Text(
                          'Phone no.',
                          style: TextStyle(
                            color: Color.fromRGBO(35, 132, 215, 1),
                          ),
                        ),
                        hintText: 'Enter your Phone no.',

                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(35, 132, 215, 1),
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),

                        prefixIcon: const Icon(Icons.phone, color: Colors.grey),
                      ),
                      validator: (value) {
                        return validMobileNo(value!);
                      },
                    ),
                    const SizedBox(height: 10),

                    TextFormField(
                      controller: _nameController,
                      cursorColor: Color.fromRGBO(35, 132, 215, 1),
                      decoration: InputDecoration(
                        label: const Text(
                          'Name',
                          style: TextStyle(
                            color: Color.fromRGBO(35, 132, 215, 1),
                          ),
                        ),
                        hintText: 'Enter your Name',
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(35, 132, 215, 1),
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(35, 132, 215, 1),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(35, 132, 215, 1),
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),

                        prefixIcon: const Icon(
                          Icons.account_circle,
                          color: Color.fromRGBO(35, 132, 215, 1),
                        ),
                      ),

                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your name';
                        }
                        // Add additional password validation logic here
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    TextFormField(
                      controller: _emailController,
                      cursorColor: Color.fromRGBO(35, 132, 215, 1),
                      decoration: InputDecoration(
                        label: const Text(
                          'Email',
                          style: TextStyle(
                            color: Color.fromRGBO(35, 132, 215, 1),
                          ),
                        ),
                        hintText: 'Enter your Email',
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(35, 132, 215, 1),
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(35, 132, 215, 1),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(35, 132, 215, 1),
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),

                        prefixIcon: const Icon(
                          Icons.email_sharp,
                          color: Color.fromRGBO(35, 132, 215, 1),
                        ),
                      ),

                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your email';
                        }
                        // Add additional password validation logic here
                        return null;
                      },
                    ),

                    const SizedBox(height: 10),

                    TextFormField(
                      controller: _locationController,
                      cursorColor: Color.fromRGBO(35, 132, 215, 1),
                      readOnly: true,
                      decoration: InputDecoration(
                        label: const Text(
                          'Location',
                          style: TextStyle(
                            color: Color.fromRGBO(35, 132, 215, 1),
                          ),
                        ),
                        hintText: 'Enter your location',
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(35, 132, 215, 1),
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),

                        prefixIcon: const Icon(
                          Icons.add_location,
                          color: Colors.grey,
                        ),
                      ),

                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your location';
                        }
                        // Add additional password validation logic here
                        return null;
                      },
                    ),

                    const SizedBox(height: 10),

                    TextFormField(
                      controller: _rolesController,
                      cursorColor: Color.fromRGBO(35, 132, 215, 1),
                      readOnly: true,
                      decoration: InputDecoration(
                        label: const Text(
                          'Role',
                          style: TextStyle(
                            color: Color.fromRGBO(35, 132, 215, 1),
                          ),
                        ),
                        hintText: 'Enter your role',
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),

                        prefixIcon: const Icon(
                          Icons.account_tree_outlined,
                          color: Colors.grey,
                        ),
                      ),

                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your role';
                        }
                        // Add additional password validation logic here
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed:
                            () => {
                              if (_formKey.currentState!.validate())
                                _isLoading ? null : _profileUpdate(context),
                            },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16.0),
                          backgroundColor: Color.fromRGBO(35, 132, 215, 1),
                        ),
                        label: Text(
                          'Submit',
                          style: TextStyle(color: Colors.white),
                        ),
                        icon:
                            _isLoading
                                ? Container(
                                  width: 20,
                                  height: 20,
                                  padding: const EdgeInsets.all(2.0),
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                : null,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _header(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(
          Icons.account_circle_sharp,
          color: Color.fromRGBO(35, 132, 215, 1),
          size: 100,
        ),
        const Text(
          "Profile",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(35, 132, 215, 1),
          ),
        ),
      ],
    );
  }
}
