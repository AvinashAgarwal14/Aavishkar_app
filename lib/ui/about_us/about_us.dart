import 'package:flutter/material.dart';
import '../../util/drawer.dart';

class AboutUsPage extends StatefulWidget {
  @override
  _AboutUsPageState createState() => new _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {

  @override
    void initState() {
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: NavigationDrawer(currentDisplayedPage: 7),
      appBar: AppBar(
        title: Text("About Aavishkar 3.0"),
      ),
      body: Container(
      ),
    );
  }
}
