import 'package:flutter/material.dart';
import '../../util/drawer.dart';
import './dashboard_layout.dart';
import './newsfeed.dart';
import '../../model/event.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}
class _DashboardState extends State<Dashboard> {

  var _currentState = 0;

  List Views = [
    DashBoardLayout(),
    Newsfeed()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard")
      ),
      drawer: NavigationDrawer(),
      body: Views[_currentState],
      bottomNavigationBar: BottomNavigationBar(
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
      )
    );
  }
}
