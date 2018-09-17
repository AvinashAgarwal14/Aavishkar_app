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
            }
          ),
          ListTile(
            title: Text("Maps"),
            onTap: ((){
              Navigator.pop(context);
              Navigator.pushNamed(context, "/ui/maps/map");
            }),
          ),
          ListTile(
            title: Text("Account"),
            onTap:((){
              Navigator.pop(context);
              Navigator.pushNamed(context, "/ui/account/login");
            }),
          )
        ],
      ),
    );
  }
}
