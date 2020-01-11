import 'package:aavishkarapp/ui/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import './ui/search_by_tags/tags.dart';
//import './ui/maps/map.dart';
import './ui/account/login.dart';
import './ui/scoreboard/scoreboard.dart';
import './ui/schedule/schedule.dart';
import './ui/eurekoin/eurekoin.dart';
import './ui/contact_us/contact_us.dart';
import './ui/sponsors/sponsors.dart';
import './ui/contributors/contributors.dart';
import './ui/about_us/about_us.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import './interficio/interficio.dart';

void main() => runApp(new Aavishkar_App());

class Aavishkar_App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    // Wrapped within Dynamic Theme to change the theme
    // By toggling the change theme

    return DynamicTheme(
       // defaultBrightness: Brightness.dark,
        data: (brightness) => ThemeData(
            primaryColor: Color(0xFF505194),
            brightness: brightness,
//          splashColor: Colors.transparent,
//          accentColor: Color(0xFF505194),
//          brightness: Brightness.dark,

        ),
        themedWidgetBuilder: (context, theme) {
          return MaterialApp(
            title: "Aavishkar App",
            debugShowMaterialGrid: false,
            debugShowCheckedModeBanner: false,
            theme: theme,
            home: new Dashboard(),
            initialRoute: "/ui/dashboard",
            routes: <String, WidgetBuilder>{
              "/ui/dashboard": (BuildContext context) => Dashboard(),
              "/ui/tags": (BuildContext context) => SearchByTags(),
              "/ui/schedule": (BuildContext context) => Schedule(),
//              "/ui/maps/map": (BuildContext context) => MapPage(),
              "/ui/account/login": (BuildContext context) => LogInPage(),
              "/ui/scoreboard": (BuildContext context) => Scoreboard(),
              "/ui/eurekoin": (BuildContext context) => EurekoinHomePage(),
              "/ui/sponsors/sponsors": (BuildContext context) => Sponsors(),
              "/ui/contact_us/contact_us": (BuildContext context) =>
                  ContactUs(),
              "/ui/contributors/contributors": (BuildContext context) =>
                  Contributors(),
              "/ui/about_us/about_us": (BuildContext context) => AboutUsPage(),
              "/interficio/interficio.dart": (BuildContext context) => MyApp(),
            },
          );
        });
  }
}
