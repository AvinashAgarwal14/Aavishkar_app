import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../activities/events/event_details.dart';
import '../../model/event.dart';
import 'package:firebase_database/firebase_database.dart';

List<T> map<T>(List list, Function handler) {

  List<T> result = [];
  for (var i = 0; i < list.length; i  ++) {
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
  int j=0;

  List carouselImageList;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;
  Map<String, List<EventItem>> eventsByCategories;

  void initState() {
    // TODO: implement initState
    super.initState();

    eventsByCategories={
      'On-site':new List(),
      'Online': new List(),
      'Workshops':new List(),
      'Games': new List(),
      'Ignitia': new List()
    };
    print("GANGNUM ...$eventsByCategories");

    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
    databaseReference = database.reference().child("Events");
    databaseReference.onChildAdded.listen(_onEntryAdded);
    databaseReference.onChildChanged.listen(_onEntryChanged);

  }

  nextSlider() {
    instance.nextPage(duration: new Duration(milliseconds: 300), curve: Curves.linear);
  }

  prevSlider() {
    instance.previousPage(duration: new Duration(milliseconds: 800), curve: Curves.easeIn);
  }


  @override
  Widget build(BuildContext context) {
    if(eventsByCategories["Online"].length!=0 &&
        eventsByCategories["On-site"].length!=0 &&
        eventsByCategories["Workshops"].length!=0 &&
        eventsByCategories["Games"].length!=0 &&
        eventsByCategories["Ignitia"].length!=0
    ) {
       carouselImageList = List(eventsByCategories["Online"].length);
      return Scaffold(
          backgroundColor: Colors.white,
          body: ListView(shrinkWrap: true,
            children: <Widget>[
              //TODO Trending
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(child: Text("Trending ", style: TextStyle(fontSize: 18.0),)),
              ),
              Padding(
                  padding: new EdgeInsets.symmetric(vertical: 0.0),
                  child: instance
              ),
              Padding(
                  padding: new EdgeInsets.symmetric(vertical: 0.0),
                  child: new CarouselSlider(
                    //TODO add the upcoming events as per the date
                    items: map<Widget>(carouselImageList, (index, i) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>
                                EventDetails(
                                    item: eventsByCategories["Online"][index])),
                          );
                        },
                        child: new Container(
                            margin: new EdgeInsets.all(5.0),
                            child: new ClipRRect(
                                borderRadius: new BorderRadius.all(
                                    new Radius.circular(20.0)),
                                child: new Stack(
                                  children: <Widget>[
//                                    Hero(
//                                        tag: eventsByCategories["Online"][index].imageUrl,
//                                        child:
                                        CachedNetworkImage(
                                            imageUrl: eventsByCategories["Online"][index].imageUrl,
                                            fit: BoxFit.cover,
                                            width: MediaQuery.of(context).size.width- 10.0
//                                        )
                            ),
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
                                                )
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10.0, horizontal: 20.0),
                                            child: new Text("Date of the Event",
                                              style: new TextStyle(
                                                color: Colors.white,
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                        )
                                    ),
                                  ],
                                )
                            )
                        ),
                      );
                    }).toList(),
                    autoPlay: true,
                    viewportFraction: 0.9,
                    aspectRatio: 2.0,
                    interval: Duration(milliseconds: 2000),
                    autoPlayDuration: Duration(milliseconds: 800),

                  )
              ),


              //TODO Online Events
              Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Divider(color: Colors.black,height: 20.0,),
               ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Text(
                    "Online Events ", style: TextStyle(fontSize: 18.0),),
                ),
              ),
              Container(
                color: Colors.white,
                height: 150.0,
                // width: MediaQuery.of(context).size.width-10.0,
                child: ListView.builder(
                    itemCount: eventsByCategories["Online"].length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>
                                EventDetails(
                                    item: eventsByCategories["Online"][index])),
                          );
                        },
                        child: Container(
                            color: Colors.white,
                            height: 100.0,
                            width: 150.0,

                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Card(
                                child: Image.network(
                                  eventsByCategories["Online"][index].imageUrl,
                                  fit: BoxFit.cover,
                                ),),
                            )
                        ),
                      );
                    }
                ),
              ),


              //TODO Workshop And Games
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(color: Colors.black,height: 20.0,),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Text(
                    "Workshops and Games ", style: TextStyle(fontSize: 18.0),),
                ),
              ),
              Container(
                height: 200.0,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              EventDetails(
                                  item: eventsByCategories["Workshops"][index])),
                        );
                      },
                      child: new Image.network(
                        eventsByCategories["Workshops"][index].imageUrl,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                  itemCount: eventsByCategories["Workshops"].length,
                  itemWidth: 300.0,
                  layout: SwiperLayout.STACK,
                ),
              ),



              //TODO On-Site Events
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(color: Colors.black,height: 20.0,),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Text(
                    "On-site Events ", style: TextStyle(fontSize: 18.0),),
                ),
              ),
              Container(
                color: Colors.white,
                height: 150.0,
                //width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                    itemCount: eventsByCategories["On-site"].length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EventDetails(item: eventsByCategories["On-site"][index])),
                          );
                        },
                        child: Container(
                            color: Colors.white,
                            height: 100.0,
                            width: 150.0,
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Card(
                                child: Image.network(
                                  eventsByCategories["On-site"][index].imageUrl,
                                  fit: BoxFit.cover,
                                ),),
                            )
                        ),
                      );
                    }
                ),
              ),
              SizedBox(height: 20.0,),
            ],
          )
      );
   }
    else
      {
        return Scaffold(
          backgroundColor: Colors.white,
          body:Center(
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Waiting for network",style: TextStyle(fontSize: 18.0),),
               CircularProgressIndicator(
              ),
              ],
            )
          ),
        );
      }
  }


  void _onEntryAdded(Event event) {
    setState(() {
      eventsByCategories[event.snapshot.value["category"]].add(EventItem.fromSnapshot(event.snapshot));

      //print(eventsByCategories);
    });
  }


  void _onEntryChanged(Event event) {
    var oldEntry = eventsByCategories[event.snapshot.value["category"]].singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      eventsByCategories[event.snapshot.value["category"]][eventsByCategories[event.snapshot.value["category"]].indexOf(oldEntry)] = EventItem.fromSnapshot(event.snapshot);
    });
  }

}
