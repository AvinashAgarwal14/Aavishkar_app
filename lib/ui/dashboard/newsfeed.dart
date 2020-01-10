import 'package:flutter/rendering.dart';
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
  List<NewsfeedItem> feed;

  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    feed = new List();

    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(15000000);
    databaseReference = database.reference().child("Posts");
    databaseReference.onChildAdded.listen(_onEntryAdded);
    databaseReference.onChildChanged.listen(_onEntryChanged);
  }

  @override
  Widget build(BuildContext context) {
    List reverseFeed=feed.reversed.toList();
    return
      (feed.length != 0)
        ? ListView.builder(
        //reverse: true,

            cacheExtent: MediaQuery.of(context).size.height * 3,
            itemCount: reverseFeed.length,
            itemBuilder: (BuildContext context, position) {
              return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FeedDetails(
                              post: reverseFeed[position])
                      ),
                    );
                  },
                  child: NewsfeedCards(cardItem: reverseFeed[position]));
            })
        :
      Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: Theme.of(context).brightness == Brightness.light
                        ? AssetImage("images/gifs/loaderlight.gif")
                        : AssetImage("images/gifs/loaderdark.gif"),
                    fit: BoxFit.cover)));
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

class NewsfeedCards extends StatefulWidget {
  NewsfeedCards({Key key, this.cardItem}) : super(key: key);
  final NewsfeedItem cardItem;
  @override
  _NewsfeedCardsState createState() => _NewsfeedCardsState();
}

class _NewsfeedCardsState extends State<NewsfeedCards> {
  @override
  Widget build(BuildContext context) {
    Widget card = new Card(
        child: new Column(
      children: <Widget>[
        new ClipRRect(
            borderRadius: new BorderRadius.only(
                topLeft: new Radius.circular(5.0),
                topRight: new Radius.circular(5.0)),
            child: Container(
                height: 256.0,
                child: SizedBox.expand(
                    child: Hero(
                        tag: widget.cardItem.key,
                        child: CachedNetworkImage(
                            placeholder: (context, url) =>
                                Image.asset("images/imageplaceholder.png"),
                            imageUrl: widget.cardItem.imageUrl,
                            fit: BoxFit.cover,
                            height: 256.0))))),
        ListTile(
            title: new Padding(
              padding: EdgeInsets.fromLTRB(0.0, 5.0, 5.0, 5.0),
              child: new Text(widget.cardItem.title),
            ),
            subtitle: new Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(0.0, 5.0, 5.0, 5.0),
                  alignment: Alignment.topLeft,
                  child:
                      new Text("${widget.cardItem.body.substring(0, 45)}..."),
                ),
                new Row(children: <Widget>[
                  new Padding(
                    padding: EdgeInsets.all(5.0),
                    child: new Row(
                      children: <Widget>[
                        Icon(Icons.thumb_up, size: 20.0,color: Color(0xFF505194),),
                        Padding(padding: EdgeInsets.only(left: 3.0)),
                        Text("${widget.cardItem.likesCount}")
                      ],
                    ),
                  ),
                  new Padding(
                    padding: EdgeInsets.all(5.0),
                    child: new Row(
                      children: <Widget>[
                        Icon(
                          Icons.comment,
                          size: 20.0,
                            color: Color(0xFF505194),
                        ),
                        Padding(padding: EdgeInsets.only(left: 3.0)),
                        Text("${widget.cardItem.commentsCount}")
                      ],
                    ),
                  ),
                  new Padding(
                    padding: EdgeInsets.all(5.0),
                    child: new Row(
                      children: <Widget>[
                        Icon(Icons.date_range, size: 20.0,color: Color(0xFF505194),),
                        Padding(padding: EdgeInsets.only(left: 3.0)),
                        Text(widget.cardItem.date)
                      ],
                    ),
                  ),
                ])
              ],
            ))
      ],
    ));
    return card;
  }
}
