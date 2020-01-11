import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'package:aavishkarapp/games/7-up-7-down/7up7down.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    justGetCoins();
    super.initState();
  }

  var coins_left;
  var fix = 2;
  bool _isLoading = false;
  GlobalKey _scaffoldkey = GlobalKey();
  void justGetCoins() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Response response = await Dio().post(
        "https://aavishkargames.herokuapp.com/sevenup/create",
        data: {"email": "romitkarmakar@gmail.com"});
    coins_left = response.data["coins"];
    print(response.data);
    await prefs.setInt('coins', coins_left);
    setState(() {
      _isLoading = false;
    });
  }

  void getCoins() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Response response = await Dio().post(
        "https://aavishkargames.herokuapp.com/sevenup/create",
        data: {"email": "romitkarmakar@gmail.com"});
    coins_left = response.data["coins"];
    print(response.data);
    await prefs.setInt('coins', coins_left);

    Response response2 = await Dio().post(
        "https://aavishkargames.herokuapp.com/sevenup/toss",
        data: {"email": "romitkarmakar@gmail.com"});

    fix = response2.data["result"];
    print(fix);

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => UpDownGame(coins_left, fix))).then((value) {
          setState(() {
            justGetCoins();
          });
        }) ;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Color(0xFF008F23),
        systemNavigationBarIconBrightness: Brightness.dark));
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "CASINO",
              style: TextStyle(
                  color: Colors.orange[400],
                  fontWeight: FontWeight.bold,
                  fontSize: 34.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.attach_money,
                  color: Colors.green[900],
                  //Color(0xFF4ef037),
                  size: 34,
                ),
                Text(
                  coins_left == null ? "" : "$coins_left",
                  style: TextStyle(color: Colors.green[900]),
                ),
              ],
            )
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Builder(
        builder: (context) => _isLoading
            ? Container(
                child: LinearProgressIndicator(),
              )
            : Column(
                children: <Widget>[
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Scaffold.of(context).showBottomSheet((context) {
                              return Container(
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(15)),
                                  height:
                                      MediaQuery.of(context).size.height / 8,
                                  padding: EdgeInsets.all(5),
                                  margin: EdgeInsets.all(5),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Text(
                                        "use 10 eurekoins to enter game?",
                                        style: TextStyle(
                                            fontSize: 21,
                                            color: Colors.blue[900]),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          FlatButton(
                                            color: Colors.blue[900],
                                            child: Text("Yes"),
                                            onPressed: () {
                                              setState(() {
                                                Navigator.pop(context);

                                                getCoins();
                                              });
                                            },
                                          ),
                                          FlatButton(
                                            color: Colors.blue[900],
                                            child: Text("No"),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          )
                                        ],
                                      )
                                    ],
                                  ));
                            }, backgroundColor: Colors.white.withOpacity(0));

                            // setState(() {
                            //   Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //           builder: (context) => UpDownGame()));
                            //   SystemChrome.setSystemUIOverlayStyle(
                            //       SystemUiOverlayStyle(
                            //           statusBarColor: Color(0xFF6ED2CA),
                            //           systemNavigationBarIconBrightness:
                            //               Brightness.dark));
                            // });
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height / 2.5,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/dicegame.jpg"),
                                  fit: BoxFit.contain),
                            ),
                          ),
                        ),
                        Text("7 UP 7 DOWN"),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              Navigator.pushNamed(context, '/21game');
                              SystemChrome.setSystemUIOverlayStyle(
                                  SystemUiOverlayStyle(
                                      statusBarColor: Color(0xFFF2837A),
                                      systemNavigationBarIconBrightness:
                                          Brightness.dark));
                            });
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height / 2.5,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/cardgame.jpg"),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        Text("BLACKJACK")
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
