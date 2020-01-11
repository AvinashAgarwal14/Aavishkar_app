import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../../util/event_details.dart';
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

class _DashBoardLayoutState extends State<DashBoardLayout> {
  
  CarouselSlider instance;
  int j = 0;

  List carouselImageList;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;
  Map<String, List<EventItem>> eventsByCategories;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    eventsByCategories = {
      'All': new List(),
      'On-site': new List(),
      'Online': new List(),
      'Workshops': new List(),
      'Games': new List(),
      'Workshops and Special Attractions': new List(),
      'Talk': new List()
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
        eventsByCategories["Talk"].length != 0 &&
        eventsByCategories["All"].length >= 35) {
      carouselImageList = List(eventsByCategories["All"].length);
      return ListView(
        cacheExtent: MediaQuery.of(context).size.height * 2,
        children: <Widget>[
          //TODO Trending
          Container(
            color: Theme.of(context).brightness == Brightness.light
                ? Color.fromRGBO(232, 232, 232, 1.0)
                : Color.fromRGBO(80, 80, 80, 1.0),
            padding: new EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
            child: Column(
              children: <Widget>[
                Padding(
                    padding: new EdgeInsets.symmetric(vertical: 0.0),
                    child: instance),
                new CarouselSlider(
                  height: 270.0,
                  //TODO add the upcoming events as per the date
                  items: map<Widget>(carouselImageList, (index, i) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EventDetails(
                                  item: eventsByCategories["All"][index])),
                        );
                      },
                      child: new Container(
                          margin: new EdgeInsets.all(10.0),
                          child: new ClipRRect(
                              borderRadius: new BorderRadius.all(
                                  new Radius.circular(5.0)),
                              child: new Stack(
                                children: <Widget>[
                                  CachedNetworkImage(
                                      placeholder: (context, url) =>
                                          Image.asset(
                                              "images/imageplaceholder.png"),
                                      imageUrl: eventsByCategories["All"][index]
                                          .imageUrl,
                                      fit: BoxFit.cover,
                                      width: MediaQuery.of(context).size.width -
                                          10.0),
                                  new Positioned(
                                      bottom: 0.0,
                                      left: 30.0,
                                      right: 30.0,
                                      child: Container(
                                        height: 100.0,
                                        width: 200.0,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                              blurRadius: 3,
                                              spreadRadius: 1,
                                              color: Colors.blue[900]
                                                  .withOpacity(0.1),
                                            )
                                          ],
                                        ),
                                        margin: new EdgeInsets.all(5.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10,
                                                        horizontal: 10),
                                                child: Text(
                                                    eventsByCategories["All"]
                                                            [index]
                                                        .title,
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                    ))),
                                            Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 0.0,
                                                        horizontal: 10),
                                                child: Text(
                                                  eventsByCategories["All"]
                                                              [index]
                                                          .body
                                                          .substring(0, 90) +
                                                      " ...",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    color: Colors.black38,
                                                    fontSize: 12,
                                                  ),
                                                ))
                                          ],
                                        ),
                                      ))
                                ],
                              ))),
                    );
                  }).toList(),
                  autoPlay: true,
                  viewportFraction: 0.85,
                  aspectRatio: 16 / 9,
                  pauseAutoPlayOnTouch: Duration(seconds: 2),
                ),
              ],
            ),
          ),
          //TODO Online Events
          Container(
              padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child:
                        Text("Online Events", style: TextStyle(fontSize: 18.0)),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 5.0),
                    height: 200.0,
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
                                          item: eventsByCategories["Online"]
                                              [index])),
                                );
                              },
                              child: Container(
                                height: 150.0,
                                width: 150.0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      blurRadius: 3,
                                      spreadRadius: 1,
                                      color: Colors.blue[900].withOpacity(0.1),
                                    )
                                  ],
                                ),
                                margin: new EdgeInsets.all(5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                        height: 150.0,
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                            ),
                                            child: CachedNetworkImage(
                                                placeholder: (context, url) =>
                                                    Image.asset(
                                                        "images/imageplaceholder.png"),
                                                imageUrl:
                                                    eventsByCategories["Online"]
                                                            [index]
                                                        .imageUrl,
                                                height: double.infinity,
                                                width: double.infinity,
                                                fit: BoxFit.cover))),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 8),
                                        child: Text(
                                          eventsByCategories["Online"][index]
                                              .title,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500),
                                        ))
                                  ],
                                ),
                              ));
                        }),
                  ),
                ],
              )),
          //TODO Workshop And Games
          Container(
            color: Theme.of(context).brightness == Brightness.light
                ? Color.fromRGBO(232, 232, 232, 1.0)
                : Color.fromRGBO(80, 80, 80, 1.0),

            //color: Colors.grey.shade200,
            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Text(
                    "Workshops and Special Attractions ",
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 5.0),
                  height: 225.0,
                  width: MediaQuery.of(context).size.width,
                  child: Swiper(
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EventDetails(
                                      item: eventsByCategories[
                                              "Workshops and Special Attractions"]
                                          [index])),
                            );
                          },
                          child: new Container (
                            padding: EdgeInsets.only(bottom: 25.0),
                           child: new Column (
                             children: <Widget>[
                               new Container(
                                 child: new ClipRRect(
                                     borderRadius: new BorderRadius.all(
                                         new Radius.circular(5.0)),
                                     child: CachedNetworkImage(
                                         placeholder: (context, url) => Image.asset(
                                             "images/imageplaceholder.png"),
                                         imageUrl: eventsByCategories[
                                         "Workshops and Special Attractions"]
                                         [index]
                                             .imageUrl,
                                         fit: BoxFit.cover)),
                                 height: 150.0,
                               ),
                               Padding(
                                         padding:
                                         const EdgeInsets.symmetric(
                                             vertical: 10,
                                             horizontal: 10),
                                         child: Text(
                                           eventsByCategories[
                                           "Workshops and Special Attractions"]
                                           [index].title,
                                             textAlign: TextAlign.justify,
                                             style: TextStyle(
                                               fontWeight:
                                               FontWeight.bold,
                                             fontSize: 18,
                                             ),
                                   ),
                               )

                             ],
                           ),
                          ));
                    },
                    itemCount:
                        eventsByCategories["Workshops and Special Attractions"]
                            .length,
                    viewportFraction: 0.7,
                    scale: 0.9,
                    pagination: new SwiperPagination(
                        margin: new EdgeInsets.all(5.0)
                    ),
                  ),
                )
              ],
            ),
          ),
          //TODO On-Site Events
          Container(
            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Text(
                    "On-site Events ",
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 5.0),
                  height: 200.0,
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
                              height: 150.0,
                              width: 150.0,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    blurRadius: 3,
                                    spreadRadius: 1,
                                    color: Colors.blue[900].withOpacity(0.1),
                                  )
                                ],
                              ),
                              margin: new EdgeInsets.all(5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      height: 150.0,
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                          ),
                                          child: CachedNetworkImage(
                                              placeholder: (context, url) =>
                                                  Image.asset(
                                                      "images/imageplaceholder.png"),
                                              imageUrl:
                                                  eventsByCategories["On-site"]
                                                          [index]
                                                      .imageUrl,
                                              height: double.infinity,
                                              width: double.infinity,
                                              fit: BoxFit.cover))),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 8),
                                      child: Text(
                                        eventsByCategories["On-site"][index]
                                            .title,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                      ))
                                ],
                              ),
                            ));
                      }),
                )
              ],
            ),
          ),
          // TODO Talk
          Container(
            color: Theme.of(context).brightness == Brightness.light
                ? Color.fromRGBO(232, 232, 232, 1.0)
                : Color.fromRGBO(80, 80, 80, 1.0),
            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Text(
                    "Tech Talks ",
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 5.0),
                  height: 200.0,
                  //width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                      cacheExtent: 4000.0,
                      itemCount: eventsByCategories["Talk"].length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EventDetails(
                                        item: eventsByCategories["Talk"]
                                        [index])),
                              );
                            },
                            child: Container(
                              height: 150.0,
                              width: 150.0,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    blurRadius: 3,
                                    spreadRadius: 1,
                                    color: Colors.blue[900].withOpacity(0.1),
                                  )
                                ],
                              ),
                              margin: new EdgeInsets.all(5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      height: 150.0,
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                          ),
                                          child: CachedNetworkImage(
                                              placeholder: (context, url) =>
                                                  Image.asset(
                                                      "images/imageplaceholder.png"),
                                              imageUrl:
                                              eventsByCategories["Talk"]
                                              [index]
                                                  .imageUrl,
                                              height: double.infinity,
                                              width: double.infinity,
                                              fit: BoxFit.cover))),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 8),
                                      child: Text(
                                        eventsByCategories["Talk"][index]
                                            .title,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                      ))
                                ],
                              ),
                            ));
                      }),
                )
              ],
            ),
          ),
          SizedBox(height: 65.0),
        ],
      );
    } else {
      return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: Theme.of(context).brightness == Brightness.light
                    ? AssetImage("images/gifs/loaderlight.gif")
                    : AssetImage("images/gifs/loaderdark.gif"),
                fit: BoxFit.fill)),
      );
    }
  }

  void _onEntryAdded(Event event) {
    setState(() {
      eventsByCategories["All"].add(EventItem.fromSnapshot(event.snapshot));
      eventsByCategories[event.snapshot.value["category"]]
          .add(EventItem.fromSnapshot(event.snapshot));
      if (event.snapshot.value["category"] == "Workshops" ||
          event.snapshot.value["category"] == "Games") {
        eventsByCategories["Workshops and Special Attractions"]
            .add(EventItem.fromSnapshot(event.snapshot));
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
