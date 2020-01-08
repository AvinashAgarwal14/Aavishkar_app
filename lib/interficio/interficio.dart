import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/rendering.dart';

import './pages/home_page.dart';
import './pages/authentication.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, dynamic> user = {
    "name": "",
    "username": "",
    "token": "",
    "isAuthenticated": false,
    "email": "",
    "password": ""
  };

  bool _isLoading = false;

  void autoAuthenticate() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();  //remove this to save user data
    var _token = prefs.getString("token");
    if (_token != null) {
      setState(() {
        user["isAuthenticated"] = true;
        user["username"] = prefs.getString("username");
        user["token"] = prefs.getString("token");
        user["email"] = prefs.getString("email");
        user["password"] = prefs.getString("password");
        user["name"] = prefs.getString("name");
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    autoAuthenticate();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //debugShowMaterialGrid: true,
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.red,
          accentColor: Colors.black),
      routes: {
        "/": (BuildContext context) =>
            _isLoading ? Container() : user["isAuthenticated"] ? HomePage(user) : AuthPage(user),
      },
    );
  }
}
