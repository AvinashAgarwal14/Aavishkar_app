import 'package:flutter/material.dart';
import '../../util/drawer.dart';
import './dashboard_layout.dart';
import './newsfeed.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}
class _DashboardState extends State<Dashboard> {

  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  var _currentState = 0;

  List Views = [
    DashBoardLayout(),
    Newsfeed()
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        setState(() {
          _currentState=1;
        });
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        setState(() {
          _currentState=1;
        });
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard")
      ),
      drawer: NavigationDrawer(),
      body: Views[_currentState],
      bottomNavigationBar: Container(
//        color: Color.fromRGBO(255, 255, 255, 40.0),
        child: BottomNavigationBar(
          currentIndex: _currentState,
          onTap:(int index){
            setState(() {
              _currentState = index;
            });
          },
          items:[
            BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                title: Text("Dashboard")
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.rss_feed),
                title: Text("Newsfeed")
            )
          ],
        ),
      )
    );
  }
}
