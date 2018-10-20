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
import 'package:dynamic_theme/dynamic_theme.dart';

class NavigationDrawer extends StatefulWidget {
  NavigationDrawer({Key key, this.currentDisplayedPage}) : super(key: key);
  final int currentDisplayedPage;

  @override
  _NavigationDrawerState createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  int presestPageNumber;
  bool darkThemeEnabled;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    presestPageNumber = widget.currentDisplayedPage;
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context).brightness == Brightness.light
        ? darkThemeEnabled = false
        : darkThemeEnabled = true;
    return Opacity(
      opacity: 0.75,
      child: Drawer(
        child: Container(
          color: Color.fromRGBO(0, 0, 0, 1.0),
          child: ListTileTheme(
            iconColor: Color.fromRGBO(255,255,255, 1.0),
            textColor: Color.fromRGBO(255,255,255, 1.0),
            selectedColor: Theme.of(context).primaryColor.withOpacity(1.0),
            child: ListView(padding: EdgeInsets.zero, children: <Widget>[
              DrawerHeader(
                padding: EdgeInsets.all(0.0),
                child: Image.asset("images/gifs/pacman.gif", fit: BoxFit.cover),
              ),
              ListTile(
                enabled: true,
                  trailing: Switch(
                    activeColor: Color(0xFF505194),
                      inactiveTrackColor: Colors.grey,
                      value: darkThemeEnabled,
                      onChanged: (bool value) {
                        setState(() {
                          darkThemeEnabled = value;
                        });
                        Theme.of(context).brightness == Brightness.dark
                            ? DynamicTheme.of(context)
                                .setThemeData(new ThemeData(
                                primaryColor: Color(0xFF505194),
                              ))
                            : DynamicTheme.of(context)
                                .setThemeData(new ThemeData(
//                            accentTextTheme: TextTheme(
//                                title: TextStyle(color: Colors.white)),
                          primaryColor: Color(0xFF505194),
                                splashColor: Colors.transparent,
                                accentColor: Color(0xFF505194),
                                brightness: Brightness.dark,
                              ));
                        print(Theme.of(context).brightness);
                      }),
                  leading: Icon(
                    Icons.home,
                  ),
                  title: Text("Home",
                  ),
                  selected: (presestPageNumber == 0) ? true : false,
                  onTap: () {
                      presestPageNumber = 0;
                    Navigator.popUntil(context, (ModalRoute.withName('/ui/dashboard')));
                  }),
              ListTile(
                  leading: Icon(Icons.monetization_on, ),
                  title: Text("Eurekoin Wallet",),
                  selected: (presestPageNumber == 1) ? true : false,
                  onTap: () {
                    if (presestPageNumber == 1)
                      Navigator.pop(context);
                    else {
                        presestPageNumber = 1;
                      Navigator.popUntil(context, ModalRoute.withName('/ui/dashboard'));
                      Navigator.of(context)
                          .push(SlideLeftRoute(widget: EurekoinHomePage()));
                    }
                  }),
              ListTile(
                leading: Icon(
                  Icons.access_time,
                ),
                title: Text(
                  "Schedule",
                ),
                selected: (presestPageNumber == 4) ? true : false,
                onTap: () {
                  if (presestPageNumber == 4)
                    Navigator.pop(context);
                  else {
                    presestPageNumber = 4;
                    Navigator.popUntil(context, ModalRoute.withName('/ui/dashboard'));
                    Navigator.of(context)
                        .push(SlideLeftRoute(widget: Schedule()));
                  }
                },
              ),
              ListTile(
                  leading: Icon(Icons.local_activity,),
                  title: Text("Activities",),
                  selected: (presestPageNumber == 5) ? true : false,
                  onTap: () {
                    if (presestPageNumber == 5)
                      Navigator.pop(context);
                    else {
                        presestPageNumber = 5;
                      Navigator.popUntil(context, ModalRoute.withName('/ui/dashboard'));
                      Navigator.of(context).push(
                          SlideLeftRoute(widget: ActivitiesHomePage()));
                    }
                  }),
              ListTile(
                leading: Icon(Icons.videogame_asset,),
                title:
                    Text("Bored ?", ),
                selected: (presestPageNumber == 12) ? true : false,
                onTap: (() {
                  if (presestPageNumber == 12)
                    Navigator.pop(context);
                  else {
                      presestPageNumber = 12;
                    Navigator.popUntil(context, ModalRoute.withName('/ui/dashboard'));
                    Navigator.of(context)
                        .push(SlideLeftRoute(widget: Game()));
                  }
                }),
              ),
              Divider(),
              ListTile(
                  title: Text("Utilities",
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold))),
              Divider(),
              ListTile(
                  leading: Icon(Icons.score,),
                  title: Text("Scoreboard",),
                  selected: (presestPageNumber == 2) ? true : false,
                  onTap: () {
                    if (presestPageNumber == 2)
                      Navigator.pop(context);
                    else {
                        presestPageNumber = 2;
                      Navigator.popUntil(context, ModalRoute.withName('/ui/dashboard'));
                      Navigator.of(context)
                          .push(SlideLeftRoute(widget: Scoreboard()));
                    }
                  }),
              ListTile(
                leading:
                    Icon(Icons.youtube_searched_for, ),
                title: Text("Tags",),
                selected: (presestPageNumber == 3) ? true : false,
                onTap: () {
                  if (presestPageNumber == 3)
                    Navigator.pop(context);
                  else {
                      presestPageNumber = 3;
                    Navigator.popUntil(context, ModalRoute.withName('/ui/dashboard'));
                    Navigator.of(context)
                        .push(SlideLeftRoute(widget: SearchByTags()));
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.my_location,),
                title: Text("Maps",),
                selected: (presestPageNumber == 6) ? true : false,
                onTap: (() {
                  if (presestPageNumber == 6)
                    Navigator.pop(context);
                  else {
                      presestPageNumber = 6;
                    Navigator.popUntil(context, ModalRoute.withName('/ui/dashboard'));
                    Navigator.of(context)
                        .push(SlideLeftRoute(widget: MapPage()));
                  }
                }),
              ),
              ListTile(
                leading: Icon(Icons.account_circle, ),
                title:
                    Text("Account", ),
                selected: (presestPageNumber == 8) ? true : false,
                onTap: (() {
                  if (presestPageNumber == 8)
                    Navigator.pop(context);
                  else {
                      presestPageNumber = 8;
                    Navigator.popUntil(context, ModalRoute.withName('/ui/dashboard'));
                    Navigator.of(context)
                        .push(SlideLeftRoute(widget: LogInPage()));
                  }
                }),
              ),
              ListTile(
                  title: Text("About Us",
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold))
              ),
              ListTile(
                leading: Icon(Icons.credit_card),
                title:
                    Text("Sponsors", ),
                selected: (presestPageNumber == 9) ? true : false,
                onTap: (() {
                  if (presestPageNumber == 9)
                    Navigator.pop(context);
                  else {
                      presestPageNumber = 9;
                    Navigator.popUntil(context, ModalRoute.withName('/ui/dashboard'));
                    Navigator.of(context)
                        .push(SlideLeftRoute(widget: Sponsors()));
                  }
                }),
              ),
              ListTile(
                  leading: Icon(Icons.call,),
                  title: Text("Contact Us",),
                  selected: (presestPageNumber == 10) ? true : false,
                  onTap: () {
                    if (presestPageNumber == 10)
                      Navigator.pop(context);
                    else {
                        presestPageNumber = 10;
                      Navigator.popUntil(context, ModalRoute.withName('/ui/dashboard'));
                      Navigator.of(context)
                          .push(SlideLeftRoute(widget: ContactUs()));
                    }
                  }),
              ListTile(
                  leading: Icon(Icons.accessibility,),
                  title: Text("Contributors",),
                  selected: (presestPageNumber == 11) ? true : false,
                  onTap: () {
                    if (presestPageNumber == 11)
                      Navigator.pop(context);
                    else {
                        presestPageNumber = 11;
                        Navigator.popUntil(context, ModalRoute.withName('/ui/dashboard'));
                        Navigator.of(context).push(SlideLeftRoute(widget: Contributors()));
                      }
                  }),
              ListTile(
                leading: Icon(Icons.info),
                title:
                Text("About Aavishkar"),
                selected: (presestPageNumber == 7) ? true : false,
                onTap: (() {
                  if (presestPageNumber == 7)
                    Navigator.pop(context);
                  else {
                    presestPageNumber = 7;
                    Navigator.popUntil(context, ModalRoute.withName('/ui/dashboard'));
                    Navigator.of(context)
                        .push(SlideLeftRoute(widget: AboutUsPage()));
                  }
                }),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
