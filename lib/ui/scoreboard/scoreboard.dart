//import 'dart:async';
//import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../util/drawer.dart';

class ScoreBoard extends StatefulWidget {
  @override
  _ScoreBoardState createState() => _ScoreBoardState();
}

class _ScoreBoardState extends State<ScoreBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawer(),


    );
  }

//  Future getScoreData() async{
//    String apiUrl="http://www.mocky.io/v2/5ba7b4153200004e00e2e9c0";
//    http.Response response= await http.get(apiUrl);
//
//  //  return json.decode(response.body);
//  }

}
