import 'package:aavishkarapp/ui/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import './ui/activities/main.dart';
import './ui/search_by_tags/tags.dart';
import './ui/maps/map.dart';
import './ui/account/login.dart';
import './ui/scoreboard/scoreboard.dart';
import './ui/schedule/schedule.dart';
import './ui/eurocoin/eurocoin.dart';
import './ui/about_us/about_us.dart';

//import './ui/account/account.dart';
import './ui/sponsors/sponsors.dart';

void main()
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
//                    primaryColor: Colors.purple
//                ),
//                child: child,
//              );
//            }
//            return child;
//          },
        theme: new ThemeData(
//          backgroundColor: Colors.black,
//          canvasColor: Color(0xFF353662),
          primaryColor: Color(0xFF353662),
//          backgroundColor:Color(0xFF353662) ,
//          canvasColor: Color(0xFF353662),
//          cardColor: Color(0xFF353662),
//          highlightColor: Color(0xFF353662),
//          brightness: Brightness.values[0],
//iconTheme: IconThemeData(
//  color: Colors.grey
//)
//          scaffoldBackgroundColor:Color(0xFF353662),
//          highlightColor: Colors.purple,
//          scaffoldBackg/roundColor: Colors/.purple
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
          "/ui/scoreboard":(BuildContext context)=> ScoreBoard(),
          "/ui/eurocoin":(BuildContext context)=> EurocoinHomePage(),
          "/ui/aboutus":(BuildContext context)=> AboutUsPage(),
//          "/ui/accouont/account":(BuildContext context)=> Account(),
          "/ui/sponsors/sponsors":(BuildContext context)=>Sponsors(),
          },
      )
  );
}