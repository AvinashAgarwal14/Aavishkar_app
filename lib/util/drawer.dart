import 'package:aavishkarapp/ui/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import '../ui/activities/main.dart';
import '../ui/search_by_tags/tags.dart';
import '../ui/maps/map.dart';
import '../ui/account/login.dart';
import '../ui/scoreboard/scoreboard.dart';
import '../ui/schedule/schedule.dart';
import '../ui/eurocoin/eurocoin.dart';
import '../ui/about_us/about_us.dart';
import '../ui/sponsors/sponsors.dart';
import '../util/navigator_transitions/slide_left_transitions.dart';

class NavigationDrawer extends StatefulWidget {
  @override
  _NavigationDrawerState createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  static int presestPageNumber = 0;

  @override
  Widget build(BuildContext context) {
    return new Theme(
        data: new ThemeData(
            canvasColor: Color.fromRGBO(225, 225, 225, 40.0),
        ),
        child: Drawer(
            child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
          DrawerHeader(
            padding: EdgeInsets.all(0.0) ,
            child: Image.asset("images/events.png", fit: BoxFit.fill),
//              child: Container(
//            child: Column(
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
//                CircleAvatar(
//                  radius: 50.0,
//                  child: Image.asset("images/events.png"),
//                ),
//                Container(
//                  padding: EdgeInsets.only(top: 15.0),
//                  child: Text("Aavishkar"),
//                )
//              ],
//            ),
//          )
          ),
          Container(
            color: (presestPageNumber==0)?Color.fromRGBO(225, 225, 225, 40.0):Color.fromRGBO(54, 59, 94, 40.0),
            child: ListTile(
                title: Text("Home", style: TextStyle(
                color: (presestPageNumber==0)?Colors.black:Colors.white)
                ),
                selected: (presestPageNumber == 0) ? true : false,
                onTap: () {
                  setState(() {
                    presestPageNumber = 0;
                  });
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                }),
          ),
          Container(
              color: (presestPageNumber==1)?Color.fromRGBO(225, 225, 225, 40.0):Color.fromRGBO(54, 59, 94, 40.0),
              child: ListTile(
                  title: Text("Eurocoin", style: TextStyle(
                      color: (presestPageNumber==1)?Colors.black:Colors.white)),
                  selected: (presestPageNumber == 1) ? true : false,
                  onTap: () {
                    if (presestPageNumber == 1)
                      Navigator.pop(context);
                    else {
                      setState(() {
                        presestPageNumber = 1;
                      });
                      Navigator.popUntil(context, ModalRoute.withName('/'));
                      Navigator.of(context)
                          .push(SlideLeftRoute(widget: EurocoinHomePage()));
                    }
                  })),
          Container(
              color: (presestPageNumber==2)?Color.fromRGBO(225, 225, 225, 40.0):Color.fromRGBO(54, 59, 94, 40.0),
              child: ListTile(
                  title: Text("Scoreboard", style: TextStyle(
                      color: (presestPageNumber==2)?Colors.black:Colors.white)),
                  selected: (presestPageNumber == 2) ? true : false,
                  onTap: () {
                    if (presestPageNumber == 2)
                      Navigator.pop(context);
                    else {
                      setState(() {
                        presestPageNumber = 2;
                      });
                      Navigator.popUntil(context, ModalRoute.withName('/'));
                      Navigator.of(context)
                          .push(SlideLeftRoute(widget: ScoreBoard()));
                    }
                  })),
          Container(
              color: (presestPageNumber==3)?Color.fromRGBO(225, 225, 225, 40.0):Color.fromRGBO(54, 59, 94, 40.0),
              child: ListTile(
                title: Text("Tags", style: TextStyle(
                    color: (presestPageNumber==3)?Colors.black:Colors.white)),
                selected: (presestPageNumber == 3) ? true : false,
                onTap: () {
                  if (presestPageNumber == 3)
                    Navigator.pop(context);
                  else {
                    setState(() {
                      presestPageNumber = 3;
                    });
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                    Navigator.of(context)
                        .push(SlideLeftRoute(widget: SearchByTags()));
                  }
                },
              )),
          Container(
              color: (presestPageNumber==4)?Color.fromRGBO(225, 225, 225, 40.0):Color.fromRGBO(54, 59, 94, 40.0),
              child: ListTile(
                title: Text("Schedule", style: TextStyle(
                    color: (presestPageNumber==4)?Colors.black:Colors.white)),
                selected: (presestPageNumber == 4) ? true : false,
                onTap: () {
                  if (presestPageNumber == 4)
                    Navigator.pop(context);
                  else {
                    setState(() {
                      presestPageNumber = 4;
                    });
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                    Navigator.of(context)
                        .push(SlideLeftRoute(widget: Schedule()));
                  }
                },
              )),
          Container(
              color: (presestPageNumber==5)?Color.fromRGBO(225, 225, 225, 40.0):Color.fromRGBO(54, 59, 94, 40.0),
              child: ListTile(
                  title: Text("Activities", style: TextStyle(
                      color: (presestPageNumber==5)?Colors.black:Colors.white)),
                  selected: (presestPageNumber == 5) ? true : false,
                  onTap: () {
                    if (presestPageNumber == 5)
                      Navigator.pop(context);
                    else {
                      setState(() {
                        presestPageNumber = 5;
                      });
                      Navigator.popUntil(context, ModalRoute.withName('/'));
                      Navigator.of(context)
                          .push(SlideLeftRoute(widget: ActivitiesHomePage()));
                    }
                  })),
          Container(
              color: (presestPageNumber==6)?Color.fromRGBO(225, 225, 225, 40.0):Color.fromRGBO(54, 59, 94, 40.0),
              child: ListTile(
                title: Text("Maps", style: TextStyle(
                    color: (presestPageNumber==6)?Colors.black:Colors.white)),
                selected: (presestPageNumber == 6) ? true : false,
                onTap: (() {
                  if (presestPageNumber == 6)
                    Navigator.pop(context);
                  else {
                    setState(() {
                      presestPageNumber = 6;
                    });
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                    Navigator.of(context)
                        .push(SlideLeftRoute(widget: MapPage()));
                  }
                }),
              )),
          Container(
              color: (presestPageNumber==7)?Color.fromRGBO(225, 225, 225, 40.0):Color.fromRGBO(54, 59, 94, 40.0),
              child: ListTile(
                title: Text("About Us", style: TextStyle(
                    color: (presestPageNumber==7)?Colors.black:Colors.white)),
                selected: (presestPageNumber == 7) ? true : false,
                onTap: (() {
                  if (presestPageNumber == 7)
                    Navigator.pop(context);
                  else {
                    setState(() {
                      presestPageNumber = 7;
                    });
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                    Navigator.of(context)
                        .push(SlideLeftRoute(widget: AboutUsPage()));
                  }
                }),
              )),
          Container(
              color: (presestPageNumber==8)?Color.fromRGBO(225, 225, 225, 40.0):Color.fromRGBO(54, 59, 94, 40.0),
              child: ListTile(
                title: Text("Account", style: TextStyle(
                    color: (presestPageNumber==8)?Colors.black:Colors.white)),
                selected: (presestPageNumber == 8) ? true : false,
                onTap: (() {
                  if (presestPageNumber == 8)
                    Navigator.pop(context);
                  else {
                    setState(() {
                      presestPageNumber = 8;
                    });
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                    Navigator.of(context)
                        .push(SlideLeftRoute(widget: LogInPage()));
                  }
                }),
              )),
          Container(
              color: (presestPageNumber==9)?Color.fromRGBO(225, 225, 225, 40.0):Color.fromRGBO(54, 59, 94, 40.0),
              child: ListTile(
                title: Text("Sponsors", style: TextStyle(
                    color: (presestPageNumber==9)?Colors.black:Colors.white)),
                selected: (presestPageNumber == 9) ? true : false,
                onTap: (() {
                  if (presestPageNumber == 9)
                    Navigator.pop(context);
                  else {
                    setState(() {
                      presestPageNumber = 9;
                    });
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                    Navigator.of(context)
                        .push(SlideLeftRoute(widget: Sponsors()));
                  }
                }),
              )),
        ])));
  }
}
