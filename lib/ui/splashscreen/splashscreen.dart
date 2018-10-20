import 'package:intro_slider/intro_slider.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String introScreen;
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    loadSavedData();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });

    Timer(Duration(seconds: 4, milliseconds: 200), () {
      if (introScreen == null) {
        saveData();
        Navigator.of(context).pushNamedAndRemoveUntil(
              '/ui/intro', (Route<dynamic> route) => false);
      } else {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/ui/dashboard', (Route<dynamic> route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/gifs/mario.gif"), fit: BoxFit.fill)));
  }

  loadSavedData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      introScreen = preferences.getString('display');
    });
  }

  saveData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('display', 'no');
  }
}


class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {

  List<Slide> slides = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    slides.add(
      new Slide(
        pathImage: "images/introscreen/mario.jpg",
        backgroundColor: 0xfff5a623,
      ),
    );
    slides.add(
      new Slide(
        pathImage: "images/introscreen/god of war.jpg",
        backgroundColor: 0xff203152,
      ),
    );
    slides.add(
      new Slide(
        pathImage: "images/introscreen/joker.jpg",
        backgroundColor: 0xff9932CC,
      ),
    );

  }

  void onDonePress() {
    // TODO: go to next screen
    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/ui/dashboard', (Route<dynamic> route) => false);
  }

  void onSkipPress() {
    // TODO: go to next screen
    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/ui/dashboard', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      slides: this.slides,
      onDonePress: this.onDonePress,
      onSkipPress: this.onSkipPress,
    );
  }
}