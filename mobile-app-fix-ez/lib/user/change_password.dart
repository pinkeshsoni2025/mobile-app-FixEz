import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:alpha_easy_fix/api_router.dart';
import 'package:alpha_easy_fix/login_app.dart';
import 'package:alpha_easy_fix/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:alpha_easy_fix/my_home.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:alpha_easy_fix/dialog_builder.dart';

var appTitle = 'FixEz';


class ChangePassword extends StatelessWidget {
  
  const ChangePassword({super.key});
  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangePasswordForm();
  }
}


class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({super.key});

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final storage = FlutterSecureStorage();
  final String apiUrl = RoutingBalance.CHANGE_PASSWORD;
  String result = '';
  var _isLoading = false;
  //const SignupPageForm({super.key});
  
  final emailController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

   void initState() {
    super.initState();
    loadEmailData();
  }

  Future<void> loadEmailData() async {
    final email = await storage.read(key: 'email');

    setState(() {
      emailController.text = email ?? '';
    });
  }

  Future<void> _forgotData(BuildContext context) async {
    result = '';
    setState(() => _isLoading = true);
    try {
      var request = jsonEncode(<String, dynamic>{
        "password": newPasswordController.text,
      });

      final response = await http
          .put(
            Uri.parse(apiUrl+emailController.text),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: request,
          )
          .timeout(const Duration(seconds: 10));
      // print(response);
      var statusCode = response.statusCode;
      if (statusCode == 200 || statusCode == 201) {
        //emailController.text = '';
        setState(() {
          _isLoading = false;
        });

       ///Re
       dialogBuilder(context,'Congratulations!','You password has been changed successfully.');
       /* Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => LoginApp(),
          ),
        );*/
      } else {
        final errorBody = jsonDecode(response.body);
        final errorMessage = errorBody['message'] ?? 'Something went wrong.';
        throw errorMessage;
      }
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

  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          margin: const EdgeInsets.only(left: 10, right: 10),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [_header(context), _inputField(context), _login(context)],
          ),
        ),
      ),
    );
  }

  _header(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.account_circle,
          color: Color.fromRGBO(35, 132, 215, 1),
          size: 100,
        ),
        Text(
          "Change a Password",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w500,
            color: Color.fromRGBO(35, 132, 215, 1),
          ),
        ),
        Center(
          child: Text(
            "Enter a new password below to change password",
            style: TextStyle(fontSize: 14),
          ),
        ),

      ],
    );
  }

  _inputField(context) {
    final _formKey = GlobalKey<FormState>();
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (!result.contains(RegExp('Congratulations!')))
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Text(
                result,
                style: TextStyle(fontSize: 16.0, color: Colors.red),
              ),
            ),

          const SizedBox(height: 10),
          TextFormField(
                controller: confirmPasswordController,
                cursorColor: Color.fromRGBO(35, 132, 215, 1),
                decoration: InputDecoration(
                  label: const Text(
                    'New Password',
                    style: TextStyle(color: Color.fromRGBO(35, 132, 215, 1)),
                  ),
                  hintText: 'Enter your Password',
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
                    Icons.lock,
                    color: Color.fromRGBO(35, 132, 215, 1),
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  RegExp passwordRegExp = RegExp(r'^[a-zA-Z0-9]{8,15}$');

                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  } else if (!passwordRegExp.hasMatch(value)) {
                    return 'Password must be 8-15 characters and contain only letters and numbers.';
                  }
                  // Add additional password validation logic here
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: newPasswordController,
                cursorColor: Color.fromRGBO(35, 132, 215, 1),
                decoration: InputDecoration(
                  label: const Text(
                    'Confirm Password',
                    style: TextStyle(color: Color.fromRGBO(35, 132, 215, 1)),
                  ),
                  hintText: 'Enter your Password',
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
                    Icons.lock,
                    color: Color.fromRGBO(35, 132, 215, 1),
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  RegExp passwordRegExp = RegExp(r'^[a-zA-Z0-9]{8,15}$');

                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  } else if (!passwordRegExp.hasMatch(value)) {
                    return 'Password must be 8-15 characters and contain only letters and numbers.';
                  } else if((newPasswordController.text) != value)
                  return 'password and confirm password must be mach';
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
                      _isLoading ? null : _forgotData(context),
                  },
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                padding: const EdgeInsets.only(
                  left: 100,
                  right: 100,
                  top: 10,
                  bottom: 10,
                ),
                backgroundColor: Color.fromRGBO(35, 132, 215, 1),
              ),
              label: const Text(
                "Submit",
                style: TextStyle(fontSize: 15, color: Colors.white),
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
    );
  }

  _login(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        const Center(child: Text("OR")),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("Already have an account?"),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) {
                      return LoginApp();
                    },
                  ),
                );
              },
              child: const Text(
                "Login",
                style: TextStyle(color: Color.fromRGBO(35, 132, 215, 1)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}