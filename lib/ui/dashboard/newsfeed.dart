import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../model/newsfeed.dart';
import 'package:aavishkarapp/ui/dashboard/newsfeed_details/feed_details.dart';

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
                        Image.network(
                            feed[position].imageUrl, fit: BoxFit.cover),
                        ListTile(
                            title: new Text(feed[position].title),
                            subtitle: new Text(feed[position].date),
                            trailing: new Column(
                             children: <Widget>[
                               Icon(Icons.thumb_up),
                               Text("${feed[position].likesCount}")
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
