// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import '../loginAnimation.dart';
import 'package:flutter/animation.dart';
import '../styles.dart';
import '../Components/WhiteTick.dart';
import '../../activities/events/event_details.dart';

class LogInPage extends StatefulWidget {
  @override
  State createState() => new LogInPageState();
}

class LogInPageState extends State<LogInPage> with TickerProviderStateMixin {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;
  static final GlobalKey<ScaffoldState> _scaffoldKey =
  new GlobalKey<ScaffoldState>();
  final double _appBarHeight = 256.0;
  AppBarBehavior _appBarBehavior = AppBarBehavior.pinned;

  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn;
  var _facebookLogin;
  bool _loggedIn = false;
  int click, gclick;

  AnimationController _glogInButtonController;
  AnimationController _flogInButtonController;
  var animationStatus = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _glogInButtonController = new AnimationController(
        duration: new Duration(milliseconds: 3000),
        vsync: this,
        debugLabel: "google");
    _flogInButtonController = new AnimationController(
        duration: new Duration(milliseconds: 3000),
        vsync: this,
        debugLabel: "facebook");

    _googleSignIn = new GoogleSignIn();
    _facebookLogin = new FacebookLogin();
    click = 0;
    gclick = 0;
  }

  @override
  void dispose() {
    _flogInButtonController.dispose();
    _glogInButtonController.dispose();
    super.dispose();
  }

  Future<Null> _playAnimation(int n) async {
    try {
      if (n == 1)
        await _glogInButtonController.forward();
      else
        await _flogInButtonController.forward();
    } on TickerCanceled {}
    setState(() {});
    //await _glogInButtonController.reverse();
  }

  Future<Null> _reverseAnimation(int n) async {
    try {
      if (n == 1)
        await _glogInButtonController.reverse();
      else
        await _flogInButtonController.reverse();
    } on TickerCanceled {}
    setState(() {});
    //await _glogInButtonController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loggedIn) {
      return new Scaffold(
          body: new Container(
              decoration: new BoxDecoration(
                image: backgroundImage,
              ),
              child: new Container(
                  decoration: new BoxDecoration(
                      gradient: new LinearGradient(
                        colors: <Color>[
                          const Color.fromRGBO(162, 146, 199, 0.8),
                          const Color.fromRGBO(51, 51, 63, 0.9),
                        ],
                        stops: [0.2, 1.0],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(0.0, 1.0),
                      )),
                  child: new ListView(
                      padding: const EdgeInsets.all(0.0),
                      children: <Widget>[
                        new Stack(
                            alignment: AlignmentDirectional.topCenter,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 100.0,
                                  ),
                                  new Tick(image: tick),
                                ],
                              ),
                              //new SignUp()

                              animationStatus == 0
                                  ? (Center(
                                child: Container(
                                    child: new Column(
                                      children: <Widget>[
                                        new SizedBox(
                                          height: 400.0,
                                        ),
                                        new Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 50.0),
                                          child: new InkWell(
                                              onTap: () {
                                                setState(() {
                                                  animationStatus = 1;
                                                });
                                              },
                                              child: SignIn(
                                                  "Sign in with Google")),
                                        ),
                                        new Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 50.0),
                                          child: new InkWell(
                                              onTap: () {
                                                setState(() {
                                                  animationStatus = 2;
                                                });
                                              },
                                              child: SignIn(
                                                  "Sign in with Facebook")),
                                        )
                                      ],
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                    )),
                              ))
                                  :
                              //(animationStatus==1)?
                              FutureBuilder(
                                  future: animationStatus == 1
                                      ? _gSignIn()
                                      : _fSignIn(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    if (_loggedIn == false) {
                                      return Center(
                                          child: CircularProgressIndicator(
                                            value: null,
                                            strokeWidth: 1.0,
                                            valueColor:
                                            new AlwaysStoppedAnimation<
                                                Color>(Colors.white),
                                          ));
                                    } else {
                                      _playAnimation(animationStatus);
                                      return StaggerAnimation(
                                          buttonController:
                                          animationStatus == 2
                                              ? _flogInButtonController
                                              .view
                                              : _glogInButtonController
                                              .view);
                                    }
                                  })
                              //:Container(),
                            ])
                      ]))));
    } else {
      return new Theme(
          data: new ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.indigo,
            platform: Theme.of(context).platform,
          ),
          child: new Scaffold(
              key: _scaffoldKey,
              body: new CustomScrollView(slivers: <Widget>[
                new SliverAppBar(
                  expandedHeight: _appBarHeight,
                  pinned: _appBarBehavior == AppBarBehavior.pinned,
                  floating: _appBarBehavior == AppBarBehavior.floating ||
                      _appBarBehavior == AppBarBehavior.snapping,
                  snap: _appBarBehavior == AppBarBehavior.snapping,
                  flexibleSpace: new FlexibleSpaceBar(
                    title: Text('Profile'),
                    background: new Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        new Image.asset(
                          "images/events.png",
                          fit: BoxFit.cover,
                          height: _appBarHeight,
                        ),
                        // This gradient ensures that the toolbar icons are distinct
                        // against the background image.
                        const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment(0.0, -1.0),
                              end: Alignment(0.0, -0.4),
                              colors: <Color>[
                                Color(0x60000000),
                                Color(0x00000000)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                new SliverList(
                    delegate: new SliverChildListDelegate(<Widget>[
                      DetailCategory(
                        icon: Icons.person,
                        children: <Widget>[
                          DetailItem(
                            lines: <String>["Name :", "Avinash Agarwal"],
                          )
                        ],
                      ),
                      DetailCategory(
                        icon: Icons.email,
                        children: <Widget>[
                          DetailItem(
                            lines: <String>["Email :", "agarwalavinash@gamil.com"],
                          )
                        ],
                      ),
                      DetailCategory(
                        icon: Icons.videogame_asset,
                        children: <Widget>[
                          DetailItem(
                            icon: Icons.videogame_asset ,
                            onPressed: (){
                              print("Eurocoin!");
                            },
                            lines: <String>["Eurocin :", "0"],
                          )
                        ],
                      ),
                      DetailCategory(
                        icon: Icons.remove_circle,
                        children: <Widget>[
                          DetailItem(
                            icon: Icons.remove_circle,
                            onPressed: (){
                              if(animationStatus==1)
                                _gSignOut();
                              else  if (animationStatus==2)
                                _fSignOut();
                              print("Logout!");
                            },
                            lines: <String>['Logout',''],
                          )
                        ],
                      )
                    ]))
              ])));
    }
  }

  _gSignOut() {
    _googleSignIn.signOut();
    setState(() {
      _loggedIn = false;
    });
    animationStatus = 0;
    _reverseAnimation(1);
//     _playAnimation();
//       return (BuildContext context){
//         new StaggerAnimation(buttonController: _glogInButtonController);
//       };
  }

  _fSignOut() {
    _facebookLogin.logOut();
    _loggedIn = false;
    animationStatus = 0;
    _reverseAnimation(2);
  }

  Future _gSignIn() async {
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount.authentication;

    FirebaseUser user = await _auth.signInWithGoogle(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken,
    );
    if (user != null) {
      setState(() {
        _loggedIn = true;
      });
    }
    database
        .reference()
        .child("Profiles")
        .update({"${user.uid}": "${user.email}"});
    print("User: $user");
  }

  Future _fSignIn() async {
    final result = await _facebookLogin.logInWithReadPermissions(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        print(result.accessToken.token);
        FirebaseUser user = await _auth.signInWithFacebook(
            accessToken: result.accessToken.token);
        if (user != null) {
          setState(() {
            _loggedIn = true;
          });
        }
        database
            .reference()
            .child("Profiles")
            .update({"${user.uid}": "${user.email}"});
        break;
      case FacebookLoginStatus.cancelledByUser:
        print('CANCEL _loggedIn=true;ED BY USER');
        break;
      case FacebookLoginStatus.error:
        print(result.errorMessage);
        break;
    }
  }

  SignIn(String str) {
    return (new Container(
      width: 320.0,
      height: 60.0,
      alignment: FractionalOffset.center,
      decoration: new BoxDecoration(
        color: const Color.fromRGBO(247, 64, 106, 1.0),
        borderRadius: new BorderRadius.all(const Radius.circular(30.0)),
      ),
      child: new Text(
        str,
        maxLines: 1,
        style: new TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
          letterSpacing: 0.3,
        ),
      ),
    ));
  }
}
