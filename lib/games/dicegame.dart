import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter/rendering.dart';

import 'app/views/home_page.dart';
import '21-card-game/views/21_game.dart';

class MyDiceApp extends StatefulWidget {
  @override
  _MyDiceAppState createState() => _MyDiceAppState();
}

class _MyDiceAppState extends State<MyDiceApp> {
  @override
  void initState() {
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark));
            Navigator.pop(context);
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        //debugShowMaterialGrid: true,
        theme: ThemeData(
            iconTheme: IconThemeData(color: Colors.grey),
            buttonTheme: ButtonThemeData(buttonColor: Colors.grey),
            brightness: Brightness.dark,
            primaryColor: Colors.white,
            accentColor: Colors.grey),
        routes: {
          "/": (BuildContext context) => HomePage(),
          "/21game": (BuildContext context) => CardGame(),
        },
      ),
    );
  }
}
