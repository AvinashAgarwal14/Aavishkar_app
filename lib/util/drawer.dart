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
import '../util/navigator_transitions/slide_left_transitions.dart';


class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          ListTile(
            title: Text("Home"),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(SlideLeftRoute(widget: Dashboard()));
            }
          ),
          ListTile(
              title: Text("Eurocoin"),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(SlideLeftRoute(widget: EurocoinHomePage()));
              }
          ),
          ListTile(
              title: Text("Scoreboard"),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(SlideLeftRoute(widget: ScoreBoard()));
              }
          ),
          ListTile(
            title: Text("Tags"),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(SlideLeftRoute(widget: SearchByTags()));
            },
          ),
          ListTile(
            title: Text("Schedule"),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(SlideLeftRoute(widget: Schedule()));
            },
          ),
          ListTile(
              title: Text("Activities"),
            onTap: () {
              Navigator.pop(context);
//              Navigator.popUntil(context, ModalRoute.withName('/'));
              Navigator.of(context).push(SlideLeftRoute(widget: AnimationDemoHome()));
            }
          ),
          ListTile(
            title: Text("Maps"),
            onTap: ((){
              Navigator.pop(context);
//              Navigator.pop(context);
              Navigator.of(context).push(SlideLeftRoute(widget: MapPage()));
            }),
          ),
          ListTile(
            title: Text("About Us"),
            onTap:((){
              Navigator.pop(context);
//              Navigator.pop(context);
              Navigator.of(context).push(SlideLeftRoute(widget: AboutUsPage()));
            }),
          ),
          ListTile(
            title: Text("Account"),
            onTap:((){
              Navigator.pop(context);
//              Navigator.pop(context);
              Navigator.of(context).push(SlideLeftRoute(widget: LogInPage()));
            }),
          )
        ],
      ),
    );
  }
}
