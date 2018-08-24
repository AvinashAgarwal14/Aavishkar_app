import 'package:flutter/material.dart';

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          ListTile(
            title: Text("Home"),
            onTap: () {
              Navigator.of(context).pushNamed("/ui/dashboard");
            }
          ),
          ListTile(
            title: Text("Tags"),
            onTap: () {
              Navigator.of(context).pushNamed("/ui/tags");
            },
          ),
          ListTile(
              title: Text("Activities"),
            onTap: () {
              Navigator.of(context).pushNamed("/ui/activity");
            },
          )
        ],
      ),
    );
  }
}
