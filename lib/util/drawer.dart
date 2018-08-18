import 'package:flutter/material.dart';

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          ListTile(
            title: Text("Home")
          ),
          ListTile(
              title: Text("Events")
          )
        ],
      ),
    );
  }
}
