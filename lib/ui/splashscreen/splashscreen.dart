import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String introScreen;

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    loadSavedData();
  }

  @override
  Widget build(BuildContext context) {
    if (introScreen == null) {
      saveData();
      Timer(Duration(seconds: 2), () {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/ui/intro', (Route<dynamic> route) => false);
      });
    } else {
      Timer(Duration(seconds: 2), () {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/ui/dashboard', (Route<dynamic> route) => false);
      });
    }
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
  int imageIndex = 0;

  List<AssetImage> images = [
    AssetImage("images/events.png"),
    AssetImage("images/events.png"),
    AssetImage("images/events.png"),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/events.png"), fit: BoxFit.fill)
            )
        ),
        Container(
          padding: EdgeInsets.only(bottom: 40.0),
          alignment: Alignment.bottomCenter,
          child: new SizedBox(
            height: 5.0,
            child: new Center(
              child: new Container(
                margin: new EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
                height: 1.5,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        Container(
            alignment: Alignment.bottomRight,
            child: FlatButton(
              child: Text("Next"),
              onPressed: () {
                imageIndex++;
                if (imageIndex == 3) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/ui/dashboard', (Route<dynamic> route) => false);
                }
              },
            ))
      ],
    );
  }
}
