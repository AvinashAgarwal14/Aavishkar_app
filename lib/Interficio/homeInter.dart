import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:latlong/latlong.dart' as ll;

class InterficioPage extends StatefulWidget {
  InterficioPage();

  @override
  _InterficioPageState createState() => _InterficioPageState();
}

GoogleMapController mapController;

class _InterficioPageState extends State<InterficioPage> {
  _InterficioPageState();

  var currentLocation = LocationData;
  var location = new Location();
  var lat, long, accuracy;

  var corlat = 23.547771;
  var corlong = 87.289857;

  var ovallat = 23.549896;
  var ovallong = 87.291763;

  var meter1, meter2;

  @override
  void initState() {
    super.initState();
    {
      location.changeSettings(accuracy: LocationAccuracy.HIGH);
      location.onLocationChanged().listen((LocationData currentLocation) {
        setState(() {
          lat = currentLocation.latitude;
          long = currentLocation.longitude;
          ll.Distance distance = new ll.Distance();
          meter1 = distance(
              new ll.LatLng(lat, long), new ll.LatLng(corlat, corlong));
          meter2 = distance(
              new ll.LatLng(lat, long), new ll.LatLng(ovallat, ovallong));
          accuracy = currentLocation.accuracy;
          // print(lat);
          // print(long);
        });
      });
    }
  }

  bool _isUp = true;

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;

    double bottom = _isUp ? 55.0 : (deviceSize.height / 2);
    double top = _isUp ? (deviceSize.height - 145) : bottom;

    double top2 =
        _isUp ? (deviceSize.height - 35) : ((deviceSize.height) / 2) + 10;

    var bottom3 = _isUp ? deviceSize.height : ((deviceSize.height) / 2) + 10;

    var bottom4 = _isUp ? 10.0 : deviceSize.height - 80;
    var right4 = 20.0;

    return Scaffold(
      drawer: Drawer(
        child: Text("drawer"),
      ),
      // appBar: AppBar(
      //   title: Text("Home"),
      //   backgroundColor: Colors.black,
      // ),
      body: Stack(
        children: <Widget>[
          GameMap(),
          AnimatedPositioned(
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
                    // gradient: LinearGradient(
                    //   begin: Alignment.topCenter,
                    //   end: Alignment.bottomCenter,
                    //   stops: [0.5, 1.0],
                    //   colors: [Colors.green, Colors.lightGreen],
                    // ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.7, 1.0],
                      colors: [Colors.black, Colors.grey],
                    ),
                    // color: Colors.black,
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
            bottom: bottom,
            right: 10.0,
            left: 10.0,
            top: top,
            duration: Duration(milliseconds: 900),
            curve: Curves.easeOutQuart,
            child: Center(
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 900),
                curve: Curves.easeOutQuart,
                opacity: _isUp ? 0.7 : 0.0,
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: Center(
                    child: Text(
                      "INTERFICIO",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedPositioned(
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
                opacity: _isUp ? 0.5 : 0.8,
                child: GestureDetector(
                  onVerticalDragStart: (context) {
                    setState(() {
                      if (_isUp) {
                        top2 = ((deviceSize.height) / 2) + 10;

                        bottom = 55;
                        top = deviceSize.height - 145;

                        bottom3 = deviceSize.height;

                        bottom4 = 10;
                        right4 = 10;

                        _isUp = !_isUp;
                      } else {
                        top2 = (deviceSize.height - 35);

                        bottom = deviceSize.height / 2;
                        top = bottom;

                        bottom3 = ((deviceSize.height) / 2) + 10;

                        bottom4 = deviceSize.height - 80;
                        right4 = 20;

                        _isUp = !_isUp;
                      }
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                    // margin: EdgeInsets.symmetric(vertical: 50),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.5, 1.0],
                        colors: [Color(0xFF0091FF), Color(0xFF0059FF)],
                      ),
                      //color: Color(0xFF0091FF),
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: Center(
                      child: ScrollConfiguration(
                        behavior: MyBehavior(),
                        child: ListView(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ListTile(
                              leading: Text("LATITUDE: $lat"),
                            ),
                            ListTile(
                              leading: Text("LONGITUDE: $long"),
                            ),
                            ListTile(
                              leading: Text("ACCURACY: $accuracy"),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            bottom: deviceSize.height - top2 - 25,
            left: 20,
            top: top2 - 35,
            duration: Duration(milliseconds: 1200),
            curve: Curves.easeOutQuart,
            child: GestureDetector(
              onVerticalDragStart: (context) {
                setState(() {
                  if (_isUp) {
                    top2 = (deviceSize.height) / 2 + 10;

                    bottom = 55;
                    top = deviceSize.height - 145;

                    bottom3 = deviceSize.height;

                    bottom4 = 10;
                    right4 = 10;

                    _isUp = !_isUp;
                  } else {
                    top2 = deviceSize.height - 35;

                    bottom = deviceSize.height / 2;
                    top = bottom;

                    bottom3 = ((deviceSize.height) / 2) + 10;

                    bottom4 = deviceSize.height - 80;
                    right4 = 20;

                    _isUp = !_isUp;
                  }
                });
              },
              child: Image.asset("assets/leaderboard.png"),
            ),
          ),
          AnimatedPositioned(
            bottom: bottom4,
            right: right4,
            duration: Duration(milliseconds: 1200),
            curve: Curves.easeOutQuart,
            child: GestureDetector(
              onVerticalDragStart: (context) {
                setState(() {
                  if (_isUp) {
                    top2 = (deviceSize.height) / 2 + 10;

                    bottom = 55;
                    top = deviceSize.height - 145;

                    bottom3 = deviceSize.height;

                    bottom4 = 10;
                    right4 = 10;

                    _isUp = !_isUp;
                  } else {
                    top2 = deviceSize.height - 35;

                    bottom = deviceSize.height / 2;
                    top = bottom;

                    bottom3 = ((deviceSize.height) / 2) + 10;

                    bottom4 = deviceSize.height - 80;
                    right4 = 20;

                    _isUp = !_isUp;
                  }
                });
              },
              child: Icon(
                Icons.info,
                size: 70,
              ),

              //Image.asset("assets/instructions.png"),
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
      //mapType: MapType.hybrid,
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
