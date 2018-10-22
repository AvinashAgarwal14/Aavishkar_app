import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../../model/newsfeed.dart';
import './comment_section.dart';
import './status_section.dart';
import '../../../util/detailSection.dart';

class FeedDetails extends StatefulWidget {

  final postKey;
  final commentCount;
  FeedDetails({Key key, this.postKey, this.commentCount}) : super(key: key);

  @override
  FeedDetailsState createState() => new FeedDetailsState();
}

enum AppBarBehavior { normal, pinned, floating, snapping }

class FeedDetailsState extends State<FeedDetails> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final double _appBarHeight = 256.0;

  NewsfeedItem post;
  FirebaseDatabase _database = FirebaseDatabase.instance;
  DatabaseReference _databaseReferenceForPosts;
  AppBarBehavior _appBarBehavior = AppBarBehavior.pinned;
  FirebaseUser currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
    _databaseReferenceForPosts = _database.reference().child("Posts");
    _databaseReferenceForPosts.onChildAdded.listen(_onPostEntryAddedOrUpdated);
    _databaseReferenceForPosts.onChildChanged.listen(_onPostEntryAddedOrUpdated);
  }

  @override
  Widget build(BuildContext context) {
    return  new Scaffold(
        key: _scaffoldKey,
        body: (post!=null)?new CustomScrollView(
          slivers: <Widget>[
            new SliverAppBar(
              expandedHeight: _appBarHeight,
              pinned: _appBarBehavior == AppBarBehavior.pinned,
              floating: _appBarBehavior == AppBarBehavior.floating || _appBarBehavior == AppBarBehavior.snapping,
              snap: _appBarBehavior == AppBarBehavior.snapping,
              flexibleSpace: new FlexibleSpaceBar(
                title: Text('${post.title}'),
                background: new Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    new Hero(
                        tag: widget.postKey,
                        child: CachedNetworkImage(
                            imageUrl: post.imageUrl,
                            fit: BoxFit.cover,
                            height: _appBarHeight
                        )),
                    // This gradient ensures that the toolbar icons are distinct
                    // against the background image.
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(0.0, -1.0),
                          end: Alignment(0.0, -0.4),
                          colors: <Color>[Color(0x60000000), Color(0x00000000)],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            new SliverList(
              delegate: new SliverChildListDelegate(<Widget>[
                new StatusCategory(
                  commentsCount: post.commentsCount,
                  postKey: widget.postKey,
                  date: post.date
                ),
                new DetailCategory(
                  icon: Icons.description ,
                  children: <Widget>[
                    new DetailItem(
                        tooltip: 'Details',
                        onPressed: null,
                        lines: <String>[
                          "${post.body}",
                          "Description"
                        ]
                    )
                  ],
                ),
//                new DetailCategory(
//                  icon: Icons.call,
//                  children: <Widget>[
//                    new DetailItem(
//                      tooltip: 'Send message',
//                      onPressed: () {
//                        launch("tel:8981866219");
//                      },
//                      lines: <String>[
//                        '${post.date}',
//                        '${post.date}',
//                      ],
//                    )
//                  ],
//                ),
                new CommentCategory(
                  postKey: widget.postKey,
                  commentCount: post.commentsCount
                )
              ]),
            ),
          ],
        ):CircularProgressIndicator(),
        bottomNavigationBar: new Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: new AddNewComment(
                postKey: widget.postKey,
                user: currentUser,
                parent: this,
                commentCount:widget.commentCount
            ),
        )
//      ),
    );
  }

  void _onPostEntryAddedOrUpdated (Event event) {
    setState(() {
      if(event.snapshot.key == widget.postKey)
        post = NewsfeedItem.fromSnapshot(event.snapshot);
    });
  }

  Future getUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    print(user);
    setState(() {
      currentUser = user;
    });
    print(currentUser);
  }

}
