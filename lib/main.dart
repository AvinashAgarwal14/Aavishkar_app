import 'package:flutter/material.dart';
import './ui/events/onsite_events.dart';
import './ui/dashboard.dart';

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
          "/ui/events/onsite": (BuildContext context) => OnSiteEvents(),
          },
      )
  );
}