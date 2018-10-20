import 'package:flutter/material.dart';
import '../../util/drawer.dart';
import './day1.dart';
import './day2.dart';
import './day3.dart';
import './day4.dart';

class Schedule extends StatefulWidget {
  const Schedule({Key key}) : super(key: key);
  @override
  _ScheduleState createState() => _ScheduleState();
}

enum AppBarBehavior { normal, pinned, floating, snapping }

class _ScheduleState extends State<Schedule> {
  final List<String> week = ["THUR", "FRI", "SAT", "SUN"];
  final List arrayDay = ["1", "2", "3", "4"];
  var presentKey;
  final List selectDaySchedule = [
    DayOneSchedule(),
    DayTwoSchedule(),
    DayThreeSchedule(),
    DayFourSchedule()
  ];

  GlobalKey<ScaffoldState> _scaffoldKeyForSchedule =
      new GlobalKey<ScaffoldState>();
  final double _appBarHeight = 256.0;
  AppBarBehavior _appBarBehavior = AppBarBehavior.pinned;

  final EdgeInsets margin;
  _ScheduleState({this.margin});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      presentKey = 0;
    });
  }


  @override

  Widget build(BuildContext context) {
    ThemeData themeData=Theme.of(context);
    return new Theme(
        data: themeData,
        child: new Scaffold(
            key: _scaffoldKeyForSchedule,
            drawer: NavigationDrawer(currentDisplayedPage: 4),
            body: new CustomScrollView(slivers: <Widget>[
              new SliverAppBar(
                expandedHeight: _appBarHeight,
                pinned: _appBarBehavior == AppBarBehavior.pinned,
                floating: _appBarBehavior == AppBarBehavior.floating ||
                    _appBarBehavior == AppBarBehavior.snapping,
                snap: _appBarBehavior == AppBarBehavior.snapping,
                flexibleSpace: new FlexibleSpaceBar(
                  title: Text('Schedule'),
                  background: new Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      new Image.asset(
                        "images/schedule.jpg",
                        fit: BoxFit.cover,
                        height: _appBarHeight,
                      ),
                      // This gradient ensures that the toolbar icons are distinct
                      // against the background image.
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(0.0, 0.6),
                            end: Alignment(0.0, -0.4),
                            colors: <Color>[
                              Color(0x60000000),
                              Color(0x00000000)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              new SliverList(
                delegate: new SliverChildListDelegate(<Widget>[
                  new Container(
                      margin: margin,
                      alignment: Alignment.center,
                      padding: new EdgeInsets.only(left: 30.0, top: 20.0),
                      height: 90.0,
                      decoration: new BoxDecoration(
                        //color: Colors.white,
                        border: new Border(
                          bottom: new BorderSide(
                              width: 0.5,
                              color: const Color.fromRGBO(204, 204, 204, 1.0)
                          ),
                        ),
                      ),
                      child: new ListView.builder(
                          itemCount: week.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return new GestureDetector(
                                onTap: () {
                                  setState(() {
                                    print(presentKey);
                                    presentKey = index;
                                  });
                                },
                                child: SizedBox(
                                    width: 80.0,
                                    child: Column(children: <Widget>[
                                      new Text(
                                        week[index],
                                        style: new TextStyle(
                                            color: const Color.fromRGBO(
                                                204, 204, 204, 1.0),
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      new Padding(
                                        padding: new EdgeInsets.only(
                                            top: 10.0, bottom: 5.0),
                                        child: new Container(
                                              width: 40.0,
                                              height: 40.0,
                                              alignment: Alignment.center,
                                              decoration: new BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: (presentKey == index)
                                                      ? const Color.fromRGBO(
                                                          204, 204, 204, 0.3)
                                                      : Colors.transparent),
                                              child: new Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  new Text(
                                                    arrayDay[index].toString(),
                                                    style: new TextStyle(
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  (presentKey == index)
                                                      ? new Container(
                                                          padding:
                                                              new EdgeInsets
                                                                      .only(
                                                                  top: 3.0),
                                                          width: 3.0,
                                                          height: 3.0,
                                                          decoration: new BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: Color(0xFF505194)),
                                                        )
                                                      : new Container()
                                                ],
                                              )),
                                      )
                                    ])));
                          })),
                  Container(
                     // color: Colors.white,
                      child: selectDaySchedule[presentKey])
                ]),
              )
            ])));
  }
}
