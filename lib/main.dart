import 'package:aavishkarapp/ui/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import './ui/activities/main.dart';
import './ui/search_by_tags/tags.dart';
import './ui/maps/map.dart';
import './ui/account/login.dart';
import './ui/scoreboard/scoreboard.dart';
import './ui/schedule/schedule.dart';
import './ui/eurekoin/eurekoin.dart';
import './ui/contact_us/contact_us.dart';
import './ui/sponsors/sponsors.dart';
import './ui/contributors/contributors.dart';
import './ui/about_us/about_us.dart';
import './ui/game/lib/main.dart';

void main() async
{
  runApp(
      MaterialApp(
        title: "Aavishkar App",
        debugShowMaterialGrid: false,
        debugShowCheckedModeBanner: false,
//          theme: new ThemeData(),
//          builder: (context, child) {
//            final defaultTheme = Theme.of(context);
//            if (defaultTheme.platform == TargetPlatform.iOS) {
//              return new Theme(
//                data: defaultTheme.copyWith(
//                    primaryColor: Color(0xFF8266D4)
//                ),
//                child: child,
//              );
//            }
//            return child;
//          },
        theme: new ThemeData(
          primaryColor: Color(0xFF353662),
          splashColor: Colors.transparent,
          accentColor: Color(0xFF353662)
        ),
        home: Dashboard(),
        initialRoute: "/",
        routes: <String, WidgetBuilder>{
          "/ui/dashboard": (BuildContext context) => Dashboard(),
          "/ui/tags": (BuildContext context) => SearchByTags(),
          "/ui/schedule": (BuildContext context) => Schedule(),
          "/ui/activity": (BuildContext context) => ActivitiesHomePage(),
          "/ui/maps/map":(BuildContext context)=>MapPage(),
          "/ui/account/login":(BuildContext context)=>LogInPage(),
          "/ui/scoreboard":(BuildContext context)=> Scoreboard(),
          "/ui/eurekoin":(BuildContext context)=> EurekoinHomePage(),
          "/ui/sponsors/sponsors":(BuildContext context)=>Sponsors(),
          "/ui/contact_us/contact_us":(BuildContext context)=>ContactUs(),
          "/ui/contributors/contributors":(BuildContext context)=> Contributors(),
          "/ui/about_us/about_us":(BuildContext context)=> AboutUsPage(),
          "/ui/game":(BuildContext context)=> Game()
          },
      )
  );
}