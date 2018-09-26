import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:aavishkarapp/model/posts_comment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../../model/newsfeed.dart';
import './comment_section.dart';
import './status_section.dart';

class DetailCategory extends StatelessWidget {
  const DetailCategory({ Key key, this.icon, this.children }) : super(key: key);

  final IconData icon;
  final List children;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return new Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: new BoxDecoration(
          border: new Border(bottom: new BorderSide(color: themeData.dividerColor))
      ),
      child: new DefaultTextStyle(
        style: Theme.of(context).textTheme.subhead,
        child: new SafeArea(
          top: false,
          bottom: false,
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  width: 72.0,
                  child: new Icon(icon, color: themeData.primaryColor)
              ),
              new Expanded(child: new Column(children: children))
            ],
          ),
        ),
      ),
    );
  }
}

class DetailItem extends StatelessWidget {
  DetailItem({ Key key, this.icon, this.lines, this.tooltip, this.onPressed })
      : assert(lines.length > 1),
        super(key: key);

  final IconData icon;
  final List<String> lines;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final List columnChildren = lines.sublist(0, lines.length - 1).map((String line) => new Text(line)).toList();
    columnChildren.add(new Text(lines.last, style: themeData.textTheme.caption));

    final List rowChildren = <Widget>[
      new Expanded(
          child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: columnChildren
          )
      )
    ];
    if (icon != null) {
      rowChildren.add(new SizedBox(
          width: 72.0,
          child: new IconButton(
              icon: new Icon(icon),
              color: themeData.primaryColor,
              onPressed: onPressed
          )
      ));
    }
    else
      {
        rowChildren.add(new SizedBox(
          width: 60.0,
          child: Container(),
        ));
      }
    return new MergeSemantics(
      child: new Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: rowChildren
          )
      ),
    );
  }
}

class FeedDetails extends StatefulWidget {

  final postKey;
  final commentCount;
  FeedDetails({Key key, this.postKey, this.commentCount}) : super(key: key);

  @override
  FeedDetailsState createState() => new FeedDetailsState();
}

enum AppBarBehavior { normal, pinned, floating, snapping }

class FeedDetailsState extends State<FeedDetails> {
  static final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
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
    return new Theme(
      data: new ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.indigo,
        platform: Theme.of(context).platform,
      ),
      child: new Scaffold(
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
                    new Image.network(
                      post.imageUrl,
                      fit: BoxFit.cover,
                      height: _appBarHeight,
                    ),
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
                  views: 100,
                ),
                new DetailCategory(
                  icon: Icons.description ,
                  children: <Widget>[
                    new DetailItem(
                        icon: null,
                        tooltip: 'Details',
                        onPressed: null,
                        lines: <String>[
                          "${post.body}",
                          "Hello"
                        ]
                    )
                  ],
                ),
                new DetailCategory(
                  icon: Icons.call,
                  children: <Widget>[
                    new DetailItem(
                      icon: Icons.dialpad,
                      tooltip: 'Send message',
                      onPressed: () {
                        launch("tel:8981866219");
                      },
                      lines: <String>[
                        '${post.date}',
                        '${post.date}',
                      ],
                    )
                  ],
                ),
                new CommentCategory(
                  postKey: widget.postKey,
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
                commentCount:widget.commentCount
            ),
        )
      ),
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
