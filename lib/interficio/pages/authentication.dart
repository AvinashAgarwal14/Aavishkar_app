import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

enum AuthMode { register, login }

class AuthPage extends StatefulWidget {
  final Map<String, dynamic> user;
  AuthPage(this.user);

  @override
  _AuthPageState createState() => _AuthPageState(user);
}

class _AuthPageState extends State<AuthPage> {
  final Map<String, dynamic> user;
  _AuthPageState(this.user);

  final Map<String, dynamic> _loginFormData = {
    "username": null,
    "password": null,
  };

  final Map<String, dynamic> _registerFormData = {
    "email": "",
    "name": "",
    "username": null,
    "password": null,
  };

  bool _isLoading = false;

  String api_url = "phoenix7139.pythonanywhere.com";

  AuthMode _authmode = AuthMode.login;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();

  final _passwordTextController = TextEditingController();

  Future userLogin(final Map<String, dynamic> user) async {
    setState(() {
      _isLoading = true;
    });
    http.Response response = await http.post(
        Uri.encodeFull("http://$api_url/api/auth/login/"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(_loginFormData));
    var data = json.decode(response.body);
    print(data);
    if (data.length == 1) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("unable to log in with provided credentials"),
        duration: Duration(seconds: 1),
      ));
      setState(() {
        _isLoading = false;
      });
    } else {
      user["username"] = data["user"]["username"];
      user["token"] = data["token"];
      user["isAuthenticated"] = true;
      user["password"] = _loginFormData["password"];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("username", user["username"]);
      prefs.setString("token", user["token"]);
      prefs.setString("password", user["password"]);
      prefs.setString("email", user["email"]);

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Logged in"),
        duration: Duration(seconds: 1),
      ));
      setState(() {
        _isLoading = false;
      });
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  Future userRegister(final Map<String, dynamic> user) async {
    setState(() {
      _isLoading = true;
    });
    http.Response response = await http.post(
        Uri.encodeFull("http://$api_url/api/auth/register/"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(_registerFormData));
    var data = json.decode(response.body);
    print(data);
    if (data.length == 1) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("a user with that username already exists"),
        duration: Duration(seconds: 1),
      ));
      setState(() {
        _isLoading = false;
      });
    } else {
      user["username"] = data["user"]["username"];
      user["token"] = data["token"];
      user["isAuthenticated"] = true;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("username", user["username"]);
      prefs.setString("token", user["token"]);
      prefs.setString("password", _registerFormData["password"]);

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Logged in"),
        duration: Duration(seconds: 1),
      ));
      setState(() {
        _isLoading = false;
      });
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  Widget _usernameTextField() {
    return TextFormField(
      style: TextStyle(
        color: Colors.white.withOpacity(0.7),
      ),
      decoration: InputDecoration(
        suffixIcon: Icon(
          Icons.person,
          color: Colors.white.withOpacity(0.7),
        ),
        // filled: true,
        // fillColor: Colors.white.withOpacity(0.7),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Colors.white.withOpacity(0.7), width: 3),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Colors.white.withOpacity(0.7), width: 3),
          borderRadius: BorderRadius.circular(10),
        ),
        labelText: "username",
        labelStyle: TextStyle(
          color: Colors.white.withOpacity(0.7),
        ),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return "Please enter a valid username";
        }
      },
      onSaved: (String value) {
        _authmode == AuthMode.login
            ? _loginFormData["username"] = value
            : _registerFormData["username"] = value;
      },
    );
  }

  Widget _passwordTextField() {
    return TextFormField(
      controller: _passwordTextController,
      style: TextStyle(
        color: Colors.white.withOpacity(0.7),
      ),
      decoration: InputDecoration(
        suffixIcon: Icon(
          Icons.lock,
          color: Colors.white.withOpacity(0.7),
        ),
        // filled: true,
        // fillColor: Colors.white.withOpacity(0.7),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Colors.white.withOpacity(0.7), width: 3),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Colors.white.withOpacity(0.7), width: 3),
          borderRadius: BorderRadius.circular(10),
        ),
        labelText: "password",
        labelStyle: TextStyle(
          color: Colors.white.withOpacity(0.7),
        ),
      ),
      obscureText: true,
      validator: (String value) {
        if (value.isEmpty) {
          return "Password too short";
        }
      },
      onSaved: (String value) {
        _authmode == AuthMode.login
            ? _loginFormData["password"] = value
            : _registerFormData["password"] = value;
      },
    );
  }

  Widget _nameTextField() {
    return TextFormField(
      style: TextStyle(
        color: Colors.white.withOpacity(0.7),
      ),
      decoration: InputDecoration(
        suffixIcon: Icon(
          Icons.person_outline,
          color: Colors.white.withOpacity(0.7),
        ),
        // filled: true,
        // fillColor: Colors.white.withOpacity(0.7),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Colors.white.withOpacity(0.7), width: 3),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Colors.white.withOpacity(0.7), width: 3),
          borderRadius: BorderRadius.circular(10),
        ),
        labelText: "name",
        labelStyle: TextStyle(
          color: Colors.white.withOpacity(0.7),
        ),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return "Please enter a valid name";
        }
      },
      onSaved: (String value) {
        _registerFormData["name"] = value;
      },
    );
  }

  Widget _emailTextField() {
    return TextFormField(
      style: TextStyle(
        color: Colors.white.withOpacity(0.7),
      ),
      decoration: InputDecoration(
        suffixIcon: Icon(
          Icons.email,
          color: Colors.white.withOpacity(0.7),
        ),
        // filled: true,
        // fillColor: Colors.white.withOpacity(0.7),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Colors.white.withOpacity(0.7), width: 3),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Colors.white.withOpacity(0.7), width: 3),
          borderRadius: BorderRadius.circular(10),
        ),
        labelText: "email ID",
        labelStyle: TextStyle(
          color: Colors.white.withOpacity(0.7),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
          return 'Please enter a valid email';
        }
      },
      onSaved: (String value) {
        _registerFormData["email"] = value;
      },
    );
  }

  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
      fit: BoxFit.cover,
      image: AssetImage('assets/authpage.jpg'),
    );
  }

  void _submitForm(final Map<String, dynamic> user) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    _authmode == AuthMode.login ? userLogin(user) : userRegister(user);
  }

  @override
  Widget build(BuildContext context) {
    final double _targetWidth = MediaQuery.of(context).size.width > 550.0
        ? 500.0
        : MediaQuery.of(context).size.width * 0.95;

    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
          image: _buildBackgroundImage(),
        ),
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: _targetWidth,
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Text(
                      "INTERFICIO",
                      style: TextStyle(
                          fontSize: 59,
                          color: Color(0xFFC84407),
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                        height: _authmode == AuthMode.login
                            ? MediaQuery.of(context).size.height / 6
                            : 0),
                    _authmode == AuthMode.login
                        ? Container()
                        : _nameTextField(),
                    SizedBox(
                      height: 10.0,
                    ),
                    _authmode == AuthMode.login
                        ? Container()
                        : _emailTextField(),
                    SizedBox(
                      height: 10.0,
                    ),
                    _usernameTextField(),
                    SizedBox(
                      height: 10.0,
                    ),
                    _passwordTextField(),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          FlatButton(
                            child: Text(
                              'switch to ${_authmode == AuthMode.login ? 'register' : 'login'}',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              setState(() {
                                _authmode = _authmode == AuthMode.login
                                    ? AuthMode.register
                                    : AuthMode.login;
                              });
                            },
                          ),
                          _isLoading
                              ? Container(
                                  padding: EdgeInsets.only(right: 20),
                                  child: CircularProgressIndicator())
                              : FlatButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  color: Colors.white.withOpacity(0.3),
                                  splashColor: Theme.of(context).accentColor,
                                  child: Text(
                                    '${_authmode == AuthMode.login ? 'LOGIN' : 'REGISTER'}',
                                    style: TextStyle(fontSize: 15.0),
                                  ),
                                  onPressed: () => _submitForm(user),
                                ),
                        ]),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
