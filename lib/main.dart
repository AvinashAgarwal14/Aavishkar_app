import 'package:aavishkarapp/ui/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import './ui/activities/main.dart';
import './ui/search_by_tags/tags.dart';
import './ui/maps/map.dart';
import './ui/account/login.dart';
import './ui/scoreboard/scoreboard.dart';
import './ui/schedule/schedule.dart';
import './ui/eurocoin/eurocoin.dart';


void main()
{
  runApp(
      MaterialApp(
        title: "Aavishkar App",
        debugShowCheckedModeBanner: false,
        home: Dashboard(),
        initialRoute: "/",
        routes: <String, WidgetBuilder>{
          "/ui/dashboard": (BuildContext context) => Dashboard(),
          "/ui/tags": (BuildContext context) => SearchByTags(),
          "/ui/schedule": (BuildContext context) => Schedule(),
          "/ui/activity": (BuildContext context) => AnimationDemoHome(),
          "/ui/maps/map":(BuildContext context)=>MapPage(),
          "/ui/account/login":(BuildContext context)=>LogInPage(),
          "/ui/scoreboard":(BuildContext context)=> ScoreBoard(),
          "/ui/eurocoin":(BuildContext context)=> EurocoinHomePage()
          },
      )
  );
}