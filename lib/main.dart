import 'package:flutter/material.dart';
import './ui/activities/main.dart';
import './ui/search_by_tags/tags.dart';
import 'package:aavishkarapp/ui/dashboard/dashboard.dart';

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
          "/ui/activity": (BuildContext context) => AnimationDemoHome(),
          },
      )
  );
}