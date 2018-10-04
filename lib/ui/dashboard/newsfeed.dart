import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../model/newsfeed.dart';
import 'package:aavishkarapp/ui/dashboard/newsfeed_details/feed_details.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Newsfeed extends StatefulWidget {
  @override
  _NewsfeedState createState() => _NewsfeedState();
}

class _NewsfeedState extends State<Newsfeed> {

  List <NewsfeedItem> feed;

  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    feed = new List();

    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
    databaseReference = database.reference().child("Posts");
    databaseReference.onChildAdded.listen(_onEntryAdded);
    databaseReference.onChildChanged.listen(_onEntryChanged);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: feed.length,
        itemBuilder: (BuildContext context, position) {
          return DecoratedBox(
            decoration: new BoxDecoration(color: Colors.grey.shade200),
            child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        FeedDetails(postKey: feed[position].key, commentCount: feed[position].commentsCount)),
                  );
                },
                child: new Card(
                    child: new Column(
                      children: <Widget>[
                        Hero(
                            tag: feed[position].key,
                            child: CachedNetworkImage(
                              placeholder: Image.asset("images/Pacman.gif"),
                                imageUrl: feed[position].imageUrl,
                                fit: BoxFit.cover,
                                height: 256.0
                            )),
                        ListTile(
                                title: new Padding(
                                    padding: EdgeInsets.fromLTRB(0.0, 5.0, 5.0, 5.0),
                                    child: new Text(feed[position].title),
                                ),
                                subtitle: new Column(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.fromLTRB(0.0, 5.0, 5.0, 5.0),
                                      alignment: Alignment.topLeft,
                                      child: new Text("${feed[position].body.substring(0,45)}..."),
                                    ),
                                    new Row(
                                        children: <Widget>[
                                          new Padding(
                                            padding: EdgeInsets.all(5.0),
                                            child: new Row(
                                              children: <Widget>[
                                                Icon(Icons.thumb_up, size: 20.0),
                                                Padding(
                                                    padding: EdgeInsets.only(left: 3.0)
                                                ),
                                                Text("${feed[position].likesCount}")
                                              ],
                                            ),
                                          ),
                                          new Padding(
                                            padding: EdgeInsets.all(5.0),
                                            child: new Row(
                                              children: <Widget>[
                                                Icon(Icons.comment, size: 20.0,),
                                                Padding(
                                                    padding: EdgeInsets.only(left: 3.0)
                                                ),
                                                Text("${feed[position].commentsCount}")
                                              ],
                                            ),
                                          ),
                                          new Padding(
                                            padding: EdgeInsets.all(5.0),
                                            child: new Row(
                                              children: <Widget>[
                                                Icon(Icons.date_range, size: 20.0),
                                                Padding(
                                                    padding: EdgeInsets.only(left: 3.0)
                                                ),
                                                Text(feed[position].date)
                                              ],
                                            ),
                                          ),
                                        ]
                                    )
                                  ],
                                )
                                )
                      ],
                    )
                )),
          );
        }
    );
  }

  void _onEntryAdded(Event event) {
    setState(() {
      feed.add(NewsfeedItem.fromSnapshot(event.snapshot));
    });
  }


  void _onEntryChanged(Event event) {
    var oldEntry = feed.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      feed[feed.indexOf(oldEntry)] = NewsfeedItem.fromSnapshot(event.snapshot);
    });
  }
}
