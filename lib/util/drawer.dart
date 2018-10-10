import '../ui/game/lib/main.dart';
import 'package:flutter/material.dart';
import '../ui/activities/main.dart';
import '../ui/search_by_tags/tags.dart';
import '../ui/maps/map.dart';
import '../ui/account/login.dart';
import '../ui/scoreboard/scoreboard.dart';
import '../ui/schedule/schedule.dart';
import '../ui/eurekoin/eurekoin.dart';
import '../ui/about_us/about_us.dart';
import '../ui/sponsors/sponsors.dart';
import '../util/navigator_transitions/slide_left_transitions.dart';
import '../ui/contact_us/contact_us.dart';
import '../ui/contributors/contributors.dart';

class NavigationDrawer extends StatefulWidget {
  NavigationDrawer({Key key, this.currentDisplayedPage}): super(key: key);
  final int currentDisplayedPage;

  @override
  _NavigationDrawerState createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  int presestPageNumber;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    presestPageNumber = widget.currentDisplayedPage;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
            child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              padding: EdgeInsets.all(0.0),
              child: Image.asset("images/events.png", fit: BoxFit.fill),
            ),
            Container(
              color: (presestPageNumber == 0)
                  ? Color.fromRGBO(225, 225, 225, 40.0)
                  : Color.fromRGBO(54, 59, 94, 40.0),
              child: ListTile(
                  leading: Icon(Icons.home, color:Color(0xFF353662)),
                  title: Text("Home",
                      style: TextStyle(
                          color: (presestPageNumber == 0)
                              ? Colors.black
                              : Colors.white)),
                  selected: (presestPageNumber == 0) ? true : false,
                  onTap: () {
                    setState(() {
                      presestPageNumber = 0;
                    });
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  }),
            ),
            Container(
                color: (presestPageNumber == 1)
                    ? Color.fromRGBO(225, 225, 225, 40.0)
                    : Color.fromRGBO(54, 59, 94, 40.0),
                child: ListTile(
                    leading: Icon(Icons.monetization_on, color:Color(0xFF353662)),
                    title: Text("Eurekoin Wallet",
                        style: TextStyle(
                            color: (presestPageNumber == 1)
                                ? Colors.black
                                : Colors.white)),
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
                            .push(SlideLeftRoute(widget: EurekoinHomePage()));
                      }
                    })),
            Container(
                color: (presestPageNumber == 4)
                    ? Color.fromRGBO(225, 225, 225, 40.0)
                    : Color.fromRGBO(54, 59, 94, 40.0),
                child: ListTile(
                  leading: Icon(Icons.access_time, color:Color(0xFF353662)),
                  title: Text("Schedule",
                      style: TextStyle(
                          color: (presestPageNumber == 4)
                              ? Colors.black
                              : Colors.white)),
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
                color: (presestPageNumber == 5)
                    ? Color.fromRGBO(225, 225, 225, 40.0)
                    : Color.fromRGBO(54, 59, 94, 40.0),
                child: ListTile(
                    leading: Icon(Icons.local_activity, color:Color(0xFF353662)),
                    title: Text("Activities",
                        style: TextStyle(
                            color: (presestPageNumber == 5)
                                ? Colors.black
                                : Colors.white)),
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
                color: (presestPageNumber==12)?Color.fromRGBO(225, 225, 225, 40.0):Color.fromRGBO(54, 59, 94, 40.0),
                child: ListTile(
                  leading: Icon(Icons.videogame_asset, color:Color(0xFF353662)),
                  title: Text("Bored?", style: TextStyle(
                      color: (presestPageNumber==12)?Colors.black:Colors.white)),
                  selected: (presestPageNumber == 12) ? true : false,
                  onTap: (() {
                    if (presestPageNumber == 12)
                      Navigator.pop(context);
                    else {
                      setState(() {
                        presestPageNumber = 12;
                      });
                      Navigator.popUntil(context, ModalRoute.withName('/'));
                      Navigator.of(context)
                          .push(SlideLeftRoute(widget: Game()));
                    }
                  }),
                )),
            Container(
              padding: EdgeInsets.fromLTRB(20.0, 5.0, 5.0, 5.0),
              color: Color.fromRGBO(54, 59, 94, 40.0),
              child: Text("Utilities", style: TextStyle(color: Colors.white)),
            ),
            Container(
                color: (presestPageNumber == 2)
                    ? Color.fromRGBO(225, 225, 225, 40.0)
                    : Color.fromRGBO(54, 59, 94, 40.0),
                child: ListTile(
                    leading: Icon(Icons.score, color:Color(0xFF353662)),
                    title: Text("Scoreboard",
                        style: TextStyle(
                            color: (presestPageNumber == 2)
                                ? Colors.black
                                : Colors.white)),
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
                            .push(SlideLeftRoute(widget: Scoreboard()));
                      }
                    })),
            Container(
                color: (presestPageNumber == 3)
                    ? Color.fromRGBO(225, 225, 225, 40.0)
                    : Color.fromRGBO(54, 59, 94, 40.0),
                child: ListTile(
                  leading: Icon(Icons.youtube_searched_for, color:Color(0xFF353662)),
                  title: Text("Tags",
                      style: TextStyle(
                          color: (presestPageNumber == 3)
                              ? Colors.black
                              : Colors.white)),
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
                color: (presestPageNumber == 6)
                    ? Color.fromRGBO(225, 225, 225, 40.0)
                    : Color.fromRGBO(54, 59, 94, 40.0),
                child: ListTile(
                  leading: Icon(Icons.my_location, color:Color(0xFF353662)),
                  title: Text("Maps",
                      style: TextStyle(
                          color: (presestPageNumber == 6)
                              ? Colors.black
                              : Colors.white)),
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
                color: (presestPageNumber == 8)
                    ? Color.fromRGBO(225, 225, 225, 40.0)
                    : Color.fromRGBO(54, 59, 94, 40.0),
                child: ListTile(
                  leading: Icon(Icons.account_circle, color:Color(0xFF353662)),
                  title: Text("Account",
                      style: TextStyle(
                          color: (presestPageNumber == 8)
                              ? Colors.black
                              : Colors.white)),
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
              padding: EdgeInsets.fromLTRB(20.0, 5.0, 5.0, 5.0),
              color: Color.fromRGBO(54, 59, 94, 40.0),
              child: Text("About us", style: TextStyle(color: Colors.white)),
            ),
            Container(
                color: (presestPageNumber == 7)
                    ? Color.fromRGBO(225, 225, 225, 40.0)
                    : Color.fromRGBO(54, 59, 94, 40.0),
                child: ListTile(
                  leading: Icon(Icons.accessibility, color:Color(0xFF353662)),
                  title: Text("About Us",
                      style: TextStyle(
                          color: (presestPageNumber == 7)
                              ? Colors.black
                              : Colors.white)),
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
                color: (presestPageNumber == 9)
                    ? Color.fromRGBO(225, 225, 225, 40.0)
                    : Color.fromRGBO(54, 59, 94, 40.0),
                child: ListTile(
                  leading: Icon(Icons.credit_card, color:Color(0xFF353662)),
                  title: Text("Sponsors",
                      style: TextStyle(
                          color: (presestPageNumber == 9)
                              ? Colors.black
                              : Colors.white)),
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
            Container(
              color: (presestPageNumber == 10)
                  ? Color.fromRGBO(225, 225, 225, 40.0)
                  : Color.fromRGBO(54, 59, 94, 40.0),
              child: ListTile(
                  leading: Icon(Icons.call, color:Color(0xFF353662)),
                  title: Text("Contact Us",
                      style: TextStyle(
                          color: (presestPageNumber == 10)
                              ? Colors.black
                              : Colors.white)),
                  selected: (presestPageNumber == 10) ? true : false,
                  onTap: () {
                    if (presestPageNumber == 10)
                      Navigator.pop(context);
                    else {
                      setState(() {
                        presestPageNumber = 10;
                      });
                      Navigator.popUntil(context, ModalRoute.withName('/'));
                      Navigator.of(context)
                          .push(SlideLeftRoute(widget: ContactUs()));
                    }
                  }),
            ),
            Container(
              color: (presestPageNumber == 11)
                  ? Color.fromRGBO(225, 225, 225, 40.0)
                  : Color.fromRGBO(54, 59, 94, 40.0),
              child: ListTile(
                  leading: Icon(Icons.accessibility, color:Color(0xFF353662)),
                  title: Text("Contributors",
                      style: TextStyle(
                          color: (presestPageNumber == 11)
                              ? Colors.black
                              : Colors.white)),
                  selected: (presestPageNumber == 11) ? true : false,
                  onTap: () {
                    if (presestPageNumber == 11)
                      Navigator.pop(context);
                    else {
                      setState(() {
                        presestPageNumber = 11;
                      });
                      Navigator.popUntil(context, ModalRoute.withName('/'));
                      Navigator.of(context)
                          .push(SlideLeftRoute(widget: Contributors()));
                    }
                  }),
            )
        ]));
  }
}
