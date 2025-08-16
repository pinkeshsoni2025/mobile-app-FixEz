// ignore_for_file: sort_child_properties_last

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:alpha_easy_fix/api_router.dart';
import 'package:alpha_easy_fix/user/change_password.dart';
import 'package:alpha_easy_fix/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:alpha_easy_fix/my_home.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:alpha_easy_fix/dialog_builder.dart';

var appTitle = 'FixEz';

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle, style: const TextStyle(color: Colors.white)),
        backgroundColor: Color.fromRGBO(35, 132, 215, 1),

        leading: IconButton(
          icon: const Icon(Icons.home_filled, color: Colors.white),
          tooltip: 'Home',
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const MaterialApp(home: MyHomePage()),
              ),
            );
          },
        ),
      ),
      body: LoginPageForm(),
    );
  }
}

class LoginPageForm extends StatefulWidget {
  const LoginPageForm({super.key});

  @override
  State<LoginPageForm> createState() => _LoginAppFormState();
}

class _LoginAppFormState extends State<LoginPageForm> {
  // const LoginPage({super.key});
  final storage = FlutterSecureStorage();

  final String apiUrl = RoutingBalance.LOGIN;
  // final String apiUrl = 'http://127.0.0.1:8080/api/auth/signin';
  String result = '';
  var _isLoading = false;

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  String usernameStorage = '';

  void dispose() {
    // Clean up the controller when the widget is disposed.
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final username = await storage.read(key: 'username');

    if (username != null && username.isNotEmpty) {
      // User already logged in
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProfileHomePage()),
      );
    }
  }

  Future<void> _loginData(BuildContext context) async {
    result = '';
    setState(() => _isLoading = true);
    try {
      final response = await http
          .post(
            Uri.parse(apiUrl),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, dynamic>{
              'username': usernameController.text,
              'password': passwordController.text,
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
        await storage.write(key: 'email', value: data['email']);
        await storage.write(
          key: 'roles',
          value: jsonEncode(data['roles']),
        ); // roles is a List
        await storage.write(key: 'location', value: data['location']);
        await storage.write(key: 'name', value: data['name']);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ProfileHomePage()),
        );
      } else {
        final errorBody = jsonDecode(response.body);
        final errorMessage = errorBody['message'] ?? 'Something went wrong.';
        throw errorMessage;
      }
    }on http.ClientException catch (e) {
     setState(() {
        result = "The server is not reachable. Please try again later";
        _isLoading = false;
      });
  }  catch (e) {
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          margin: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _header(context),
              _inputField(context),
              _forgotPassword(context),
              _signup(context),
            ],
          ),
        ),
      ),
    );
  }

  _forgotPassword(context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) {
              return ForgotApp();
            },
          ),
        );
      },
      child: const Text(
        "Forgot password?",
        style: TextStyle(color: Color.fromRGBO(35, 132, 215, 1)),
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
          "LogIn",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(35, 132, 215, 1),
          ),
        ),
      ],
    );
  }

  _inputField(context) {
    final _formKey = GlobalKey<FormState>();
    return Column(
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
                controller: usernameController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  label: const Text(
                    'Phone no',
                    style: TextStyle(color: Color.fromRGBO(35, 132, 215, 1)),
                  ),
                  hintText: 'Enter your Phone no',

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
                    Icons.phone,
                    color: Color.fromRGBO(35, 132, 215, 1),
                  ),
                ),
                validator: (value) {
                  return validMobileNo(value!);
                },
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: passwordController,
                cursorColor: Color.fromRGBO(35, 132, 215, 1),
                decoration: InputDecoration(
                  label: const Text(
                    'Password',
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
                  if (value!.isEmpty) {
                    return 'Please enter your password';
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
                          _isLoading ? null : _loginData(context),
                      },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.only(
                      left: 100,
                      right: 100,
                      top: 10,
                      bottom: 10,
                    ),
                    backgroundColor: Color.fromRGBO(35, 132, 215, 1),
                  ),
                  label: Text('Submit', style: TextStyle(color: Colors.white)),
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
    );
  }

  _signup(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Dont have an account? "),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) {
                  return SignupApp();
                },
              ),
            );
          },
          child: const Text(
            "Signup",
            style: TextStyle(color: Color.fromRGBO(35, 132, 215, 1)),
          ),
        ),
      ],
    );
  }
}

class SignupApp extends StatelessWidget {
  const SignupApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle, style: const TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.home_filled, color: Colors.white),
          tooltip: 'Home',
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const MaterialApp(home: MyHomePage()),
              ),
            );
          },
        ),
        backgroundColor: Color.fromRGBO(35, 132, 215, 1),
      ),
      body: const Center(child: SignupPageForm()),
    );
  }
}

enum UserType { worker, customer }

class SignupPageForm extends StatefulWidget {
  const SignupPageForm({super.key});

  @override
  State<SignupPageForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupPageForm> {
  final String apiUrl = RoutingBalance.REGISTER;
  // final String apiUrl = 'http://127.0.0.1:8080/api/auth/signin';
  String result = '';
  var _isLoading = false;
  //const SignupPageForm({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();

  UserType userTypeView = UserType.worker;

  Future<void> _registerData(BuildContext context) async {
    result = '';
    setState(() => _isLoading = true);
    try {
      var request = jsonEncode(<String, dynamic>{
        "email": emailController.text,
        "password": passwordController.text,
        "username": usernameController.text,
        "role": [userTypeView.name],
        "name": fullNameController.text,
        //"createdAt":"2021-09-17T11:48:06Z",
        "createdAt": getCurrentFormattedTime(),
        "createdBy": usernameController.text,
      });

      final response = await http
          .post(
            Uri.parse(apiUrl),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: request,
          )
          .timeout(const Duration(seconds: 10));
      // print(response.body);
      var statusCode = response.statusCode;
      if (statusCode == 200 || statusCode == 201) {
        emailController.text = '';
        passwordController.text = '';
        usernameController.text = '';
        fullNameController.text = '';
        setState(() {
          _isLoading = false;
        });
        dialogBuilder(context,'Congratulations!','You have successfully registered.');
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
    usernameController.dispose();
    passwordController.dispose();
    emailController.dispose();
    fullNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          "Signup",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(35, 132, 215, 1),
          ),
        ),
        Card(
          surfaceTintColor: Color.fromRGBO(35, 132, 215, 1),
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Image(
              image: AssetImage("assets/images/${userTypeView.name}.png"),
              width: 70,
              height: 70,
            ),
          ),
        ),
      ],
    );
  }

  _inputField(context) {
    final _formKey = GlobalKey<FormState>();
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              if (!result.contains(RegExp('Congratulations!')))
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Text(
                    result,
                    style: TextStyle(fontSize: 16.0, color: Colors.red),
                  ),
                ),

              SegmentedButton<UserType>(
                style: SegmentedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  selectedForegroundColor: Colors.white,
                  selectedBackgroundColor: Color.fromRGBO(35, 132, 215, 1),
                ),
                segments: const <ButtonSegment<UserType>>[
                  ButtonSegment<UserType>(
                    value: UserType.worker,
                    label: Text(
                      'Worker',
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 2,
                        fontSize: 15,
                      ),
                    ),
                    icon: Icon(Icons.build, color: Colors.white),
                  ),
                  ButtonSegment<UserType>(
                    value: UserType.customer,
                    label: Text(
                      'Customer',
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 2,
                        fontSize: 15,
                      ),
                    ),
                    icon: Icon(Icons.account_circle, color: Colors.white),
                  ),
                ],
                selected: <UserType>{userTypeView},

                onSelectionChanged: (Set<UserType> newSelection) {
                  setState(() {
                    // By default there is only a single segment that can be
                    // selected at one time, so its value is always the first
                    // item in the selected set.
                    userTypeView = newSelection.first;
                  });
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: fullNameController,
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  label: const Text(
                    'Full name',
                    style: TextStyle(color: Color.fromRGBO(35, 132, 215, 1)),
                  ),
                  hintText: 'Enter your Full name',
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
                    return 'Please enter your full name';
                  }
                  // Add additional password validation logic here
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                cursorColor: Color.fromRGBO(35, 132, 215, 1),
                decoration: InputDecoration(
                  label: const Text(
                    'Email',
                    style: TextStyle(color: Color.fromRGBO(35, 132, 215, 1)),
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
                    return 'Please enter email';
                  } else {
                    final bool emailValid = RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                    ).hasMatch(value);
                    if (!emailValid) {
                      return 'Please enter valid email';
                    }
                    // Add additional password validation logic here
                    return null;
                  }
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: usernameController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  label: const Text(
                    'Phone no',
                    style: TextStyle(color: Color.fromRGBO(35, 132, 215, 1)),
                  ),
                  hintText: 'Enter your Phone no',
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
                    Icons.phone,
                    color: Color.fromRGBO(35, 132, 215, 1),
                  ),
                ),
                validator: (value) {
                  return validMobileNo(value!);
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: passwordController,
                cursorColor: Color.fromRGBO(35, 132, 215, 1),
                decoration: InputDecoration(
                  label: const Text(
                    'Password',
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
              Center(
                child: ElevatedButton.icon(
                  onPressed:
                      () => {
                        if (_formKey.currentState!.validate())
                          _isLoading ? null : _registerData(context),
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
        ),
      ],
    );
  }

  String getCurrentFormattedTime() {
    final nowUtc = DateTime.now().toUtc();
    final formatted = nowUtc.toIso8601String().split('.').first + 'Z';
    return formatted;
  }

  _login(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Center(child: Text("Or")),
        const SizedBox(height: 20),
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

String? validMobileNo(String value) {
  String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  RegExp regExp = new RegExp(patttern);
  if (value!.isEmpty) {
    return 'Please enter your phone no';
  } else if (!regExp.hasMatch(value)) {
    return 'Mobile Number must be of 10 digit';
  } else {
    return null;
  }
  // Add additional email validation logic here
}

class ForgotApp extends StatelessWidget {
  const ForgotApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle, style: const TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.home_filled, color: Colors.white),
          tooltip: 'Home',
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const MaterialApp(home: MyHomePage()),
              ),
            );
          },
        ),
        backgroundColor: Color.fromRGBO(35, 132, 215, 1),
      ),
      body: const Center(child: ForgotPageForm()),
    );
  }
}

class ForgotPageForm extends StatefulWidget {
  const ForgotPageForm({super.key});

  @override
  State<ForgotPageForm> createState() => _ForgotFormState();
}

class _ForgotFormState extends State<ForgotPageForm> {
  final storage = FlutterSecureStorage();
  final String apiUrl = RoutingBalance.OTP_SENT;
  String result = '';
  var _isLoading = false;
  //const SignupPageForm({super.key});

  final emailController = TextEditingController();

  Future<void> _forgotData(BuildContext context) async {
    result = '';
    setState(() => _isLoading = true);
    try {
      var request = jsonEncode(<String, dynamic>{
        "email": emailController.text,
      });

      final response = await http
          .post(
            Uri.parse(apiUrl),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: request,
          )
          .timeout(const Duration(seconds: 10));
      // print(response.body);
      var statusCode = response.statusCode;
      if (statusCode == 200 || statusCode == 201) {
        emailController.text = '';
        setState(() {
          _isLoading = false;
        });
        await storage.write(key: 'email', value: response.body);
       //print(response.body);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => VerifyOTPApp(),
          ),
        );
      } else {
        final errorBody = jsonDecode(response.body);
        final errorMessage = errorBody['message'] ?? 'Something went wrong.';
        throw errorMessage;
      }
    }on http.ClientException catch (e) {
     setState(() {
        result = "The server is not reachable. Please try again later";
        _isLoading = false;
      });
  } on TimeoutException catch (_) {
     setState(() {
        result = "Request timed out";
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
          Icons.lock_outline,
          color: Color.fromRGBO(35, 132, 215, 1),
          size: 100,
        ),
        Text(
          "Forgot password?",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w500,
            color: Color.fromRGBO(35, 132, 215, 1),
          ),
        ),
        Center(
          child: Text(
            "Enter your registered email address",
            style: TextStyle(fontSize: 14),
          ),
        ),
        Center(
          child: Text(
            "We will send you a one-time password (OTP) to reset it.",
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
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            cursorColor: Color.fromRGBO(35, 132, 215, 1),
            decoration: InputDecoration(
              label: const Text(
                'Email',
                style: TextStyle(color: Color.fromRGBO(35, 132, 215, 1)),
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
                return 'Please enter email';
              } else {
                final bool emailValid = RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                ).hasMatch(value);
                if (!emailValid) {
                  return 'Please enter valid email';
                }
                // Add additional password validation logic here
                return null;
              }
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

  String getCurrentFormattedTime() {
    final nowUtc = DateTime.now().toUtc();
    final formatted = nowUtc.toIso8601String().split('.').first + 'Z';
    return formatted;
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

class VerifyOTPApp extends StatelessWidget {
  const VerifyOTPApp({super.key});
  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle, style: const TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.home_filled, color: Colors.white),
          tooltip: 'Home',
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const MaterialApp(home: MyHomePage()),
              ),
            );
          },
        ),
        backgroundColor: Color.fromRGBO(35, 132, 215, 1),
      ),
      body: VerifyOTPForm(),
    );
  }
}

class VerifyOTPForm extends StatefulWidget {
  const VerifyOTPForm({super.key});

  @override
  State<VerifyOTPForm> createState() => _VerifyOTPFormState();
}

class _VerifyOTPFormState extends State<VerifyOTPForm> {
  final storage = FlutterSecureStorage();
  final String apiUrl = RoutingBalance.OTP_VERIFY;
  String result = '';
  var _isLoading = false;
  //const SignupPageForm({super.key});

  final otpController = TextEditingController();
  final emailController = TextEditingController();

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
        "otp": otpController.text,
        "email": emailController.text,
      });

      final response = await http
          .post(
            Uri.parse(apiUrl),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: request,
          )
          .timeout(const Duration(seconds: 10));
          
      // print(request);
      var statusCode = response.statusCode;
      if (statusCode == 200 || statusCode == 201) {
        otpController.text = '';
        setState(() {
          _isLoading = false;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ChangePassword(),
          ),
        );
      } else {
        final errorBody = jsonDecode(response.body);
        final errorMessage = errorBody['message'] ?? 'Something went wrong.';
        throw errorMessage;
      }
    }on http.ClientException catch (e) {
     setState(() {
        result = "The server is not reachable. Please try again later";
        _isLoading = false;
      });
  } on TimeoutException catch (_) {
     setState(() {
        result = "Request timed out";
        _isLoading = false;
      });
  }  catch (e) {
      var message;
      if (e is TimeoutException) {
        message = 'Internal server Error';
      } else if (e is SocketException) {
        message = 'The server is not reachable. Please try again later';
      }else if (e is HttpException) {
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
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Icon(
          Icons.lock_open_outlined,
          color: Color.fromRGBO(35, 132, 215, 1),
          size: 100,
        ),
        Text(
          "Verification Code",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(35, 132, 215, 1),
          ),
        ),
        Center(
          child: Text(
            "Please enter the 6-digit OTP",
            style: TextStyle(fontSize: 14),
          ),
        ),
        Center(
          child: Text(
            "We just sent to your registered email address.",
            style: TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  _inputField(context) {
    final _formKey = GlobalKey<FormState>();
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                controller: otpController,
                obscureText:true, 
                keyboardType: TextInputType.emailAddress,
                cursorColor: Color.fromRGBO(35, 132, 215, 1),
                decoration: InputDecoration(
                  label: const Text(
                    'OTP',
                    style: TextStyle(color: Color.fromRGBO(35, 132, 215, 1)),
                  ),
                  hintText: 'Enter your OTP',    
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
                    Icons.password_sharp,
                    color: Color.fromRGBO(35, 132, 215, 1),
                  ),
                ),

                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter otp';
                  }
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
        ),
      ],
    );
  }

    String getCurrentFormattedTime() {
    final nowUtc = DateTime.now().toUtc();
    final formatted = nowUtc.toIso8601String().split('.').first + 'Z';
    return formatted;
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
            const Text("Go back?"),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) {
                      return ForgotApp();
                    },
                  ),
                );
              },
              child: const Text(
                "Forgot password",
                style: TextStyle(color: Color.fromRGBO(35, 132, 215, 1)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}



  String getCurrentFormattedTime() {
    final nowUtc = DateTime.now().toUtc();
    final formatted = nowUtc.toIso8601String().split('.').first + 'Z';
    return formatted;
  }

  






