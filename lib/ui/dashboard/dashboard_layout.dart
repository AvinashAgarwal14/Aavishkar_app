import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../activities/events/event_details.dart';
import '../../model/event.dart';
import 'package:firebase_database/firebase_database.dart';

List<T> map<T>(List list, Function handler) {
  List<T> result = new List();
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }
  return result;
}

class DashBoardLayout extends StatefulWidget {
  @override
  _DashBoardLayoutState createState() => _DashBoardLayoutState();
}

class _DashBoardLayoutState extends State<DashBoardLayout>  {

  CarouselSlider instance;
  int j = 0;

  List carouselImageList;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;
  Map<String, List<EventItem>> eventsByCategories;


  @ override
  void initState() {
    // TODO: implement initState
    super.initState();

    eventsByCategories = {
      'All' : new List(),
      'On-site': new List(),
      'Online': new List(),
      'Workshops': new List(),
      'Games': new List(),
      'Workshops and Special Attractions': new List(),
      'Ignitia': new List()
    };

    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(150000000);
    databaseReference = database.reference().child("Events");
    databaseReference.onChildAdded.listen(_onEntryAdded);
    databaseReference.onChildChanged.listen(_onEntryChanged);
  }

  nextSlider() {
    instance.nextPage(
        duration: new Duration(milliseconds: 300), curve: Curves.linear);
  }

  prevSlider() {
    instance.previousPage(
        duration: new Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    if (eventsByCategories["Online"].length != 0 &&
        eventsByCategories["On-site"].length != 0 &&
        eventsByCategories["Workshops"].length != 0 &&
        eventsByCategories["Games"].length != 0 &&
        eventsByCategories["Workshops and Special Attractions"].length != 0 &&
        eventsByCategories["Ignitia"].length != 0&&
        eventsByCategories["All"].length>=35) {
      carouselImageList = List(eventsByCategories["All"].length);
      return ListView(
        cacheExtent: MediaQuery.of(context).size.height*2,
//            shrinkWrap: true,
        children: <Widget>[
          //TODO Trending
          Container(
            color:Theme.of(context).brightness==Brightness.light ?
             Color.fromRGBO(232,232,232, 1.0):
            Color.fromRGBO(80,80,80, 1.0),
            padding: new EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
            child: Column(
              children: <Widget>[
                Padding(
                    padding: new EdgeInsets.symmetric(vertical: 0.0),
                    child: instance
                    ),
                    new CarouselSlider(
                      //TODO add the upcoming events as per the date
                      items: map<Widget>(carouselImageList, (index, i) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EventDetails(
                                      item: eventsByCategories["All"]
                                          [index])),
                            );
                          },
                          child: new Container(
                              margin: new EdgeInsets.all(5.0),
                              child: new ClipRRect(
                                  borderRadius: new BorderRadius.all(
                                      new Radius.circular(5.0)),
                                  child: new Stack(
                                    children: <Widget>[
                                      CachedNetworkImage(
                                          placeholder: Image.asset("images/imageplaceholder.png"),
                                          imageUrl: eventsByCategories["All"]
                                                  [index]
                                              .imageUrl,
                                          fit: BoxFit.cover,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              10.0),
                                      new Positioned(
                                          bottom: 0.0,
                                          left: 0.0,
                                          right: 0.0,
                                          child: new Container(
                                              decoration: new BoxDecoration(
                                                  gradient: new LinearGradient(
                                                colors: [
                                                  Color.fromARGB(200, 0, 0, 0),
                                                  Color.fromARGB(0, 0, 0, 0)
                                                ],
                                                begin: Alignment.bottomCenter,
                                                end: Alignment.topCenter,
                                              )),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10.0,
                                                  horizontal: 20.0),
                                              child: new Text(
                                                "${eventsByCategories["All"]
                                                [index].title}",
                                                style: new TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ))),
                                    ],
                                  ))),
                        );
                      }).toList(),
                      autoPlay: true,
                      viewportFraction: 0.9,
                      aspectRatio: 2.0,
                      interval: Duration(milliseconds: 3000),
                      autoPlayDuration: Duration(milliseconds: 2000),
                    ),
              ],
            ),
          ),
          //TODO Online Events
          Container(
            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
              child: Column(
            children: <Widget>[
              Text("Online Events",style: TextStyle(fontSize:18.0)),
              Container(
                padding: EdgeInsets.only(top: 5.0),
                height: 150.0,
                // width: MediaQuery.of(context).size.width-10.0,
                child: ListView.builder(
                  cacheExtent: 1350.0,
                    itemCount: eventsByCategories["Online"].length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EventDetails(
                                    item: eventsByCategories["Online"][index])),
                          );
                        },
                        child: Container(
                            height: 100.0,
                            width: 150.0,
                            margin: new EdgeInsets.all(2.0),
                            child: new ClipRRect(
                                borderRadius: new BorderRadius.all(
                                new Radius.circular(5.0)),
                                child:CachedNetworkImage(
                                    placeholder: Image.asset("images/imageplaceholder.png"),
                                    imageUrl: eventsByCategories["Online"][index].imageUrl,
                                    fit: BoxFit.cover
                                ),
                              )),
                      );
                    }),
              ),
            ],
          )),
          //TODO Workshop And Games
          Container(
            color:Theme.of(context).brightness==Brightness.light ?
          Color.fromRGBO(232,232,232, 1.0):
          Color.fromRGBO(80,80,80, 1.0),

            //color: Colors.grey.shade200,
            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 15.0),
            child: Column(
              children: <Widget>[
                Text("Workshops and Special Attractions ",
                      style: TextStyle(fontSize: 18.0),
                ),
                Container(
                  padding: EdgeInsets.only(top: 5.0),
                  height: 200.0,
                  width: MediaQuery.of(context).size.width,
                  child: Swiper(
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EventDetails(
                                    item: eventsByCategories["Workshops and Special Attractions"]
                                        [index])),
                          );
                        },
                        child: new ClipRRect(
                        borderRadius: new BorderRadius.all(
                      new Radius.circular(5.0)),
                      child: CachedNetworkImage(
                            placeholder: Image.asset("images/imageplaceholder.png"),
                            imageUrl: eventsByCategories["Workshops and Special Attractions"][index].imageUrl,
                            fit: BoxFit.cover)
                      ));
                    },
                    itemCount: eventsByCategories["Workshops and Special Attractions"].length,
                    itemWidth: 300.0,
                    layout: SwiperLayout.STACK,
                  ),
                )
              ],
            ),
          ),
          //TODO On-Site Events
          Container(
            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 15.0),
            child: Column(
              children: <Widget>[
                Text("On-site Events ",
                      style: TextStyle(fontSize: 18.0),
                ),
                Container(
                  padding: EdgeInsets.only(top: 5.0),
                  height: 150.0,
                  //width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    cacheExtent: 4000.0,
                      itemCount: eventsByCategories["On-site"].length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EventDetails(
                                      item: eventsByCategories["On-site"]
                                          [index])),
                            );
                          },
                          child: Container(
                              height: 100.0,
                              width: 150.0,
                            margin: new EdgeInsets.all(2.0),
                            child: new ClipRRect(
                                borderRadius: new BorderRadius.all(
                                    new Radius.circular(5.0)),
                                child: CachedNetworkImage(
                                      placeholder: Image.asset("images/imageplaceholder.png"),
                                      imageUrl: eventsByCategories["On-site"][index]
                                          .imageUrl,
                                      fit: BoxFit.cover)
                        )));
                      }),
                )
              ],
            ),
          )
        ],
      );
    } else {
      return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: Theme.of(context).brightness==Brightness.light?
                AssetImage("images/gifs/loaderlight.gif"):
                AssetImage("images/gifs/loaderdark.gif"),
                fit: BoxFit.fill)
        ),
      );
    }
  }

  void _onEntryAdded(Event event) {
    setState(() {
      eventsByCategories["All"].add(EventItem.fromSnapshot(event.snapshot));
      eventsByCategories[event.snapshot.value["category"]]
          .add(EventItem.fromSnapshot(event.snapshot));
      if(event.snapshot.value["category"]=="Workshops"||event.snapshot.value["category"]=="Games"||event.snapshot.value["category"]=="Ignitia"){
        eventsByCategories["Workshops and Special Attractions"].add(EventItem.fromSnapshot(event.snapshot));
      }
    });
  }

  void _onEntryChanged(Event event) {

    var oldEntry = eventsByCategories[event.snapshot.value["category"]]
        .singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      eventsByCategories[event.snapshot.value["category"]][
          eventsByCategories[event.snapshot.value["category"]]
              .indexOf(oldEntry)] = EventItem.fromSnapshot(event.snapshot);
    });
  }
}
