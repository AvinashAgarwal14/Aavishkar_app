import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class HomePage extends StatefulWidget {
  final Map<String, dynamic> user;
  HomePage(this.user);

  @override
  _HomePageState createState() => _HomePageState(user);
}

GoogleMapController mapController;

String api_url = "phoenix7139.pythonanywhere.com";

bool header = false;

class _HomePageState extends State<HomePage> {
  final Map<String, dynamic> user;
  _HomePageState(this.user);

  var currentLocation = LocationData;
  var location = new Location();
  var lat, long, accuracy;

  Map<String, dynamic> levelData = {}; //stores data of current level of user
  List<dynamic> leaderboard; //stores the current leaderboard

  final _answerFieldController =
      TextEditingController(); //to retrieve textfield value

  final _fieldFocusNode = new FocusNode(); //to deselect answer textfield

  bool _isLoading = false;

  void getLocation() async {
    bool perm = await location.hasPermission();
    print(perm);
    LocationData currentLocation = await location.getLocation();
    location.changeSettings(accuracy: LocationAccuracy.HIGH);
    setState(() {
      location.onLocationChanged().listen((LocationData currentLocation) {
        setState(() {
          lat = currentLocation.latitude;
          long = currentLocation.longitude;
          accuracy = currentLocation.accuracy;
        });
      });
    });
  }

//this function retrieves the data of the current level of the user
  Future getLevelData() async {
    setState(() {
      _isLoading = true;
    });
    http.Response response = await http.get(
        Uri.encodeFull("http://$api_url/api/getlevel/"),
        headers: {"Authorization": "Token ${user["token"]}"});
    levelData = json.decode(response.body);
    setState(() {
      _isLoading = false;
    });
  }

//this function retrieves the current leaderboard
  Future getScoreboard() async {
    http.Response response = await http.get(
        Uri.encodeFull("http://$api_url/api/scoreboard/"),
        headers: {"Authorization": "Token ${user["token"]}"});
    leaderboard = json.decode(response.body);
  }

//this functions submits an answer to the main question of a level
  Future submitLevelAnswer(answer) async {
    setState(() {
      _isLoading = true;
    });
    http.Response response = await http.post(
      Uri.encodeFull("http://$api_url/api/submit/ans/"),
      headers: {
        "Authorization": "Token ${user["token"]}",
        "Content-Type": "application/json"
      },
      body: json.encode({
        "answer": answer,
        "level_no": levelData["level_no"],
      }),
    );
    var data = json.decode(response.body);
    print(data);

    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(data["success"] == true ? "correct answer" : "try again"),
      duration: Duration(seconds: 1),
    ));
    setState(() {
      _answerFieldController.clear();
      getLevelData();
    });
  }

//this function submits the current location of the user
  Future submitLocation() async {
    setState(() {
      _isLoading = true;
    });
    http.Response response = await http.post(
      Uri.encodeFull("http://$api_url/api/submit/location/"),
      headers: {
        "Authorization": "Token ${user["token"]}",
        "Content-Type": "application/json"
      },
      body: json.encode({
        "lat": lat,
        "long": long,
        "level_no": levelData["level_no"],
      }),
    );
    var data = json.decode(response.body);

    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(data["success"] == true ? "correct location" : "try again"),
      duration: Duration(seconds: 1),
    ));
    setState(() {
      getLevelData();
    });
  }

  @override
  void dispose() {
    _answerFieldController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    {
      getLocation();
      getLevelData();
      getScoreboard();
    }
  }

  bool _isUp =
      true; //to maintain state of the animation of leaderboard, instruction sheet
  bool _isOpen = false; //to maintain animation of question, answer box

  final _scaffoldKey = GlobalKey<ScaffoldState>(); //for bottomsnackbar

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;

//animation using animatedpositioned. mean position toggle values
    double bottom = _isUp ? 55.0 : (deviceSize.height / 2);
    double top = _isUp
        ? (_isOpen ? deviceSize.height / 3 : (deviceSize.height - 145))
        : bottom;
    double top2 =
        _isUp ? (deviceSize.height - 35) : ((deviceSize.height) / 2) + 10;
    var bottom3 = _isUp ? deviceSize.height : ((deviceSize.height) / 2) + 10;
    var bottom4 = _isUp ? 10.0 : deviceSize.height - 80;
    var right4 = 20.0;

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: true,
      drawer: Drawer(
        child: Text("drawer"),
      ),
      body: Stack(
        children: <Widget>[
          GameMap(), //google map as main background of the app
          AnimatedPositioned(
            //top instructions panel
            bottom: bottom3,
            right: 0.0,
            left: 0.0,
            top: -15.0,
            duration: Duration(milliseconds: 900),
            curve: Curves.easeOutQuart,
            child: Center(
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 900),
                curve: Curves.easeOutQuart,
                opacity: _isUp ? 0.5 : 0.8,
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          offset: Offset.zero,
                          blurRadius: 10,
                          spreadRadius: 5),
                    ],
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.7, 1.0],
                      colors: [Colors.black, Colors.grey],
                    ),
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 25, 10, 10),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "INSTRUCTIONS",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            //level box displayed on home page
            bottom: bottom,
            right: 10.0,
            left: 10.0,
            top: top,
            duration: Duration(milliseconds: 900),
            curve: Curves.bounceOut,
            child: Center(
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 900),
                curve: Curves.easeOutQuart,
                opacity: _isUp ? (_isOpen ? 0.9 : 0.7) : 0.0,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isOpen = !_isOpen;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            offset: Offset.zero,
                            blurRadius: 10,
                            spreadRadius: 5),
                      ],
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: 0.0,
                          left: 0.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              _isLoading
                                  ? Container(
                                      padding: EdgeInsets.only(right: 20),
                                      child: CircularProgressIndicator())
                                  : levelData["title"] == null
                                      ? Text(
                                          levelData["level"],
                                          style: TextStyle(
                                            color: _isOpen
                                                ? Color(0xFF0059B3)
                                                : Colors.white,
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : Text(
                                          levelData["title"],
                                          style: TextStyle(
                                            color: _isOpen
                                                ? Color(0xFF0059B3)
                                                : Colors.white,
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                              SizedBox(
                                width: 20.0,
                              ),
                              levelData["title"] == null
                                  ? Container()
                                  : levelData["map_hint"]
                                      ? Icon(
                                          Icons.location_on,
                                          size: 28,
                                        )
                                      : Icon(
                                          Icons.assistant_photo,
                                          size: 28,
                                        ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          _isLoading || levelData["title"] == null
              ? Container(
                  padding: EdgeInsets.only(right: 20),
                  child: CircularProgressIndicator())
              : AnimatedPositioned(
                  //question along with textfield for answer and submit button
                  top: _isOpen && _isUp
                      ? deviceSize.height / 3 + 60.0
                      : deviceSize.height + 5.0,
                  bottom: _isOpen && _isUp ? 75.0 : -5.0,
                  left: 20.0,
                  right: 20.0,
                  duration: Duration(milliseconds: 900),
                  curve: Curves.easeOutQuart,
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                    },
                    child: Container(
                      child: Center(
                        child: ScrollConfiguration(
                          behavior: MyBehavior(),
                          child: ListView(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFFFE000),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 7, horizontal: 15),
                                margin: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                child: Text(
                                  levelData["ques"],
                                  style: TextStyle(
                                      color: _isOpen
                                          ? Color(0xFF0091CC)
                                          : Colors.white,
                                      fontSize: 17,
                                      fontStyle: FontStyle.italic),
                                ),
                              ),
                              ListTile(
                                title: levelData["map_hint"]
                                    ? Container(
                                        child: Center(
                                          child: Column(
                                            children: <Widget>[
                                              ListTile(
                                                leading: Icon(Icons
                                                    .subdirectory_arrow_left),
                                                title: Text("LATITUDE: $lat"),
                                              ),
                                              ListTile(
                                                leading: Icon(Icons
                                                    .subdirectory_arrow_right),
                                                title: Text("LONGITUDE: $long"),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    : TextField(
                                        focusNode: _fieldFocusNode,
                                        controller: _answerFieldController,
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                        decoration: InputDecoration(
                                          filled: false,
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFF0091CC),
                                              width: 3.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  Colors.white.withOpacity(0.5),
                                              width: 3.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          labelText: 'answer here',
                                          labelStyle: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(0.5),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                              ),
                              ListTile(
                                title: FlatButton(
                                  child: Text("SUBMIT"),
                                  onPressed: () {
                                    setState(() {
                                      levelData["map_hint"]
                                          ? submitLocation()
                                          : submitLevelAnswer(
                                              _answerFieldController.text);
                                    });
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
          AnimatedPositioned(
            //leaderboard generated dynamically using listview.builder
            bottom: -15.0,
            right: 0.0,
            left: 0.0,
            top: top2,
            duration: Duration(milliseconds: 900),
            curve: Curves.easeOutQuart,
            child: Center(
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 900),
                curve: Curves.easeOutQuart,
                opacity: _isUp ? 0.6 : 0.8,
                child: GestureDetector(
                  onVerticalDragStart: (context) {
                    setState(() {
                      _isUp = !_isUp;
                      getScoreboard();
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            offset: Offset.zero,
                            blurRadius: 10,
                            spreadRadius: 5),
                      ],
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.5, 1.0],
                        colors: [Color(0xFF0091FF), Color(0xFF0059FF)],
                      ),
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: Center(
                      child: ListView.builder(
                        itemCount:
                            leaderboard == null ? 0 : leaderboard.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          if (index == 0) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(width: 40),
                                      Text(
                                        "name",
                                        style: TextStyle(
                                            fontSize: 31,
                                            fontStyle: FontStyle.italic,
                                            color: Color(0xFFFFE000)),
                                      )
                                    ]),
                                Text(
                                  "score",
                                  style: TextStyle(
                                      fontSize: 31,
                                      fontStyle: FontStyle.italic,
                                      color: Color(0xFFFFE000)),
                                )
                              ],
                            );
                          } else {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "$index",
                                      style: TextStyle(
                                          fontSize: 23,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      leaderboard[index - 1]["name"],
                                      style: TextStyle(
                                          fontSize: 23,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Text(
                                  "${leaderboard[index - 1]["score"]}",
                                  style: TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            //leaderboard icon that triggers animation
            bottom: deviceSize.height - top2 - 25,
            left: 20,
            top: top2 - 35,
            duration: Duration(milliseconds: 1200),
            curve: Curves.easeOutQuart,
            child: GestureDetector(
              onVerticalDragStart: (context) {
                setState(() {
                  _isUp = !_isUp;
                  getScoreboard();
                });
              },
              child: Image.asset("assets/leaderboard.png"),
            ),
          ),
          AnimatedPositioned(
            //info icon that triggers animation
            bottom: bottom4,
            right: right4,
            duration: Duration(milliseconds: 1200),
            curve: Curves.easeOutQuart,
            child: GestureDetector(
              onVerticalDragStart: (context) {
                setState(() {
                  _isUp = !_isUp;
                  getScoreboard();
                });
              },
              child: Icon(
                Icons.info,
                size: 70,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GameMap extends StatefulWidget {
  @override
  _GameMapState createState() => _GameMapState();
}

class _GameMapState extends State<GameMap> {
  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      myLocationButtonEnabled: true,
      initialCameraPosition: CameraPosition(
        target: LatLng(23.554079, 87.278687),
        zoom: 13,
      ),
      onMapCreated: _onMapCreated,
      myLocationEnabled: true,
      compassEnabled: true,
    );
  }

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
